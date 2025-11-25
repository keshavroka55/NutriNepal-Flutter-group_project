import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/api_service.dart';
import '../models/auth_response.dart';
import '../models/food.dart';
import '../models/user_log.dart';

class ApiService {
  static const _storage = FlutterSecureStorage();
  static const base = apiBaseUrl; // import from your constraints.dart

  // --- Auth ---
  static Future<AuthResponse> login(String email, String password) async {
    final res = await http.post(Uri.parse('$base/api/auth/v1/login'),
      headers: {'Content-Type':'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final json = jsonDecode(res.body);
      await _storage.write(key: 'token', value: json['token']);
      return AuthResponse.fromJson(json);
    }
    throw Exception('Login failed: ${res.body}');
  }

  static Future<void> logout() => _storage.delete(key: 'token');

  static Future<String?> getToken() => _storage.read(key: 'token');

  // Helper to send authorized requests
  static Future<Map<String,String>> _authHeaders() async {
    final token = await getToken();
    final headers = {'Content-Type':'application/json'};
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  // --- Foods ---
  static Future<List<Food>> getFoods({String? q, int page=1, int limit=30, String? category}) async {
    final params = <String,String>{'page':'$page','limit':'$limit'};
    if (q != null) params['q'] = q;
    if (category != null) params['category'] = category;
    final uri = Uri.parse('$base/api/foods').replace(queryParameters: params);
    final res = await http.get(uri);
    if (res.statusCode==200) {
      final body = jsonDecode(res.body);
      final List data = body['data'] ?? [];
      return data.map((e) => Food.fromJson(e)).toList();
    }
    throw Exception('Failed to load foods: ${res.body}');
  }

  // --- Logs ---
  static Future<UserLog> postLog(String foodId, double quantity, String unit) async {
    final headers = await _authHeaders();
    final res = await http.post(Uri.parse('$base/api/logs'),
      headers: headers,
      body: jsonEncode({'foodId': foodId, 'quantity': quantity, 'unit': unit}),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return UserLog.fromJson(jsonDecode(res.body));
    }
    throw Exception('Failed to create log: ${res.body}');
  }

  static Future<List<UserLog>> getLogs({String? from, String? to}) async {
    final headers = await _authHeaders();
    final uri = Uri.parse('$base/api/logs').replace(queryParameters: {
      if (from != null) 'from': from,
      if (to != null) 'to': to,
    });
    final res = await http.get(uri, headers: headers);
    if (res.statusCode==200) {
      final List arr = jsonDecode(res.body) as List;
      return arr.map((e)=>UserLog.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch logs: ${res.body}');
  }

  static Future<Map<String, dynamic>> getTotals({String? date, String? from, String? to}) async {
    final headers = await _authHeaders();
    final uri = Uri.parse('$base/api/logs/totals').replace(queryParameters: {
      if (date != null) 'date': date,
      if (from != null) 'from': from,
      if (to != null) 'to': to,
    });
    final res = await http.get(uri, headers: headers);
    if (res.statusCode==200) return jsonDecode(res.body);
    throw Exception('Failed to get totals: ${res.body}');
  }
}
