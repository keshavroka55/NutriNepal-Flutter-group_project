// lib/src/features/food/food_api.dart
// Service layer for foods. Calls ApiClient and converts JSON -> Food model.

import 'dart:convert';

import '../../API/api_client.dart';
import '../../API/api_path.dart';
import 'food_model.dart';

class FoodApi {
  final ApiClient apiClient;

  FoodApi(this.apiClient);

  /// Search foods. `q` is the query string, `page` optional.
  /// Returns list of Food and meta info (map) if needed.
  Future<List<Food>> searchFoods({String? q, int page = 1, int limit = 30}) async {
    final query = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (q != null && q.isNotEmpty) query['q'] = q;
    final response = await apiClient.get(ApiRoutes.foodsList, queryParameters: query);
    print('Response from API: $response');

    // Parse the actual list
    final dataList = response['data'] as List<dynamic>? ?? [];
    return dataList.map((e) => Food.fromJson(e)).toList();
  }


  /// Get a single food by id
  Future<Food> getFoodById(String id) async {
    final response = await apiClient.get("${ApiRoutes.foodsDetail}/$id");
    return Food.fromJson(Map<String, dynamic>.from(response));
  }

// Note: adding new food is admin-only in your backend. You can implement createFood here.
// Example:
// Future<Food> createFood(Food payload) => apiClient.post(ApiRoutes.foodsList, payload.toJson());
}
