import 'package:flutter/material.dart';

import 'app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Fade-in animation (0.0 → 1.0 over 1.2 seconds)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    // Navigate after delay (you can adjust timing)
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding1');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive logo size: ~30% of screen width, max 180
    final double logoSize = MediaQuery.of(context).size.width * 0.35;
    final double maxLogoSize = 180.0;

    return Scaffold(
      backgroundColor: NutriColors.primaryDark, // Deep purple background (your brand)
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Perfectly round logo with no border
                ClipOval(
                  child: Image.asset(
                    'assets/images/nutrinepal.png',
                    width: logoSize.clamp(100.0, maxLogoSize),
                    height: logoSize.clamp(100.0, maxLogoSize),
                    fit: BoxFit.cover, // Important for transparent PNGs
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  "NutriNepal",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Your journey to better nutrition",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}