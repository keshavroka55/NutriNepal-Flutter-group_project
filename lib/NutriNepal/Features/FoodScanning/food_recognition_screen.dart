import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../UI/widgets/bottom_control_panel.dart';
import 'logmeal_service.dart';

class FoodRecognitionScreen extends StatefulWidget {
  @override
  State<FoodRecognitionScreen> createState() => _FoodRecognitionScreenState();
}

class _FoodRecognitionScreenState extends State<FoodRecognitionScreen> {
  final picker = ImagePicker();
  final logMeal = LogMealService();

  File? selectedImage;
  String resultText = "No result yet";

  /// Pick Image
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  /// Call LogMeal Food Detection API
  Future<void> detectFood() async {
    if (selectedImage == null) {
      setState(() => resultText = "❌ No image selected");
      return;
    }

    try {
      final result = await logMeal.recognizeFood(selectedImage!);
      setState(() => resultText = jsonEncode(result));
    } catch (e) {
      setState(() => resultText = "ERROR: $e");
    }
  }

  /// Call LogMeal Barcode Scan API
  Future<void> scanBarcode() async {
    if (selectedImage == null) {
      setState(() {
        resultText = "No image selected";
      });
      return;
    }
    try {
      final result = await logMeal.scanBarcode(selectedImage!);
      setState(() => resultText = jsonEncode(result));

    }catch (e) {
      setState(() => resultText = "ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Food Scanner")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (selectedImage != null)
              Image.file(selectedImage!, height: 200),
            ElevatedButton(
              onPressed: pickImage,
              child: Text("Pick Image"),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: detectFood,
                    child: Text("Food Recognition"),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: scanBarcode,
                    child: Text("Barcode Scan"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(resultText),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomControlPanel(currentIndex: 2),
    );
  }
}
