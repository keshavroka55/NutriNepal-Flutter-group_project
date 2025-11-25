import 'package:flutter/material.dart';
import '../widgets/bottom_control_panel.dart';

class LabelScanFoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('⚙️ Settings')),
      body: Center(
        child: Text(
          'This is the food label scanning Page',
          style: TextStyle(fontSize: 22),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BottomControlPanel(currentIndex: 2),
      ),
    );
  }
}