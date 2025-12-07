import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:nutrinepal_1/NutriNepal/API/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../API/api_path.dart';

class AuthService {
  final ApiClient apiClient;   // keep the shared ApiClient instance
  String? _token;

  AuthService(this.apiClient);

  bool get isLoggedIn => _token != null && _token!.isNotEmpty;
  String? get token => _token;

  // Save token locally
  Future<void> _saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);

    // IMPORTANT: notify ApiClient so other requests include this token
    try {
      apiClient.updateToken(token);
    } catch (_) {
      debugPrint('AuthService._saveToken -> apiClient.updateToken failed or not implemented');
    }
  }

  // Load token from storage
  Future<void> loadTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse(ApiRoutes.login); // correct



    // Directly use http.post here (Option 2)
    final response = await http.post(
      Uri.parse(url.toString()),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}), // single encoding
    ).timeout(const Duration(seconds: 5));
    debugPrint('AuthService.login -> status: ${response.statusCode}');
    debugPrint('AuthService.login -> body: ${response.body}');

    final data = jsonDecode(response.body);

    // Save token if received
    if (response.statusCode == 200) {
      final token = data['token'] ?? data['accessToken'] ?? data['access_token'];
      if (token != null) await _saveToken(token.toString());
    }

    return data;
  }

  Future<Map<String, dynamic>> register(
      String username, String email, String password) async {

    final url = Uri.parse(ApiRoutes.register);

    try {
      final response = await http
          .post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password
        }),
      )
          .timeout(const Duration(seconds: 7)); // timeout added

      debugPrint("register status = ${response.statusCode}");
      debugPrint("register body = ${response.body}");

      final data = jsonDecode(response.body);

      // treat 200 and 201 as success from server
      if (response.statusCode == 200 || response.statusCode == 201) {
        // try to extract token if backend returned one
        final token = data['token'] ?? data['accessToken'] ?? data['access_token'] ?? data['auth_token'];
        if (token != null) {
          await _saveToken(token.toString()); // also updates apiClient if _saveToken does that
          return {'ok': true, 'status': response.statusCode, 'token': token, 'data': data};
        } else {
          // registration succeeded but no token returned
          return {'ok': true, 'status': response.statusCode, 'token': null, 'data': data};
        }
      } else {
        final message = data['message'] ?? data['error'] ?? 'Registration failed';
        return {'ok': false, 'status': response.statusCode, 'message': message, 'data': data};
      }
    } catch (e) {
      debugPrint("Register error: $e");
      return {"ok": false, "status": 0, "message": "Request failed or timed out"};
    }
  }

  Future<void> logout() async {
    _token = null;
    apiClient.updateToken(null);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}