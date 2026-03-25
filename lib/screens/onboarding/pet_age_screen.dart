import 'package:flutter/material.dart';
import 'pet_breed_type_screen.dart';

class PetAgeScreen extends StatefulWidget {
  const PetAgeScreen({super.key});

  @override
  State<PetAgeScreen> createState() => _PetAgeScreenState();
}

class _PetAgeScreenState extends State<PetAgeScreen> {

  final TextEditingController ageController = TextEditingController();

  String selectedUnit = "años";

  void goNext() {

    if (ageController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ingresa la edad de tu mascota"),
        ),
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const PetBreedTypeScreen();
        },
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
                "¿Qué edad tiene tu mascota?",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Esto nos ayuda a encontrar mascotas compatibles.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 40),

              /// INPUT EDAD
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),

                decoration: InputDecoration(
                  hintText: "Edad",

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

              const SizedBox(height: 25),

              /// AÑOS O MESES
              Row(
                children: [

                  ChoiceChip(
                    label: const Text("años"),
                    selected: selectedUnit == "años",
                    onSelected: (value) {
                      setState(() {
                        selectedUnit = "años";
                      });
                    },
                  ),

                  const SizedBox(width: 10),

                  ChoiceChip(
                    label: const Text("meses"),
                    selected: selectedUnit == "meses",
                    onSelected: (value) {
                      setState(() {
                        selectedUnit = "meses";
                      });
                    },
                  ),

                ],
              ),

              const Spacer(),

              /// BOTÓN CONTINUAR
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