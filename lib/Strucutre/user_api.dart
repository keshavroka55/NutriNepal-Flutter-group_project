import 'dart:convert';
import 'package:nutrinepal_1/Strucutre/user_profile_model.dart';

import 'api2_client2.dart';
import 'api_route.dart';

class UserApi {
  final ApiClient client;

  UserApi(this.client);

  // Get the logged-in user's profile
  Future<UserProfile2?> getProfile() async {
    final response = await client.getRequest(profileEndpoint2); // endpoint string from api_routes.dart

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data']; // assuming backend sends { data: {...} }
      return UserProfile2.fromJson(data); // convert JSON to model
    }
    return null; // or handle error as needed
  }

  // Update or create the user profile (UPSERT)
  Future<bool> updateProfile(UserProfile2 profile) async {
    final response = await client.putRequest(profileEndpoint2, profile.toJson());

    return response.statusCode == 200; // true if update success
  }
}
