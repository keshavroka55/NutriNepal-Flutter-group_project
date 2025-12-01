import 'package:flutter/material.dart';
import 'package:nutrinepal_1/NutriNepal/Features/homepage.dart';

import '../../Features/Auth2/login_page.dart';



class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/success.jpeg', // welcome icon
              height: 150,
            ),
            SizedBox(height: 40),
            Text(
              'Welcome',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Start or sign in to your account',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                // here is the logic that if profile is not complete it redirect to the profile completion page.
                  // the HomeWrapper function.
                MaterialPageRoute(builder: (_) => HomeScreen(), // currently redirect to the login page.
                ),
                );
              },
              child: Text('Start'),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
