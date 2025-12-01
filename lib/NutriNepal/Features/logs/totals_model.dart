// lib/src/features/logs/totals_model.dart
// Represents response returned by GET /api/logs/totals

class Totals {
  final double caloriesKcal;
  final double proteinG;
  final double fatG;
  final double carbsG;
  final int count;

  Totals({
    required this.caloriesKcal,
    required this.proteinG,
    required this.fatG,
    required this.carbsG,
    required this.count,
  });

  factory Totals.fromJson(Map<String, dynamic> json) {
    final totals = json['totals'] ?? {};
    return Totals(
      caloriesKcal: (totals['calories_kcal']?.toDouble() ?? 0.0),
      proteinG: (totals['protein_g']?.toDouble() ?? 0.0),
      fatG: (totals['fat_g']?.toDouble() ?? 0.0),
      carbsG: (totals['carbs_g']?.toDouble() ?? 0.0),
      count: (json['count']?.toInt() ?? 0),
    );
  }
}
