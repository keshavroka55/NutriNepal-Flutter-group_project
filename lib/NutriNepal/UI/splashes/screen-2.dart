// lib/screens/onboarding2.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: NutriColors.background, // Clean light gray background

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Beautiful responsive illustration with soft shadow
              Container(
                height: size.height * 0.45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset(
                    'assets/images/two.jpg', // Your tracking/food logging illustration
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Bold, brand-colored title
              Text(
                'Effortless Tracking',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: NutriColors.primaryDark,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 20),

              // Friendly, readable description
              Text(
                'Log your meals, snacks, water, and exercise in seconds. '
                    'No complicated forms — just tap, search, or scan!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: NutriColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 3),

              // Bottom navigation: Back + Next (big orange button)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button — clear but not distracting
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 16,
                          color: NutriColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Big energetic Next button
                    FloatingActionButton.large(
                      backgroundColor: NutriColors.accent, // Vibrant orange
                      elevation: 8,
                      onPressed: () => Navigator.pushNamed(context, '/onboarding3'),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}