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

  bool? hasVaccines;
  int vaccineCount = 1;

  void goBack() {
    Navigator.pop(context);
  }

  void goNext() {

    if (hasVaccines == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecciona una opción"),
        ),
      );
      return;
    }

    if (hasVaccines == true) {

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
          ),
        ),
      );

    }
  }

  Widget option(bool value, String label) {

    final selected = hasVaccines == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          hasVaccines = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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

      body: Padding(
        padding: const EdgeInsets.all(28),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 30),

            const Text(
              "Vacunas de tu mascota",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "Indica si tu mascota tiene vacunas registradas.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 30),

            option(true, "Sí tiene vacunas"),
            option(false, "No tiene vacunas"),

            if (hasVaccines == true) ...[
              const SizedBox(height: 20),

              const Text(
                "¿Cuántas vacunas tiene?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButton<int>(
                  value: vaccineCount,
                  underline: const SizedBox(),
                  isExpanded: true,
                  items: List.generate(10, (index) {
                    final value = index + 1;
                    return DropdownMenuItem(
                      value: value,
                      child: Text("$value vacunas"),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      vaccineCount = value!;
                    });
                  },
                ),
              ),
            ],

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: goNext,
                child: const Text(
                  "Continuar",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}