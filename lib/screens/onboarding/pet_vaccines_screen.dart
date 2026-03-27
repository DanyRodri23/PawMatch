import 'package:flutter/material.dart';
import 'pet_photos_screen.dart';
import 'pet_vaccine_card_screen.dart';

class PetVaccinesScreen extends StatefulWidget {
  final bool isBreedDog;

  const PetVaccinesScreen({
    super.key,
    required this.isBreedDog,
  });

  @override
  State<PetVaccinesScreen> createState() => _PetVaccinesScreenState();
}

class _PetVaccinesScreenState extends State<PetVaccinesScreen> {

  String? selectedOption;

  void goNext() {

    if (selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecciona una opción"),
        ),
      );
      return;
    }

    if (selectedOption == "si") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PetVaccineCardScreen(
            isBreedDog: widget.isBreedDog,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PetPhotosScreen(
            isBreedDog: widget.isBreedDog,
            fromVaccineCard: false,
          ),
        ),
      );
    }
  }

  Widget optionCard({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {

    final isSelected = selectedOption == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = value;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
          ),
          boxShadow: [
            if (isSelected)
              const BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 5),
              )
          ],
        ),

        child: Row(
          children: [

            Icon(
              icon,
              size: 28,
              color: isSelected ? Colors.white : Colors.black,
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white70
                          : Colors.black54,
                    ),
                  ),

                ],
              ),
            ),

            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white),

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
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            const Text(
              "Vacunas de tu mascota",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Esto ayuda a garantizar matches más seguros y confiables.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 40),

            optionCard(
              value: "si",
              title: "Sí tiene vacunas",
              subtitle: "Cuenta con control veterinario",
              icon: Icons.verified,
            ),

            optionCard(
              value: "no",
              title: "No tiene vacunas",
              subtitle: "Se puede completar después",
              icon: Icons.warning_amber_rounded,
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 60,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedOption != null
                      ? Colors.black
                      : Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  elevation: selectedOption != null ? 8 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                onPressed: selectedOption != null ? goNext : null,

                child: const Text(
                  "Continuar",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

          ],
        ),
      ),
    );
  }
}