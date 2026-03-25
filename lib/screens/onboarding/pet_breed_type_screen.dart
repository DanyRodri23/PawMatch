import 'package:flutter/material.dart';
import 'pet_breed_select_screen.dart';
import 'pet_vaccines_screen.dart';
import 'pet_age_screen.dart';

class PetBreedTypeScreen extends StatefulWidget {
  const PetBreedTypeScreen({super.key});

  @override
  State<PetBreedTypeScreen> createState() => _PetBreedTypeScreenState();
}

class _PetBreedTypeScreenState extends State<PetBreedTypeScreen> {

  String? breedType;

  void goNext() {

    if (breedType == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecciona una opción"),
        ),
      );

      return;
    }

    if (breedType == "raza") {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PetBreedSelectScreen(),
        ),
      );

    } else {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PetVaccinesScreen(isBreedDog: false),
        ),
      );

    }

  }

  void goBack() {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PetAgeScreen(),
      ),
    );

  }

  Widget option(String value, String label) {

    final selected = breedType == value;

    return GestureDetector(

      onTap: () {
        setState(() {
          breedType = value;
        });
      },

      child: Container(

        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),

        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? Colors.black : Colors.grey.shade300,
          ),
        ),

        child: Row(
          children: [

            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selected ? Colors.white : Colors.black54,
            ),

            const SizedBox(width: 12),

            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : Colors.black,
              ),
            ),

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: goBack,
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 40),

              const Text(
                "¿Tu mascota es de raza?",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Selecciona si tu mascota es de raza o mestiza.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 40),

              option("raza", "Perro de raza"),

              option("mestizo", "Mestizo / Zaguate"),

              const Spacer(),

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