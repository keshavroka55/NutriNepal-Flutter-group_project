import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:nutrinepal_1/NutriNepal/API/api_client.dart';
import 'package:nutrinepal_1/NutriNepal/Features/Auth2/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../API/api_path.dart';

class AuthService with ChangeNotifier {
  User? _currentUser;
  final ApiClient apiClient;   // keep the shared ApiClient instance
  String? _token;
  User? get currentUser => _currentUser;
  bool _isTokenValidated = false; // Add this flag

  AuthService(this.apiClient);

  bool get isLoggedIn => _token != null && _token!.isNotEmpty && _isTokenValidated;
  String? get token => _token;

  // Save token locally
  Future<void> _saveToken(String token) async {
    _token = token;
    _isTokenValidated = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);

    // IMPORTANT: notify ApiClient so other requests include this token
    try {
      apiClient.updateToken(token);
    } catch (_) {
      debugPrint('AuthService._saveToken -> apiClient.updateToken failed or not implemented');
    }
    notifyListeners();
  }

  // Load token from storage
  Future<void> loadTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');

    // If token exists, validate it
    if (_token != null && _token!.isNotEmpty) {
      await _validateToken(); // Check if token works with current server
    }

    // Load saved user
    final savedUser = prefs.getString('auth_user');
    if (savedUser != null) {
      _currentUser = User.fromJson(jsonDecode(savedUser));
      notifyListeners();

    }
  }
  // Add token validation method
  Future<void> _validateToken() async {
    if (_token == null || _token!.isEmpty) {
      _isTokenValidated = false;
      return;
    }

    try {
      // Try a simple request to check if token works
      final response = await http.get(
        Uri.parse('${ApiRoutes.baseUrl}/api/foods'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      // If 401, token is invalid
      if (response.statusCode == 401) {
        debugPrint('⚠️ Token validation failed: Token invalid');
        _isTokenValidated = false;
        await _clearInvalidToken();
      } else if (response.statusCode == 200) {
        debugPrint('✅ Token validation successful');
        _isTokenValidated = true;
      } else {
        debugPrint('⚠️ Token validation: Status ${response.statusCode}');
        _isTokenValidated = false;
      }
    } catch (e) {
      debugPrint('❌ Token validation error: $e');
      _isTokenValidated = false;
      await _clearInvalidToken();
    }
  }

  // Clear invalid token
  Future<void> _clearInvalidToken() async {
    _token = null;
    _isTokenValidated = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_user');
    apiClient.updateToken(null); // Clear token from API client
    notifyListeners();
  }

  // Add logout method
  Future<void> logout() async {
    await _clearInvalidToken();
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
    // Save user
    if (data['user'] != null) {
      _currentUser = User.fromJson(data['user']);

      // Store user in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('auth_user', jsonEncode(_currentUser!.toJson()));
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

  // this work for localhost.
  // Future<void> logout() async {
  //   _token = null;
  //   apiClient.updateToken(null);
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('auth_token');
  // }
}