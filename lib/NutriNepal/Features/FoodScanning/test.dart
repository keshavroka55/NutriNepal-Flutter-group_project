// lib/Features/food/demo_food_data.dart
import 'package:nutrinepal_1/NutriNepal/Features/FoodScanning/scan_model.dart';

class DemoFoodData {
  // Food items for food recognition
  static List<FoodItem> get foodItems => [
    FoodItem(
      name: "Apple",
      calories: 52,
      protein: 0.3,
      carbs: 14,
      fat: 0.2,
    ),
    FoodItem(
      name: "Chicken Breast",
      calories: 165,
      protein: 31,
      carbs: 0,
      fat: 3.6,
    ),
    FoodItem(
      name: "White Rice",
      calories: 130,
      protein: 2.7,
      carbs: 28,
      fat: 0.3,
    ),
    FoodItem(
      name: "Banana",
      calories: 89,
      protein: 1.1,
      carbs: 23,
      fat: 0.3,
    ),
    FoodItem(
      name: "Eggs",
      calories: 155,
      protein: 13,
      carbs: 1.1,
      fat: 11,
    ),
    FoodItem(
      name: "Broccoli",
      calories: 34,
      protein: 2.8,
      carbs: 7,
      fat: 0.4,
    ),
  ];

  // Products for barcode scanning
  static List<FoodItem> get barcodeProducts => [
    FoodItem(
      name: "Protein Bar",
      calories: 250,
      protein: 20,
      carbs: 22,
      fat: 8,
    ),
    FoodItem(
      name: "Greek Yogurt",
      calories: 130,
      protein: 23,
      carbs: 9,
      fat: 0.4,
    ),
    FoodItem(
      name: "Granola",
      calories: 471,
      protein: 10,
      carbs: 64,
      fat: 20,
    ),
  ];
}