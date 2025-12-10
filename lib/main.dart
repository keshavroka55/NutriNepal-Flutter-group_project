import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'NutriNepal/API/api_client.dart';
import 'NutriNepal/Features/Auth2/auth_service.dart';
import 'NutriNepal/Features/Auth2/login_page.dart';
import 'NutriNepal/Features/Auth2/register_page.dart';
import 'NutriNepal/Features/food/food_api.dart';
import 'NutriNepal/Features/homepage2.dart';
import 'NutriNepal/Features/logs/logs_api.dart';
import 'NutriNepal/Features/profile/profile_api.dart';
import 'NutriNepal/UI/splashes/inital.dart';
import 'NutriNepal/UI/splashes/screen-1.dart';
import 'NutriNepal/UI/splashes/screen-2.dart';
import 'NutriNepal/UI/splashes/screen-3.dart';
import 'NutriNepal/UI/splashes/startscreen.dart';


/// Entry point
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiClient = ApiClient();
  final authService = AuthService(apiClient);

  await authService.loadTokenFromStorage();
  apiClient.updateToken(authService.token);

  final foodApi = FoodApi(apiClient);
  final logsApi = LogsApi(apiClient);
  final profileApi = ProfileApi(apiClient);

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: apiClient),
        ChangeNotifierProvider<AuthService>.value(value: authService),
        Provider<FoodApi>.value(value: foodApi),
        Provider<LogsApi>.value(value: logsApi),
        Provider<ProfileApi>.value(value: profileApi),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriNepal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AuthWrapper(), // ✔ tell flutter which first route to load
      routes: {
        '/onboarding1': (context) => Onboarding1(),
        '/onboarding2': (context) => Onboarding2(),
        '/onboarding3': (context) => Onboarding3(),
        '/welcome': (context) => WelcomeScreen(),
        '/login':(context) => LoginScreen(),
        '/register':(context) => RegisterScreen(),
        // home page.
        "/homepage": (context) {
          final logsApi = Provider.of<LogsApi>(context, listen: false);
          final profileApi = Provider.of<ProfileApi>(context, listen: false);

          return DailyNutritionDashboard(
            getHistory: () => logsApi.getHistory(),
            getProfile: () => profileApi.getProfile(),
          );
        },
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logsApi = Provider.of<LogsApi>(context, listen: false);
    final profileApi = Provider.of<ProfileApi>(context, listen: false);

    return DailyNutritionDashboard(
      getProfile: () => profileApi.getProfile(),
      getHistory: () => logsApi.getHistory(),
    );
  }
}

// Add this AuthWrapper widget
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    // Show loading while validating token
    if (authService.token != null && !authService.isLoggedIn) {
      // Token exists but not validated yet
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Validating session...'),
            ],
          ),
        ),
      );
    }

    // Navigate based on auth status
    if (authService.isLoggedIn) {
      return HomePage();
    } else {
      // Use the first onboarding screen
      return Onboarding1(); // Make sure this widget exists
    }
  }
}

