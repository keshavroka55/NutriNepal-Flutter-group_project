import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../api/api_service.dart';
import '../api/login_service.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void register() async {
    final response = await ApiService.registerUser(
      usernameController.text,
      emailController.text,
      passwordController.text,
    );

    if (response['user'] != null) {
      User user = User.fromJson(response['user']);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Registration Successful'),
          content: Text('Welcome, ${user.username}!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginPage()));
              },
              child: Text('Go to Login'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Registration Failed'),
          content: Text(response['message'] ?? 'Unknown error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue.shade300, Colors.blue.shade600]),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text('Register', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(labelText: 'Username'),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Password'),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: register,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        child: Text('Register', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (_) => LoginPage()));
                      },
                      child: Text('Already have an account? Login'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
