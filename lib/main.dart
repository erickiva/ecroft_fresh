import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/phoneloginscreen.dart';
import 'screens/signup_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/customer_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'eCroft Fresh',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/phoneLogin': (context) => const PhoneLoginScreen(),
        '/signup': (context) {
          final phone = ModalRoute.of(context)!.settings.arguments as String;
          return SignUpScreen(phoneNumber: phone);
        },
        '/otp': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return OtpVerificationScreen(
            verificationId: args['verificationId'],
            phoneNumber: args['phoneNumber'],
            isRegistered: args['isRegistered'] ?? false, // ✅ Include this
          );
        },
        '/dashboard': (context) => const CustomerDashboardScreen(), // ✅ THIS LINE IS REQUIRED
      },
    );
  }
}
