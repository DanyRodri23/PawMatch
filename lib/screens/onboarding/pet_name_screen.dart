import 'package:flutter/material.dart';
import 'pet_age_screen.dart';

class PetNameScreen extends StatefulWidget {
  const PetNameScreen({super.key});

  @override
  State<PetNameScreen> createState() => _PetNameScreenState();
}

class _PetNameScreenState extends State<PetNameScreen> {

  final TextEditingController petNameController = TextEditingController();

  void goNext() {

    if (petNameController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Escribe el nombre de tu mascota"),
        ),
      );

      return;
    }

    /// PASAR A EDAD DE LA MASCOTA
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const PetAgeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 40),

              const Text(
                "¿Cómo se llama tu mascota? 🐶",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Este será el nombre que verán otros usuarios en PawMatch.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 40),

              /// INPUT NOMBRE
              TextField(
                controller: petNameController,

                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),

                decoration: InputDecoration(
                  hintText: "Nombre de tu mascota",

                  filled: true,
                  fillColor: Colors.grey.shade100,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              /// BOTON CONTINUAR
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  onPressed: goNext,

                  child: const Text(
                    "Continuar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ),
              ),

              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}