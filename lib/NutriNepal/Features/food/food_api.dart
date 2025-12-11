
import '../../API/api_client.dart';
import '../../API/api_path.dart';
import 'food_model.dart';

class FoodApi {
  final ApiClient apiClient;

  FoodApi(this.apiClient);

  /// Search foods. `q` is the query string, `page` optional.
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

}
