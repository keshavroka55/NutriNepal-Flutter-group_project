// lib/screens/onboarding3.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class Onboarding3 extends StatelessWidget {
  const Onboarding3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: NutriColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Beautiful goal-setting illustration with premium shadow
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
                    'assets/images/three.jpeg', // Goal setting / progress illustration
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Powerful, motivational title
              Text(
                'Set Goals & Transform',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: NutriColors.primaryDark,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 20),

              // Inspiring description
              Text(
                'Create personalized nutrition & fitness goals. '
                    'Track every step, celebrate wins, and become the healthiest version of yourself — with Nepal’s trusted companion by your side 🌱',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: NutriColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 3),

              // Final action: Back + BIG "Get Started" button
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
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

                    // Prominent "Let’s Go" button (feels like the grand finale!)
                    FloatingActionButton.extended(
                      backgroundColor: NutriColors.accent, // Energetic orange
                      elevation: 10,
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/welcome', // or '/home', '/login', etc.
                              (route) => false,
                        );
                      },
                      label: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      icon: const Icon(Icons.arrow_forward_ios, size: 24),
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