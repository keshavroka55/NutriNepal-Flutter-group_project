
class ApiRoutes {
  // Created Mongodb Cluster and deployed on render.
  static const String baseUrl = "https://nutrinepal-node-api.onrender.com";
  // While testing with Localhost.
  // static const String baseUrl = "http://10.0.2.2:5000";
  // For External Mobile device.
  // static const String baseUrl = "http://192.168.1.70:5000";

  // Auth
  static const String login = "$baseUrl/api/auth/v1/login";
  static const String register = "$baseUrl/api/auth/v1/register";

  // Foods
  // GET /api/foods?q=...&page=...
  static const String foodsList = "/api/foods";
  static const String foodsDetail = "/api/foods";

  // Logs (user logs)
  static const String logsAdd = "/api/logs/add";
  static const String logsHistory = "/api/logs/history";
  static const String logsTotals = "/api/logs/totals";

  //User profile.
  static const String userProfile = "/api/v1/user/profile";
}
