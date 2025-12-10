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

              // CHANGED: Replace Spacer with SizedBox for fixed gap
              const SizedBox(height: 20), // Fixed gap instead of flexible spacer

              // Final action: Back + "Get Started" button
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0), // CHANGED: Increased bottom padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Subtle Back button
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

                    // CHANGED: Using ElevatedButton instead of FloatingActionButton.extended for better control
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/onboarding3', // or '/home', '/login', etc.
                              (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NutriColors.accent, // Energetic orange
                        foregroundColor: Colors.white,
                        elevation: 10,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50), // Pill shape
                        ),
                        shadowColor: Colors.black.withOpacity(0.2),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 16, // CHANGED: Slightly smaller font
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(width: 8), // Space between text and icon
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16, // CHANGED: Smaller icon
                          ),
                        ],
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