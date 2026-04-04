import 'package:flutter/material.dart';

class EditPetProfilePage extends StatelessWidget {
  const EditPetProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Editar mascota"),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          "Editar mascota (próximo nivel 🔥)",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}