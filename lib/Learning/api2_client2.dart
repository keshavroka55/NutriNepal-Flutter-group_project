import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String token; // JWT token for authenticated routes

  ApiClient({required this.token});

  // GET request
  Future<http.Response> getRequest(String endpoint) async {
    return await http.get(
      Uri.parse(endpoint), // full URL is passed here from api_routes.dart
      headers: _headers(),
    );
  }

  // PUT request
  Future<http.Response> putRequest(String endpoint, Map<String, dynamic> data) async {
    return await http.put(
      Uri.parse(endpoint), // full URL is passed here
      headers: _headers(),
      body: jsonEncode(data),
    );
  }

  Map<String, String> _headers() {
    return {
      "Content-Type": "application/json",
      if (token.isNotEmpty) "Authorization": "Bearer $token"
    };
  }
}
