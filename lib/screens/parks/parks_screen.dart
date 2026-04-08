import 'package:flutter/material.dart';

class ParksScreen extends StatelessWidget {
  const ParksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Parks"),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          "Pantalla de Parks 🌳",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}