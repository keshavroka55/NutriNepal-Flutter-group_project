import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../UI/splashes/app_colors.dart';
import 'auth_service.dart';
import 'login_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> register() async {
    // 1) Validate form before calling API
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      final result = await authService.register(
        usernameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      setState(() => loading = false);

      // If register succeeded (ok == true)
      if (result['ok'] == true) {
        // If backend returned a token during register
        if (result['token'] != null) {
          // already saved by AuthService._saveToken -> navigate
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/homepage');
          return;
        }

        // Backend succeeded but did NOT return a token:
        // Try to login automatically (your backend currently returns user only)
        final loginResult = await authService.login(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        if (loginResult['ok'] == true && loginResult['token'] != null) {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/homepage');
          return;
        } else {
          final msg = loginResult['message'] ?? loginResult['error'] ?? 'Registered but auto-login failed.';
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: NutriColors.warning,
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
      } else {
        // REGISTER FAILED -> parse and show backend message (covers "User already exists")
        final backendMessage = result['message'] ??
            result['error'] ??
            (result['data'] is Map ? (result['data']['message'] ?? result['data']['error']) : null) ??
            'Registration failed';

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(backendMessage),
            backgroundColor: NutriColors.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    } catch (e) {
      setState(() => loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: $e'),
          backgroundColor: NutriColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NutriColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Logo and Welcome
                Column(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/nutrinepal.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: NutriColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Start your nutrition journey with us",
                      style: TextStyle(
                        fontSize: 16,
                        color: NutriColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Registration Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Username Field
                      Text(
                        "Username",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: NutriColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            hintText: "Choose a username",
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: NutriColors.textSecondary,
                            ),
                          ),
                          style: TextStyle(color: NutriColors.textPrimary),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username is required';
                            }
                            if (value.length < 3) {
                              return 'Username must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Email Field
                      Text(
                        "Email",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: NutriColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "you@example.com",
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: NutriColors.textSecondary,
                            ),
                          ),
                          style: TextStyle(color: NutriColors.textPrimary),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            if (!value.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Password Field
                      Text(
                        "Password",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: NutriColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: "Create a strong password",
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outlined,
                              color: NutriColors.textSecondary,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: NutriColors.textSecondary,
                              ),
                            ),
                          ),
                          style: TextStyle(color: NutriColors.textPrimary),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Confirm Password Field
                      Text(
                        "Confirm Password",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: NutriColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            hintText: "Re-enter your password",
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            prefixIcon: Icon(
                              Icons.lock_reset_outlined,
                              color: NutriColors.textSecondary,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: NutriColors.textSecondary,
                              ),
                            ),
                          ),
                          style: TextStyle(color: NutriColors.textPrimary),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Password requirements
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Password must contain:",
                            style: TextStyle(
                              fontSize: 12,
                              color: NutriColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                passwordController.text.length >= 6
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                size: 14,
                                color: passwordController.text.length >= 6
                                    ? NutriColors.success
                                    : NutriColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "At least 6 characters",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: passwordController.text.length >= 6
                                      ? NutriColors.success
                                      : NutriColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Register Button
                      ElevatedButton(
                        onPressed: loading ? null : register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: NutriColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: loading
                            ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Divider with OR text
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: NutriColors.textSecondary.withOpacity(0.3),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Already have an account?",
                              style: TextStyle(
                                color: NutriColors.textSecondary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: NutriColors.textSecondary.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Login Button
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: NutriColors.accent,
                          side: BorderSide(color: NutriColors.accent),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Sign In Instead",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Terms and Privacy
                Text(
                  "By creating an account, you agree to our Terms of Service and Privacy Policy",
                  style: TextStyle(
                    fontSize: 12,
                    color: NutriColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}