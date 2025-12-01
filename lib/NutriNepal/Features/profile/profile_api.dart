// lib/NutriNepal/Features/profile/profile_api.dart

import 'dart:convert';
import '../../API/api_client.dart';
import '../../API/api_path.dart';
import 'profile_model.dart';

class ProfileApi {
  final ApiClient apiClient;
  ProfileApi(this.apiClient);

  /// GET /api/v1/user/profile
  Future<UserProfile?> getProfile() async {
    final resp = await apiClient.get(ApiRoutes.userProfile); // should return decoded JSON
    // resp may be a Map already depending on your ApiClient implementation.
    final Map<String, dynamic> map = resp is Map ? Map<String, dynamic>.from(resp) : jsonDecode(resp.toString());
    // If your backend wraps profile inside { data: profile } adapt accordingly.
    final body = map['profile'] ?? map; // defensive
    // for some dubgging man!
    print("📥 getProfile raw response: $map");
    print("📥 Profile extracted body: $body");
    return UserProfile.fromJson(Map<String, dynamic>.from(body));
  }

  /// POST or PUT /api/v1/user/profile to upsert profile
  Future<UserProfile> upsertProfile(UserProfile profile) async {
    final payload = profile.toJson();
    // 🔥 Debug what you are sending
    print("📤 Sending payload: $payload to ${ApiRoutes.userProfile}");

    final resp = await apiClient.post(ApiRoutes.userProfile, payload);
    print("📥 Raw response: $resp");
    final Map<String, dynamic> map = resp is Map ? Map<String, dynamic>.from(resp) : jsonDecode(resp.toString());
    final body = map['data'] ?? map;
    return UserProfile.fromJson(Map<String, dynamic>.from(body));
  }
}
