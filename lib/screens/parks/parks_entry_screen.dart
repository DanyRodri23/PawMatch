import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _checkIntro();
  }

  Future<void> _checkIntro() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool('seen_parks_intro') ?? false;

    setState(() {
      seen = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (seen == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (seen!) {
      return const ParksScreen();
    } else {
      return const IntroParksScreen();
    }
  }
}