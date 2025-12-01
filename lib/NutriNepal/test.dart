import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing Page'),
      ),
      body: const Center(
        child: Text(
          'This is a simple testing page!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
