import 'package:flutter/material.dart';
import 'package:nutrinepal_1/NutriNepal/UI/widgets/testing.dart';
import 'package:provider/provider.dart';
import '../../Features/FoodScanning/food_recognition_screen.dart';
import '../../Features/food/food_screen2.dart';
import '../../Features/homepage2.dart';
import '../../Features/logs/logs_api.dart';
import '../../Features/logs/user_log_model.dart';
import '../../Features/profile/profile_api.dart';
import '../../Features/profile/profile_model.dart';
import '../../Features/profile/profile_screen2.dart';
import '../splashes/app_colors.dart';

class BottomControlPanel extends StatelessWidget {
  final int currentIndex;
  final Future<List<UserLog>> Function()? logsHistory;
  final Future<UserProfile?> Function()? fetchProfile;

  const BottomControlPanel({
    super.key,
    required this.currentIndex,
    this.logsHistory,
    this.fetchProfile,
  });

  @override
  Widget build(BuildContext context) {
    final logsApi = Provider.of<LogsApi>(context, listen: false);
    final profileApi = Provider.of<ProfileApi>(context, listen: false);

    final historyFn = logsHistory ?? logsApi.getHistory;
    final profileFn = fetchProfile ?? profileApi.getProfile;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              index: 0,
              icon: Icons.home_outlined,
              activeIcon: Icons.home_filled,
              label: 'Home',
              page: DailyNutritionDashboard(
                getHistory: historyFn,
                getProfile: profileFn,
              ),
            ),
            _buildNavItem(
              context: context,
              index: 1,
              icon: Icons.add_circle_outline,
              activeIcon: Icons.add_circle,
              label: 'Add',
              page: FoodScreen2(),
            ),
            _buildNavItem(
              context: context,
              index: 2,
              icon: Icons.camera_alt_outlined,
              activeIcon: Icons.camera_alt,
              label: 'Scan',
              page: FoodRecognitionScreen(),
            ),
            _buildNavItem(
              context: context,
              index: 3,
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'Profile',
              page: ProfileScreen2(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Widget page,
  }) {
    final isActive = index == currentIndex;

    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => page,
              transitionDuration: const Duration(milliseconds: 300),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
          color: NutriColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? NutriColors.primary : NutriColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? NutriColors.primary : NutriColors.textSecondary,
                letterSpacing: isActive ? 0.2 : 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}