import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'intro_hotels_screen.dart';
import 'hotels_screen.dart';

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
    checkIntro();
  }

  Future<void> checkIntro() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      seen = prefs.getBool('seenHotelsIntro') ?? false;
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

    return seen!
        ? const HotelsScreen()
        : const IntroHotelsScreen();
  }
}