class UserProfile {
  final String username;
  final String email;
  final String gender; // male, female, other, prefer_not_to_say
  final int? age;
  final double? height; // cm
  final double? weight; // kg
  final String? goal;
  final String activityLevel; // sedentary, light, moderate, active, very_active
  final String? photoUrl;

  // ⭐ Macro values
  final int? dailyCalories;
  final int? dailyProtein;
  final int? dailyFat;
  final int? dailyCarbs;

  UserProfile({
    required this.username,
    required this.email,
    required this.gender,
    this.age,
    this.height,
    this.weight,
    this.goal,
    required this.activityLevel,
    this.photoUrl,
    this.dailyCalories,
    this.dailyProtein,
    this.dailyFat,
    this.dailyCarbs,
  });

  // ---------- JSON → MODEL ----------
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    double? _toDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    int? _toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return UserProfile(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? 'prefer_not_to_say',
      age: _toInt(json['age']),
      height: _toDouble(json['height']),
      weight: _toDouble(json['weight']),
      goal: json['goal'],
      activityLevel: json['activityLevel'] ?? 'light',
      dailyCalories: _toInt(json['dailyCalories']),
      dailyProtein: _toInt(json['dailyProtein']),
      dailyFat: _toInt(json['dailyFat']),
      dailyCarbs: _toInt(json['dailyCarbs']),
    );
  }

  // ---------- MODEL → JSON ----------
  Map<String, dynamic> toJson() {
    return {
      'username': username,
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
