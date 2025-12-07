// lib/screens/onboarding1.dart
import 'package:flutter/material.dart';

import 'app_colors.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: NutriColors.background, // Clean light background

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Responsive & beautifully framed illustration
              Container(
                height: size.height * 0.45, // Takes ~45% of screen height
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
                    'assets/images/one.jpeg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Motivational title with brand touch
              Text(
                'Welcome to NutriNepal!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: NutriColors.primaryDark,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 20),

              // Subtitle with perfect readability
              Text(
                'Congratulations on taking the first step towards a healthier, happier you with Nepal\'s own nutrition companion 🌱',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: NutriColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 3),

              // Modern bottom actions: Skip + Big Orange Next Button
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Skip button - subtle but clear
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 16,
                          color: NutriColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Big, energetic Next button
                    FloatingActionButton.large(
                      backgroundColor: NutriColors.accent, // Our vibrant orange!
                      elevation: 8,
                      onPressed: () => Navigator.pushNamed(context, '/onboarding2'),
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