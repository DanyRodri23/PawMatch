import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'hotels_screen.dart';
import 'intro_hotels_screen.dart';

class HotelsEntryScreen extends StatefulWidget {
  const HotelsEntryScreen({super.key});

  @override
  State<HotelsEntryScreen> createState() => _HotelsEntryScreenState();
}

class _HotelsEntryScreenState extends State<HotelsEntryScreen> {

  bool? seen;

  @override
  void initState() {
    super.initState();
    checkIfSeen();
  }

  Future<void> checkIfSeen() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool('hotels_intro_seen') ?? false;

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
        ? const HotelsScreen()
        : IntroHotelsScreen(
            onFinish: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('hotels_intro_seen', true);

              setState(() {
                seen = true;
              });
            },
          );
  }
}