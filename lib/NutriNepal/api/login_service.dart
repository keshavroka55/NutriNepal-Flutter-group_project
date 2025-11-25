
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ApiService {

  // Register user
  static Future<Map<String, dynamic>> registerUser(String username, String email, String password) async {
    final url = Uri.parse(registerEndpoint);

    final body = jsonEncode({
      'username': username,
      'email': email,
      'password': password,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    return jsonDecode(response.body);
  }

  // Login user
  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final url = Uri.parse(loginEndpoint);

    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    return jsonDecode(response.body);
  }
}
