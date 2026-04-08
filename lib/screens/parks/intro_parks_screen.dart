import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroParksScreen extends StatelessWidget {
  const IntroParksScreen({super.key});

  Future<void> _finishIntro(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_parks_intro', true);

    Navigator.pushReplacementNamed(context, '/parks');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ElevatedButton(
          onPressed: () => _finishIntro(context),
          child: const Text("Entrar a Parks"),
        ),
      ),
    );
  }
}