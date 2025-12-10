import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrinepal_1/NutriNepal/Features/FoodScanning/scan_model.dart';
import 'package:nutrinepal_1/NutriNepal/Features/FoodScanning/test.dart';
import '../../UI/splashes/app_colors.dart';
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
  bool isProcessing = false;
  String? processingType;
  FoodItem? detectedFood;
  bool showResult = false;

  /// Pick Image from Gallery
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
        showResult = false;
        detectedFood = null;
      });
    }
  }

  /// Take Photo with Camera
  Future<void> takePhoto() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
        showResult = false;
        detectedFood = null;
      });
    }
  }

  /// Food Detection - Detects ONE food item at a time
  Future<void> detectFood() async {
    if (selectedImage == null) {
      _showError("Please select an image first");
      return;
    }

    setState(() {
      isProcessing = true;
      processingType = "Food Recognition";
      detectedFood = null;
      showResult = false;
    });

    // Simulate API processing
    await Future.delayed(const Duration(seconds: 2));

    // Get random food from demo data
    final foods = DemoFoodData.foodItems;
    final random = DateTime.now().millisecondsSinceEpoch;
    final randomFood = foods[random % foods.length];

    setState(() {
      detectedFood = randomFood;
      isProcessing = false;
      processingType = null;
      showResult = true;
    });
  }

  /// Barcode Scan - Detects ONE product at a time
  Future<void> scanBarcode() async {
    if (selectedImage == null) {
      _showError("Please select an image first");
      return;
    }

    setState(() {
      isProcessing = true;
      processingType = "Barcode Scan";
      detectedFood = null;
      showResult = false;
    });

    // Simulate API processing
    await Future.delayed(const Duration(seconds: 2));

    // Get random product from demo data
    final products = DemoFoodData.barcodeProducts;
    final random = DateTime.now().millisecondsSinceEpoch;
    final randomProduct = products[random % products.length];

    setState(() {
      detectedFood = randomProduct;
      isProcessing = false;
      processingType = null;
      showResult = true;
    });
  }

  /// Add food to diary
  void addToDiary() {
    if (detectedFood == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${detectedFood!.name} to your diary'),
        backgroundColor: NutriColors.success,
        duration: const Duration(seconds: 2),
      ),
    );

    // In real app, you would save to backend here
    print('Added to diary: ${detectedFood!.toJson()}');
  }

  /// Show error message
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: NutriColors.danger,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NutriColors.background,
      appBar: AppBar(
        title: const Text(
          "Food Scanner",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: NutriColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: NutriColors.primary.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: NutriColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Scan Your Food",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: NutriColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Get instant nutrition information",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: NutriColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Image Preview Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        if (selectedImage != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              selectedImage!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: NutriColors.background,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: NutriColors.textSecondary.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.photo_camera,
                                  size: 50,
                                  color: NutriColors.textSecondary,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "No image selected",
                                  style: TextStyle(
                                    color: NutriColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 20),

                        // Image Selection Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: takePhoto,
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  side: BorderSide(color: NutriColors.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.camera_alt, size: 20),
                                label: const Text(
                                  "Camera",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: pickImage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: NutriColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.photo_library, size: 20),
                                label: const Text(
                                  "Gallery",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Scan Options
                  Row(
                    children: [
                      Expanded(
                        child: _buildScanButton(
                          icon: Icons.restaurant,
                          label: "Detect Food",
                          color: NutriColors.success,
                          onTap: detectFood,
                          isLoading: isProcessing && processingType == "Food Recognition",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildScanButton(
                          icon: Icons.qr_code_scanner,
                          label: "Scan Barcode",
                          color: NutriColors.primary,
                          onTap: scanBarcode,
                          isLoading: isProcessing && processingType == "Barcode Scan",
                        ),
                      ),
                    ],
                  ),

                  // Processing Indicator
                  if (isProcessing)
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            color: NutriColors.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            processingType == "Food Recognition"
                                ? "Identifying food item..."
                                : "Scanning barcode...",
                            style: TextStyle(
                              color: NutriColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Scan Result
                  if (showResult && detectedFood != null)
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      child: _buildFoodResultCard(detectedFood!),
                    ),

                  // Instruction Card (when no image selected)
                  if (selectedImage == null && !isProcessing && !showResult)
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_camera,
                            size: 48,
                            color: NutriColors.textSecondary,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "How to Scan",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: NutriColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInstructionStep(1, "Take a photo or choose from gallery"),
                          const SizedBox(height: 12),
                          _buildInstructionStep(2, "Select a scan option"),
                          const SizedBox(height: 12),
                          _buildInstructionStep(3, "View nutrition information"),
                        ],
                      ),
                    ),

                  // Ready to Scan Card (when image selected but not scanned)
                  if (selectedImage != null && !isProcessing && !showResult)
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.touch_app,
                            size: 48,
                            color: NutriColors.primary,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Ready to Scan",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: NutriColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Tap on a scan option above to analyze your image",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: NutriColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomControlPanel(currentIndex: 2),
    );
  }

  // Helper Widgets

  Widget _buildScanButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isLoading ? null : onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              if (isLoading)
                const SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: NutriColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodResultCard(FoodItem food) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Result Header
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: NutriColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: NutriColors.success,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Scan Successful!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: NutriColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      processingType == "Barcode Scan"
                          ? "Product identified"
                          : "Food item detected",
                      style: TextStyle(
                        color: NutriColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(height: 1),

          const SizedBox(height: 20),

          // Food Name
          Text(
            food.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: NutriColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Calories
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: NutriColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: NutriColors.accent,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  "${food.calories.round()} Calories",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: NutriColors.accent,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Macronutrients
          const Text(
            "Nutrition Information",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: NutriColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroCard(
                label: "Protein",
                value: "${food.protein.toStringAsFixed(1)}g",
                icon: Icons.fitness_center,
                color: const Color(0xFF4A90E2),
              ),
              _buildMacroCard(
                label: "Carbs",
                value: "${food.carbs.toStringAsFixed(1)}g",
                icon: Icons.energy_savings_leaf,
                color: const Color(0xFF7B68EE),
              ),
              _buildMacroCard(
                label: "Fat",
                value: "${food.fat.toStringAsFixed(1)}g",
                icon: Icons.water_drop,
                color: const Color(0xFFF5A623),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Add to Diary Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: addToDiary,
              style: ElevatedButton.styleFrom(
                backgroundColor: NutriColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Add to Food Diary",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Scan Again Button
          TextButton(
            onPressed: () {
              setState(() {
                showResult = false;
                detectedFood = null;
              });
            },
            child: Text(
              "Scan Another Item",
              style: TextStyle(
                color: NutriColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: NutriColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionStep(int number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: NutriColors.primary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              "$number",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: NutriColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}