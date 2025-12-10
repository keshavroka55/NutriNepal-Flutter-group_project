// lib/NutriNepal/Features/profile/profile_api.dart

import 'dart:convert';
import 'package:flutter/cupertino.dart';

import '../../API/api_client.dart';
import '../../API/api_path.dart';
import 'profile_model.dart';

class ProfileApi {
  final ApiClient apiClient;
  ProfileApi(this.apiClient);

  /// GET /api/v1/user/profile
  Future<UserProfile?> getProfile() async {
    try {
      final resp = await apiClient.get(ApiRoutes.userProfile);

      // Convert to Map if needed
      final Map<String, dynamic> map = resp is Map
          ? Map<String, dynamic>.from(resp)
          : jsonDecode(resp.toString());

      print("📥 K getProfile raw response: $map");

      // Check if backend wraps profile in 'profile' key
      final body = map['profile'] ?? map;

      // If body is empty or null → no profile exists
      if (body == null || body.isEmpty) {
        print("📭 No profile found for this user");
        return UserProfile(
          username: "User",
          dailyCalories: 2400,
          dailyProtein: 150,
          dailyFat: 70,
          dailyCarbs: 300, email: 'user@gmail.com', gender: 'male', activityLevel: 'sedentary',
        );
      }

      // IMPORTANT: check field names match UserProfile
      final userProfile = UserProfile.fromJson(Map<String, dynamic>.from(body));
      print("📦 PROFILE FETCHED from profile Api dart file: $userProfile");
      return userProfile;

    } catch (e) {
      // Handle 404 NOT FOUND specifically
      if (e is ApiException && e.statusCode == 404) {
        print("📭 Profile not found (404) → return null");
        return UserProfile(
          username: "User",
          dailyCalories: 2400,
          dailyProtein: 150,
          dailyFat: 70,
          dailyCarbs: 300, email: 'user@gmail.com', gender: 'male', activityLevel: 'sedentary',
        ); // this allows UI to show "Create Profile" button
      }

      // For other errors, also return default
      print("❌ getProfile error: $e → returning default");
      return UserProfile(
        username: "User",
        dailyCalories: 2400,
        dailyProtein: 150,
        dailyFat: 70,
        dailyCarbs: 300, email: 'user@gmail.com', gender: 'male', activityLevel: 'sedentary',
      );
    }
  }


  /// POST /api/v1/user/profile - Create new profile
  Future<UserProfile> createProfile(UserProfile profile) async {
    final payload = profile.toJson();
    print("📝 Creating profile → POST $payload");
    // 🔥 Important: remove userId from payload for new profile

    final resp = await apiClient.post(ApiRoutes.userProfile, payload);
    final map = resp is Map
        ? Map<String, dynamic>.from(resp)
        : jsonDecode(resp.toString());

    final profileData = map['profile'] ?? map['data'] ?? map;

    return UserProfile.fromJson(Map<String, dynamic>.from(profileData));
  }


  /// PUT /api/v1/user/profile - Update existing profile
  Future<UserProfile> updateProfile(UserProfile profile) async {
    final payload = profile.toJson();
    print("📝 Updating profile → PUT $payload");

    final resp = await apiClient.put(ApiRoutes.userProfile, payload);
    final map = resp is Map
        ? Map<String, dynamic>.from(resp)
        : jsonDecode(resp.toString());

    final profileData = map['profile'] ?? map['data'] ?? map;

    return UserProfile.fromJson(Map<String, dynamic>.from(profileData));
  }
}
