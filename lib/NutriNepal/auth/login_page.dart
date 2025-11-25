import 'package:flutter/material.dart';
import '../Homepage_features/Food_list_screen.dart';
import '../api/login_service.dart';
import '../models/user_model.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    final response = await ApiService.loginUser(
      emailController.text,
      passwordController.text,
    );

    if (response['user'] != null) {
      User user = User.fromJson(response['user']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => FoodListScreen()), // for homescreen
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Login Failed'),
          content: Text(response['message'] ?? 'Invalid credentials'),
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
          gradient: LinearGradient(colors: [Colors.purple.shade300, Colors.purple.shade600]),
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
                    Text('Login', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
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
                      onPressed: login,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        child: Text('Login', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (_) => RegisterPage()));
                      },
                      child: Text('Don’t have an account? Register'),
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
