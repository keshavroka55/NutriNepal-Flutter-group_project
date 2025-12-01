// lib/src/features/food/food_model.dart
// Food model matches your backend FoodSchema fields you provided.

class Food {
  final String id;
  final String nameEn;
  final String? nameNp;
  final double servingSize;
  final String unit;
  final double caloriesKcal;
  final double proteinG;
  final double fatG;
  final double carbsG;
  final String? category;

  Food({
    required this.id,
    required this.nameEn,
    this.nameNp,
    required this.servingSize,
    required this.unit,
    required this.caloriesKcal,
    required this.proteinG,
    required this.fatG,
    required this.carbsG,
    this.category,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['_id'] ?? json['id'] ?? '',
      nameEn: json['name_en'] ?? '',
      nameNp: json['name_np'],
      servingSize: (json['serving_size']?.toDouble() ?? 0.0),
      unit: json['serving_unit'] ?? 'g',
      caloriesKcal: (json['calories_kcal']?.toDouble() ?? 0.0),
      proteinG: (json['protein_g']?.toDouble() ?? 0.0),
      fatG: (json['fat_g']?.toDouble() ?? 0.0),
      carbsG: (json['carbs_g']?.toDouble() ?? 0.0),
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name_en': nameEn,
      'name_np': nameNp,
      'serving_size': servingSize,
      'serving_unit': unit,
      'calories_kcal': caloriesKcal,
      'protein_g': proteinG,
      'fat_g': fatG,
      'carbs_g': carbsG,
      'category': category,
    };
  }
}
