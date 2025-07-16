// ✅ main.dart (updated to fix SignUpScreen error)

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/phoneloginscreen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/customer_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eCroft Fresh',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/phone_login': (context) => const PhoneLoginScreen(),
        '/dashboard': (context) => const CustomerDashboardScreen(),
      },
      // ✅ Dynamically handle routes that require parameters like OTP & Signup
      onGenerateRoute: (settings) {
        if (settings.name == '/otp') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => OtpVerificationScreen(
              phoneNumber: args['phoneNumber'],
              verificationId: args['verificationId'],
            ),
          );
        } else if (settings.name == '/signup') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => SignUpScreen(
              phoneNumber: args['phoneNumber'],
            ),
          );
        }
        return null; // fallback
      },
    );
  }
}
