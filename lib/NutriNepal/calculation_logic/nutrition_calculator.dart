import 'dart:math';

/// Utility class for calculating daily nutrition needs
class NutritionCalculator {
  /// Calculate BMR (Basal Metabolic Rate) using Mifflin-St Jeor Equation
  static double calculateBMR({
    required String gender,
    required double weightKg,
    required double heightCm,
    required int age,
  }) {
    // Mifflin-St Jeor Equation:
    // Men: BMR = 10 * weight(kg) + 6.25 * height(cm) - 5 * age(years) + 5
    // Women: BMR = 10 * weight(kg) + 6.25 * height(cm) - 5 * age(years) - 161

    double bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age);

    if (gender.toLowerCase() == 'male') {
      bmr += 5;
    } else {
      bmr -= 161;
    }

    return bmr;
  }

  /// Calculate TDEE (Total Daily Energy Expenditure) based on activity level
  static double calculateTDEE({
    required double bmr,
    required String activityLevel,
  }) {
    // Activity multipliers
    const activityMultipliers = {
      'sedentary': 1.2,      // Little or no exercise
      'low_active': 1.375,   // Light exercise 1-3 days/week
      'active': 1.55,        // Moderate exercise 3-5 days/week
      'very_active': 1.725,  // Hard exercise 6-7 days/week
    };

    final multiplier = activityMultipliers[activityLevel] ?? 1.2;
    return bmr * multiplier;
  }

  /// Adjust calories based on goal
  static double adjustCaloriesForGoal({
    required double tdee,
    required String goal,
  }) {
    switch (goal) {
      case 'lose_weight':
      // Create a 500 calorie deficit (approximately 0.5 kg per week)
        return tdee - 500;
      case 'gain_weight':
      // Create a 300-500 calorie surplus (approximately 0.25-0.5 kg per week)
        return tdee + 400;
      case 'keep_weight':
      default:
      // Maintain current weight
        return tdee;
    }
  }

  /// Calculate macronutrient distribution
  static Map<String, double> calculateMacros({
    required double dailyCalories,
    required String goal,
  }) {
    // Macronutrient ratios based on goal
    // Protein: 4 calories per gram
    // Carbs: 4 calories per gram
    // Fat: 9 calories per gram

    double proteinRatio, carbRatio, fatRatio;

    switch (goal) {
      case 'lose_weight':
      // Higher protein, moderate carbs, moderate fat
        proteinRatio = 0.35; // 35% protein
        carbRatio = 0.35;    // 35% carbs
        fatRatio = 0.30;     // 30% fat
        break;
      case 'gain_weight':
      // Moderate protein, higher carbs, moderate fat
        proteinRatio = 0.25; // 25% protein
        carbRatio = 0.50;    // 50% carbs
        fatRatio = 0.25;     // 25% fat
        break;
      case 'keep_weight':
      default:
      // Balanced macros
        proteinRatio = 0.30; // 30% protein
        carbRatio = 0.40;    // 40% carbs
        fatRatio = 0.30;     // 30% fat
        break;
    }

    // Calculate grams of each macro
    final proteinGrams = (dailyCalories * proteinRatio) / 4;
    final carbGrams = (dailyCalories * carbRatio) / 4;
    final fatGrams = (dailyCalories * fatRatio) / 9;

    return {
      'protein': proteinGrams.roundToDouble(),
      'carbs': carbGrams.roundToDouble(),
      'fat': fatGrams.roundToDouble(),
    };
  }

  /// Main method to calculate all daily nutrition needs
  static Map<String, double> calculateDailyNeeds({
    required String goal,
    required String gender,
    required String activityLevel,
    required double heightCm,
    required double weightKg,
    required int age,
  }) {
    // Step 1: Calculate BMR
    final bmr = calculateBMR(
      gender: gender,
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
    );

    // Step 2: Calculate TDEE
    final tdee = calculateTDEE(
      bmr: bmr,
      activityLevel: activityLevel,
    );

    // Step 3: Adjust for goal
    final dailyCalories = adjustCaloriesForGoal(
      tdee: tdee,
      goal: goal,
    );

    // Step 4: Calculate macros
    final macros = calculateMacros(
      dailyCalories: dailyCalories,
      goal: goal,
    );

    return {
      'calories': dailyCalories.roundToDouble(),
      'protein': macros['protein']!,
      'carbs': macros['carbs']!,
      'fat': macros['fat']!,
    };
  }
}