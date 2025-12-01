import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'NutriNepal/API/api_client.dart';
import 'NutriNepal/Features/Auth2/auth_service.dart';
import 'NutriNepal/Features/food/food_api.dart';
import 'NutriNepal/Features/logs/logs_api.dart';
import 'NutriNepal/Features/profile/profile_api.dart';
import 'NutriNepal/routes.dart';


/// Entry point
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ---------- CREATE CORE SERVICES ----------
  final apiClient = ApiClient();            // single shared HTTP client
  final authService = AuthService(apiClient); // auth (login/logout & token storage)

  // Load saved token (if any) BEFORE showing UI so routes/screens can rely on auth state.
  // This method must be implemented in your AuthService (async).
  await authService.loadTokenFromStorage();

  apiClient.updateToken(authService.token);

  // Create feature services which reuse the same ApiClient (so Authorization header is shared)
  final foodApi = FoodApi(apiClient);
  final logsApi = LogsApi(apiClient);
  final profileApi = ProfileApi(apiClient);


  // ---------- RUN APP ----------
  runApp(
    // Provide services app-wide using Provider
    MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: apiClient),
        Provider<AuthService>.value(value: authService),
        Provider<FoodApi>.value(value: foodApi),
        Provider<LogsApi>.value(value: logsApi),
        Provider<ProfileApi>.value(value: profileApi),
      ],
      child: MyApp(),
    ),
  );
}

/// MyApp is basically your original app root.
/// We only changed the signature to accept UserProfile same as before.
class MyApp extends StatelessWidget {
  const MyApp({ Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriNepal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: AppRoutes.routes,
    );
  }
}
