import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/phoneloginscreen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/customer_dashboard_screen.dart'; // Placeholder screen for now

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eCroft Fresh',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/phone_login': (context) => const PhoneLoginScreen(),
        '/dashboard': (context) => const CustomerDashboardScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/otp') {
          final phone = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => OtpVerificationScreen(phoneNumber: phone),
          );
        }

        if (settings.name == '/signup') {
          final phone = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => SignUpScreen(phoneNumber: phone),
          );
        }

        return null; // fallback if route is not matched
      },
    );
  }
}
