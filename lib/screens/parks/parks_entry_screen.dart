import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ✅ IMPORTS IMPORTANTES
import 'package:pawmatch/screens/parks/parks_screen.dart';
import 'package:pawmatch/screens/parks/intro_parks_screen.dart';

class ParksEntryScreen extends StatefulWidget {
  const ParksEntryScreen({super.key});

  @override
 State<ParksEntryScreen> createState() => _ParksEntryScreenState();
}

class _ParksEntryScreenState extends State<ParksEntryScreen> {

  bool? seen;

  @override
  void initState() {
    super.initState();
    checkIntro();
  }

  Future<void> checkIntro() async {
    final prefs = await SharedPreferences.getInstance();
    seen = prefs.getBool('seen_parks_intro') ?? false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    // 🔄 Cargando
    if (seen == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 🔥 LÓGICA FINAL
    return seen!
        ? const ParksScreen()
        : IntroParksScreen(); // 🚨 SIN const
  }
}