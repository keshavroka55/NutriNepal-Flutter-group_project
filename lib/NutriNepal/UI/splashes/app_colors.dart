// lib/constants/app_colors.dart
import 'package:flutter/material.dart';

/// Central place for all colors used in NutriNepal app
/// Using named constants makes it super easy to change the whole app look in one place!
class NutriColors {
  // BRAND / PRIMARY COLORS
  static const Color primary = Color(0xFF00695C);
  // Main brand color → Deep Teal-Green (feels healthy, natural, premium)

  static const Color primaryDark = Color(0xFF004D40);
  // Darker version → Perfect for Splash screen background & AppBar
  // ACCENT / CALL-TO-ACTION COLORS
  static const Color accent = Color(0xFFFF6F00);
  // Vibrant Orange → Used for important buttons (Scan, Start, Save, etc.)

  static const Color accentLight = Color(0xFFFFA040);
  // Lighter orange → For hover states, secondary buttons, or progress fills
  // BACKGROUND & SURFACES
  static const Color background = Color(0xFFFAFAFA);
  // Very light gray → Main app background (clean & soft on eyes)

  static const Color surface = Colors.white;
  // Pure white → Cards, bottom sheets, dialogs
  // FEEDBACK COLORS (Success / Warning / Error)
  static const Color success = Color(0xFF43A047);
  // Healthy green → "Goal achieved", "Good food", checkmarks

  static const Color warning = Color(0xFFF57C00);
  // Caution orange → "High calories", "Moderate", alert icons
  static const Color danger = Color(0xFFE53935);
  // Red → "Too much sugar", "Avoid", error messages
  static const Color textPrimary = Color(0xFF212121);
  // Almost black → Main titles, body text (maximum readability)
  static const Color textSecondary = Color(0xFF757575);
// Medium gray → Hints, subtitles, labels, disabled text
}