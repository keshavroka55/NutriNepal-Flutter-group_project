// lib/NutriNepal/Features/Auth2/register_page2.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import '../homepage.dart';

class RegisterScreen2 extends StatefulWidget {
  const RegisterScreen2({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen2> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  Future<void> register() async {
    // 1) Validate form before calling API
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      final result = await authService.register(
        usernameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      setState(() => loading = false);

      // If register succeeded (ok == true)
      if (result['ok'] == true) {
        // If backend returned a token during register
        if (result['token'] != null) {
          // already saved by AuthService._saveToken -> navigate
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
          return;
        }

        // Backend succeeded but did NOT return a token:
        // Try to login automatically (your backend currently returns user only)
        final loginResult = await authService.login(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        if (loginResult['ok'] == true && loginResult['token'] != null) {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
          return;
        } else {
          final msg = loginResult['message'] ?? loginResult['error'] ?? 'Registered but auto-login failed.';
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
          return;
        }
      } else {
        // REGISTER FAILED -> parse and show backend message (covers "User already exists")
        // Try several common locations where backend might put the message:
        final backendMessage = result['message'] ??
            result['error'] ??
            (result['data'] is Map ? (result['data']['message'] ?? result['data']['error']) : null) ??
            'Registration failed';

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(backendMessage)));
        return;
      }
    } catch (e) {
      setState(() => loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // USERNAME
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (v) =>
                v == null || v.isEmpty ? "Username is required" : null,
              ),
              const SizedBox(height: 10),

              // EMAIL
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) =>
                v == null || v.isEmpty ? "Email is required" : null,
              ),
              const SizedBox(height: 10),

              // PASSWORD
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (v) =>
                v == null || v.isEmpty ? "Password is required" : null,
              ),
              const SizedBox(height: 20),

              loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: register,
                child: const Text("Register"),
              ),

              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
