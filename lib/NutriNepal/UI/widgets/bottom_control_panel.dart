import 'package:flutter/material.dart';
import '../../Features/FoodScanning/food_recognition_screen.dart';
import '../../Features/food/food_screen.dart';
import '../../Features/homepage.dart';
import '../../Features/profile/profile_screen.dart';


class BottomControlPanel extends StatelessWidget {
  final int currentIndex;

  const BottomControlPanel({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNavButton(context, 0, Icons.home, 'HomePage', HomeScreen()),
        _buildNavButton(context, 1, Icons.add_circle, 'Add', FoodScreen()),
        _buildNavButton(context, 2, Icons.scanner, 'Scan', FoodRecognitionScreen()),
        _buildNavButton(context, 3, Icons.settings, 'Profile', ProfileScreen()),
      ],
    );
  }

  Widget _buildNavButton(
      BuildContext context, int index, IconData icon, String label, Widget page) {
    final isActive = index == currentIndex;

    return TextButton(
      onPressed: () {
        if (!isActive) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? Colors.blue : Colors.grey),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.blue : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
