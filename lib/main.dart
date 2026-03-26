import 'package:flutter/material.dart';

// 🔥 TU LOGIN REAL
import 'screens/login_screen.dart';

// 🔥 TU INTRO REAL (IMPORTANTE)
import 'screens/onboarding/onboarding_intro.dart';

void main() {
  runApp(const PawMatchApp());
}

class PawMatchApp extends StatelessWidget {
  const PawMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PawMatch',

      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),

      /// 🔥 INICIO
      home: const LoginScreen(),

      /// 🔥 CLAVE PARA GOOGLE LOGIN
      routes: {
        '/intro': (context) => const OnboardingIntro(),
      },
    );
  }
}