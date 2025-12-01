// lib/src/features/logs/user_log_model.dart
// Model for user logs returned by /api/logs/add and /api/logs/history
import '../food/food_model.dart';

class UserLog {
  final String id;
  final String userId;
  final Food? food;
  final double quantity;
  final String unit;
  final DateTime timestamp;

  // optional stored totals
  final double? caloriesKcal;
  final double? proteinG;
  final double? fatG;
  final double? carbsG;

  UserLog({
    required this.id,
    required this.userId,
    this.food,
    required this.quantity,
    required this.unit,
    required this.timestamp,
    this.caloriesKcal,
    this.proteinG,
    this.fatG,
    this.carbsG,
  });

  factory UserLog.fromJson(Map<String, dynamic> json) {
    return UserLog(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['user']?.toString() ?? '',
      food: json['food'] != null ? Food.fromJson(Map<String, dynamic>.from(json['food'])) : null,
      quantity: (json['quantity']?.toDouble() ?? 0.0),
      unit: json['unit'] ?? 'g',
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now(),
      caloriesKcal: json['calories_kcal'] != null ? (json['calories_kcal']?.toDouble() ?? 0.0) : null,
      proteinG: json['protein_g'] != null ? (json['protein_g']?.toDouble() ?? 0.0) : null,
      fatG: json['fat_g'] != null ? (json['fat_g']?.toDouble() ?? 0.0) : null,
      carbsG: json['carbs_g'] != null ? (json['carbs_g']?.toDouble() ?? 0.0) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'food': food?.toJson(),
      'quantity': quantity,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
      'calories_kcal': caloriesKcal,
      'protein_g': proteinG,
      'fat_g': fatG,
      'carbs_g': carbsG,
    };
  }
}
