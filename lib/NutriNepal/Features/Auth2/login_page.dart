// lib/NutriNepal/Features/Auth2/login_page2.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../API/api_client.dart';
import '../homepage.dart';
import 'auth_service.dart';
import 'register_page.dart';

class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen2> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final authService = Provider.of<AuthService>(context, listen: false);

    final result = await authService.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() => loading = false);

    // If token saved → login success
    if (authService.isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
      return;
    }

    // Show backend error
    final msg = result['error'] ?? result['message'] ?? 'Login failed';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) =>
                v == null || v.isEmpty ? "Email is required" : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (v) =>
                v == null || v.isEmpty ? "Password is required" : null,
              ),
              const SizedBox(height: 25),

              loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: login,
                child: const Text("Login"),
              ),

              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen2()),
                  );
                },
                child: const Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
