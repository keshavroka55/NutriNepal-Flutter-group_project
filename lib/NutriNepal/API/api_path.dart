// lib/src/api/api_routes.dart
// Central place for base url and all endpoints.
// Add endpoints here — services read these strings, so adding new endpoints
// usually doesn't require changing other files.

// Base URL of your Node backend API
// the mongodb cluster is created on learnpoadcast gmail id ok..
// const String apiBaseUrl = "https://nutrinepal-node-api.onrender.com";

class ApiRoutes {
  // Change this to your backend URL (no trailing slash).
  static const String baseUrl = "http://10.0.2.2:5000";
  // static const String baseUrl = "http://192.168.1.70:5000"; // while testing the external device..


  // Auth
  static const String login = "$baseUrl/api/auth/v1/login";
  static const String register = "$baseUrl/api/auth/v1/register";

  // Foods
  // GET /api/foods?q=...&page=...
  static const String foodsList = "/api/foods";
  // GET /api/foods/:id -> build in service: "$foodsDetail/$id"
  static const String foodsDetail = "/api/foods";

  // Logs (user logs)
  static const String logsAdd = "/api/logs/add";
  static const String logsHistory = "/api/logs/history";
  static const String logsTotals = "/api/logs/totals";

  // Profile (example)
  static const String userProfile = "/api/v1/user/profile";
}
