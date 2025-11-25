import 'food.dart';

class UserLog {
  final String id;
  final String userId;
  final Food food; // populated food
  final double quantity;
  final String unit;
  final DateTime timestamp;
  final double? calories;
  final double? protein;
  final double? fat;
  final double? carbs;

  UserLog({
    required this.id,
    required this.userId,
    required this.food,
    required this.quantity,
    required this.unit,
    required this.timestamp,
    this.calories, this.protein, this.fat, this.carbs
  });

  factory UserLog.fromJson(Map<String,dynamic> j) => UserLog(
    id: j['_id'] ?? '',
    userId: j['user'] is String ? j['user'] : (j['user']?['_id'] ?? ''),
    food: Food.fromJson(j['food']),
    quantity: (j['quantity'] ?? 0).toDouble(),
    unit: j['unit'] ?? 'g',
    timestamp: DateTime.parse(j['timestamp'] ?? j['createdAt'] ?? DateTime.now().toIso8601String()),
    calories: j['calories_kcal'] != null ? (j['calories_kcal']).toDouble() : null,
    protein: j['protein_g'] != null ? (j['protein_g']).toDouble() : null,
    fat: j['fat_g'] != null ? (j['fat_g']).toDouble() : null,
    carbs: j['carbs_g'] != null ? (j['carbs_g']).toDouble() : null,
  );
}
