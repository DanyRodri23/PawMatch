import 'package:flutter/material.dart';
import 'pet_photos_screen.dart';

class PetVaccineCardScreen extends StatefulWidget {

  final bool isBreedDog;

  const PetVaccineCardScreen({
    super.key,
    required this.isBreedDog,
  });

  @override
  State<PetVaccineCardScreen> createState() => _PetVaccineCardScreenState();
}

class _PetVaccineCardScreenState extends State<PetVaccineCardScreen> {

  bool hasFile = false;

  void simulateUpload() {
    setState(() {
      hasFile = true;
    });
  }

  void goNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetPhotosScreen(
          isBreedDog: widget.isBreedDog,
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
        padding: const EdgeInsets.all(28),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 30),

            const Text(
              "Carnet de vacunas",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "Sube el carnet para verificar la salud de tu mascota.",
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 40),

            GestureDetector(
              onTap: simulateUpload,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: hasFile ? Colors.green : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: hasFile
                      ? const Icon(Icons.check_circle, color: Colors.green, size: 40)
                      : const Icon(Icons.upload_file, size: 40),
                ),
              ),
            ),

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
                child: const Text("Continuar"),
              ),
            ),

          ],
        ),
      ),
    );
  }
}