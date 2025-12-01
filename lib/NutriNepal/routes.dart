import 'package:flutter/material.dart';
import 'package:nutrinepal_1/NutriNepal/UI/splashes/inital.dart';
import 'package:nutrinepal_1/NutriNepal/UI/splashes/screen-1.dart';
import 'package:nutrinepal_1/NutriNepal/UI/splashes/screen-2.dart';
import 'package:nutrinepal_1/NutriNepal/UI/splashes/screen-3.dart';
import 'Features/Auth2/login_page.dart';
import 'Features/Auth2/register_page.dart';
import 'UI/splashes/startscreen.dart';



class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => SplashScreen(),
    '/onboarding1': (context) => Onboarding1(),
    '/onboarding2': (context) => Onboarding2(),
    '/onboarding3': (context) => Onboarding3(),
    '/welcome': (context) => WelcomeScreen(),
    '/login':(context) => LoginScreen2(),
    '/register':(context) => RegisterScreen2(),


    // '/profileSetup': (context) => ProfileSetupScreen(),
    // '/login': (context) => LoginScreen(),
  };
}
