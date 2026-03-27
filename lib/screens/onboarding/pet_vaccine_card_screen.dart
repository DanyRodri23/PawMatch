import 'package:flutter/material.dart';
import 'pet_photos_screen.dart';

class PetVaccineCardScreen extends StatefulWidget {
  const PetVaccineCardScreen({super.key});

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

  void showInfoMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Recuerda subir el carnet de vacunas. Esto le dará una insignia de verificación a tu mascota 🐾",
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }

  void goNext() {
    Navigator.push( // 🔥 CAMBIO AQUÍ (ANTES pushReplacement)
      context,
      MaterialPageRoute(
        builder: (context) => const PetPhotosScreen(
          isBreedDog: false,
          fromVaccineCard: true, // 🔥 CLAVE
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
        iconTheme: const IconThemeData(color: Colors.black),
        // 🔥 NO TOCAR: esto ya hace pop automático
      ),

      body: Padding(
        padding: const EdgeInsets.all(28),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 30),

            const Text(
              "Carnet de vacunas",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Sube una foto del carnet de tu mascota o hazlo más tarde.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 40),

            GestureDetector(
              onTap: simulateUpload,
              child: Container(
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
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle,
                                size: 40, color: Colors.green),
                            SizedBox(height: 10),
                            Text("Carnet agregado"),
                          ],
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file, size: 40),
                            SizedBox(height: 10),
                            Text("Subir carnet"),
                          ],
                        ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: showInfoMessage,
              child: const Text(
                "No tengo el carnet disponible ahora",
                style: TextStyle(
                  color: Colors.black54,
                  decoration: TextDecoration.underline,
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
    );
  }
}