import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Features/Auth2/auth_service.dart';
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

    // Initialize and navigate
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    // Navigate after delay (total 3 seconds including animation)
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _navigateBasedOnAuth();
      }
    });
  }

  void _navigateBasedOnAuth() {
    final authService = context.read<AuthService>();

    // Add a small delay to ensure token validation completes
    Future.delayed(Duration(milliseconds: 500), () {
      if (authService.isLoggedIn) {
        // User has valid token, go to homepage
        Navigator.pushReplacementNamed(context, '/homepage');
      } else {
        // User is not logged in or token invalid, go to onboarding
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
      backgroundColor: NutriColors.primaryDark,
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
                    fit: BoxFit.cover,
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