import 'package:flutter/material.dart';
import '../dashboard_screen.dart';

class PetProfileSuccessScreen extends StatelessWidget {
  const PetProfileSuccessScreen({super.key});

  void goToDashboard(BuildContext context) {

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardScreen(),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(28),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),

            const SizedBox(height: 30),

            const Text(
              "¡Perfil creado con éxito!",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            const Text(
              "Tu mascota ya forma parte de PawMatch. Ahora puedes comenzar a explorar y encontrar compañeros ideales.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

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

                onPressed: () => goToDashboard(context),

                child: const Text(
                  "Ir al inicio",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
            ),

          ],
        ),
      ),
    );
  }
}