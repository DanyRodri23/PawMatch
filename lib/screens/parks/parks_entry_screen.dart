import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'parks_screen.dart';
import 'intro_parks_screen.dart';

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
    checkIfSeen();
  }

  Future<void> checkIfSeen() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool('parks_intro_seen') ?? false;

    setState(() {
      seen = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    /// 🔄 LOADING
    if (seen == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    /// 🔥 FLUJO PRINCIPAL
    return seen!
        ? const ParksScreen()
        : IntroParksScreen(
            onFinish: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('parks_intro_seen', true);

              setState(() {
                seen = true;
              });
            },
          );
  }
}