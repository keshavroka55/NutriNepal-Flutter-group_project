
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'api_path.dart';

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => "ApiException($statusCode): $message";
}

class ApiClient {
  String? _token;
  final http.Client _httpClient;
  final Duration timeout;

  ApiClient({http.Client? httpClient, this.timeout = const Duration(seconds: 10)})
      : _httpClient = httpClient ?? http.Client();

  // Update token after login
  void updateToken(String? token) => _token = token;
  String? get token => _token;

  // Default headers
  Map<String, String> _defaultHeaders({Map<String, String>? extra}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
      debugPrint('ApiClient headers: $headers');
    }
    if (extra != null) headers.addAll(extra);
    return headers;
  }

  // Build full URI with relative path + optional query parameters
  Uri _buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    final qp = queryParameters?.map((k, v) => MapEntry(k, v?.toString() ?? '')) ?? {};
    return Uri.parse("${ApiRoutes.baseUrl}$path").replace(queryParameters: qp.isEmpty ? null : qp);
  }

  // GET request
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    final uri = _buildUri(path, queryParameters);
    try {
      final response = await _httpClient.get(uri, headers: _defaultHeaders()).timeout(const Duration(seconds: 10));
      return _processResponse(response);
    } catch (e) {
      throw ApiException('GET request failed: $e');
    }
  }

  // POST request
  Future<dynamic> post(String path, dynamic body, {Map<String, dynamic>? queryParameters}) async {
    final uri = _buildUri(path, queryParameters);
    try {
      final response = await _httpClient
          .post(uri, headers: _defaultHeaders(), body: jsonEncode(body))
          .timeout(timeout);
      return _processResponse(response);
    } catch (e) {
      throw ApiException('POST request failed: $e');
    }
  }

  // PUT request
  Future<dynamic> put(String path, dynamic body, {Map<String, dynamic>? queryParameters}) async {
    final uri = _buildUri(path, queryParameters);
    try {
      final response = await _httpClient
          .put(uri, headers: _defaultHeaders(), body: jsonEncode(body))
          .timeout(timeout);
      return _processResponse(response);
    } catch (e) {
      throw ApiException('PUT request failed: $e');
    }
  }

  // DELETE request
  Future<dynamic> delete(String path, {Map<String, dynamic>? queryParameters}) async {
    final uri = _buildUri(path, queryParameters);
    try {
      final response = await _httpClient.delete(uri, headers: _defaultHeaders()).timeout(timeout);
      return _processResponse(response);
    } catch (e) {
      throw ApiException('DELETE request failed: $e');
    }
  }

  // Central response processing
  dynamic _processResponse(http.Response response) {
    final status = response.statusCode;
    final body = response.body;

    dynamic decoded;
    if (body.isNotEmpty) {
      try {
        decoded = jsonDecode(body);
      } catch (e) {
        decoded = body; // not JSON, return raw string
      }
    }

    if (status >= 200 && status < 300) {
      return decoded;
    }

    // Handle errors
    String message = 'Unknown error';
    if (decoded is Map && decoded.containsKey('error')) {
      message = decoded['error'].toString();
    } else if (decoded is Map && decoded.containsKey('message')) {
      message = decoded['message'].toString();
    } else if (decoded is String) {
      message = decoded;
    } else {
      message = 'HTTP $status';
    }
    throw ApiException(message, status);
  }
}
