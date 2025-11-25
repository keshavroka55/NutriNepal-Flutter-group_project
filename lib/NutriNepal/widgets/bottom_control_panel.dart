import 'package:flutter/material.dart';
import '../Homepage_features/Food_list_screen.dart';
import '../MainPages/Camera_food_scanner.dart';
import '../MainPages/Label_scan_food.dart';
import '../MainPages/Profile_page.dart';


class BottomControlPanel extends StatelessWidget {
  final int currentIndex;

  const BottomControlPanel({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNavButton(context, 0, Icons.home, 'Home', FoodListScreen()),
        _buildNavButton(context, 1, Icons.search, 'Search', CameraFoodPage()),
        _buildNavButton(context, 2, Icons.add_circle, 'Add', LabelScanFoodPage()),
        _buildNavButton(context, 3, Icons.settings, 'Settings', ProfilePage()),
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
