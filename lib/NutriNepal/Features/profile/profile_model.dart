// lib/NutriNepal/Features/profile/profile_model.dart

class UserProfile {
  final String userId;
  final String fullName;
  final String email;
  final String gender; // 'male','female','other','prefer_not_to_say'
  final int? age;
  final double? height; // cm
  final double? weight; // kg
  final String? goal;
  final String activityLevel; // 'sedentary','light','moderate','active','very_active'
  final double? dailyCalories;
  final double? dailyProtein;
  final double? dailyFat;
  final double? dailyCarbs;
  final String? photoUrl;


  UserProfile({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.gender,
    this.age,
    this.height,
    this.weight,
    this.goal = "maintain_weight",
    this.activityLevel = 'light',
    this.dailyCalories,
    this.dailyProtein,
    this.dailyFat,
    this.dailyCarbs,
    this.photoUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    }

    return UserProfile(
      userId: json['userId']?.toString() ?? json['_id']?.toString() ?? '',
      fullName: json['name'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? 'prefer_not_to_say',
      age: json['age'] != null ? int.tryParse(json['age'].toString()) : null,
      height: json['height'] != null ? _toDouble(json['height']) : null,
      weight: json['weight'] != null ? _toDouble(json['weight']) : null,
      goal: json['goal'] ?? 'maintain_weight',
      activityLevel: json['activityLevel'] ?? 'light',
      dailyCalories: json['dailyCalories'] != null ? _toDouble(json['dailyCalories']) : null,
      dailyProtein: json['dailyProtein'] != null ? _toDouble(json['dailyProtein']) : null,
      dailyFat: json['dailyFat'] != null ? _toDouble(json['dailyFat']) : null,
      dailyCarbs: json['dailyCarbs'] != null ? _toDouble(json['dailyCarbs']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': fullName,
      'email': email,
      'gender': gender,
      'age': age,
      'height': height,
      'weight': weight,
      'goal': goal,
      'activityLevel': activityLevel,
      'dailyCalories': dailyCalories,
      'dailyProtein': dailyProtein,
      'dailyFat': dailyFat,
      'dailyCarbs': dailyCarbs,
    };
  }
}
