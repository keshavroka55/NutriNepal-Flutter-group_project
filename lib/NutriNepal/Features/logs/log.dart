class Log {
  final String id;
  final String foodId;
  final String foodName;
  final double quantity;
  final String unit;
  final double caloriesKcal;
  final double proteinG;
  final double fatG;
  final double carbsG;
  final DateTime timestamp;

  Log({
    required this.id,
    required this.foodId,
    required this.foodName,
    required this.quantity,
    required this.unit,
    required this.caloriesKcal,
    required this.proteinG,
    required this.fatG,
    required this.carbsG,
    required this.timestamp,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    final food = json['food'] ?? {};
    return Log(
      id: json['_id'] ?? '',
      foodId: food['_id'] ?? '',
      foodName: food['name_en'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      unit: json['unit'] ?? food['serving_unit'] ?? 'g',
      caloriesKcal: (json['calories_kcal'] ?? 0).toDouble(),
      proteinG: (json['protein_g'] ?? 0).toDouble(),
      fatG: (json['fat_g'] ?? 0).toDouble(),
      carbsG: (json['carbs_g'] ?? 0).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'foodName': foodName,
      'quantity': quantity,
      'unit': unit,
      'calories_kcal': caloriesKcal,
      'protein_g': proteinG,
      'fat_g': fatG,
      'carbs_g': carbsG,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
