class Food {
  final String id;
  final String nameEn;
  final String? nameNp;
  final double servingSize; // e.g., 100
  final String servingUnit; // 'g' or 'piece'
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final String? category;

  Food({
    required this.id,
    required this.nameEn,
    this.nameNp,
    required this.servingSize,
    required this.servingUnit,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    this.category
  });

  factory Food.fromJson(Map<String,dynamic> j) => Food(
    id: j['_id'] ?? j['id'] ?? '',
    nameEn: j['name_en'] ?? '',
    nameNp: j['name_np'],
    servingSize: (j['serving_size'] ?? 0).toDouble(),
    servingUnit: j['serving_unit'] ?? 'g',
    calories: (j['calories_kcal'] ?? 0).toDouble(),
    protein: (j['protein_g'] ?? 0).toDouble(),
    fat: (j['fat_g'] ?? 0).toDouble(),
    carbs: (j['carbs_g'] ?? 0).toDouble(),
    category: j['category'],
  );
}
