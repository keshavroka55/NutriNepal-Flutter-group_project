class FoodItem {
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double quantity;
  final String unit;

  FoodItem({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.quantity = 100,
    this.unit = "g",
  });

  // Factory constructor for creating from JSON
  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name']?.toString() ?? 'Unknown',
      calories: (json['calories'] ?? 0.0).toDouble(),
      protein: (json['protein'] ?? 0.0).toDouble(),
      carbs: (json['carbs'] ?? 0.0).toDouble(),
      fat: (json['fat'] ?? 0.0).toDouble(),
      quantity: (json['quantity'] ?? 100.0).toDouble(),
      unit: json['unit']?.toString() ?? 'g',
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'quantity': quantity,
      'unit': unit,
    };
  }

  // Copy with method
  FoodItem copyWith({
    String? name,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? quantity,
    String? unit,
  }) {
    return FoodItem(
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }

  // Get nutrition summary
  String get nutritionSummary {
    return '${calories.round()} Cal | P: ${protein.round()}g | C: ${carbs.round()}g | F: ${fat.round()}g';
  }

  // Get serving info
  String get servingInfo {
    return '${quantity.toStringAsFixed(0)}$unit';
  }

  @override
  String toString() {
    return 'FoodItem(name: $name, calories: $calories, protein: $protein, carbs: $carbs, fat: $fat)';
  }
}

// Optional: Demo food data generator
class DemoFoods {
  static List<FoodItem> get demoFoods => [
    FoodItem(
      name: "Apple",
      calories: 52,
      protein: 0.3,
      carbs: 14,
      fat: 0.2,
      quantity: 100,
      unit: "g",
    ),
    FoodItem(
      name: "Chicken Breast",
      calories: 165,
      protein: 31,
      carbs: 0,
      fat: 3.6,
      quantity: 100,
      unit: "g",
    ),
    FoodItem(
      name: "White Rice",
      calories: 130,
      protein: 2.7,
      carbs: 28,
      fat: 0.3,
      quantity: 100,
      unit: "g",
    ),
    FoodItem(
      name: "Banana",
      calories: 89,
      protein: 1.1,
      carbs: 23,
      fat: 0.3,
      quantity: 100,
      unit: "g",
    ),
    FoodItem(
      name: "Eggs",
      calories: 155,
      protein: 13,
      carbs: 1.1,
      fat: 11,
      quantity: 100,
      unit: "g",
    ),
    FoodItem(
      name: "Broccoli",
      calories: 34,
      protein: 2.8,
      carbs: 7,
      fat: 0.4,
      quantity: 100,
      unit: "g",
    ),
  ];

  static List<FoodItem> get barcodeProducts => [
    FoodItem(
      name: "Protein Bar",
      calories: 250,
      protein: 20,
      carbs: 22,
      fat: 8,
      quantity: 60,
      unit: "g",
    ),
    FoodItem(
      name: "Greek Yogurt",
      calories: 130,
      protein: 23,
      carbs: 9,
      fat: 0.4,
      quantity: 170,
      unit: "g",
    ),
    FoodItem(
      name: "Granola",
      calories: 471,
      protein: 10,
      carbs: 64,
      fat: 20,
      quantity: 100,
      unit: "g",
    ),
  ];
}