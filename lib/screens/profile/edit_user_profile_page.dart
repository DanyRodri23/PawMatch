import 'package:flutter/material.dart';

class EditUserProfilePage extends StatelessWidget {
  const EditUserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Perfil del propietario"),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          "Fotos + verificación 🔥",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}