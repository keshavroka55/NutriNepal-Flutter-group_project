// lib/src/features/logs/logs_api.dart
// Service layer for logs: add log, history, totals.

import '../../API/api_client.dart';
import '../../API/api_path.dart';

import 'user_log_model.dart';
import 'totals_model.dart';

class LogsApi {
  final ApiClient apiClient;

  LogsApi(this.apiClient);

  /// Add a new user log (what the user ate).
  /// payload: { foodId, quantity, unit }
  /// On success backend returns created log populated with food.
  Future<UserLog> addLog({required String foodId, required double quantity, String unit = 'g'}) async {
    final payload = {
      'foodId': foodId,
      'quantity': quantity,
      'unit': unit,
    };
    final response = await apiClient.post(ApiRoutes.logsAdd, payload);
    return UserLog.fromJson(Map<String, dynamic>.from(response));
  }

  /// Get user logs history. Optional from/to params (ISO date strings YYYY-MM-DD).
  Future<List<UserLog>> getHistory({String? from, String? to}) async {
    final query = <String, dynamic>{};
    if (from != null) query['from'] = from;
    if (to != null) query['to'] = to;

    final response = await apiClient.get(ApiRoutes.logsHistory, queryParameters: query);
    // response expected to be an array of logs
    final arr = response as List<dynamic>? ?? [];
    return arr.map((e) => UserLog.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  /// Get totals for a date or a range. Use 'date' OR 'from'/'to'.
  Future<Totals> getTotals({String? date, String? from, String? to}) async {
    final query = <String, dynamic>{};
    if (date != null) query['date'] = date;
    if (from != null) query['from'] = from;
    if (to != null) query['to'] = to;

    final response = await apiClient.get(ApiRoutes.logsTotals, queryParameters: query);
    return Totals.fromJson(Map<String, dynamic>.from(response));
  }
}
