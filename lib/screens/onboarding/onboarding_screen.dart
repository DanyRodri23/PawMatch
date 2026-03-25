import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  int currentStep = 0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController petNameController = TextEditingController();

  void nextStep() {
    setState(() {
      currentStep++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),

      appBar: AppBar(
        title: const Text("Crear perfil"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [

            /// BARRA DE PROGRESO
            LinearProgressIndicator(
              value: (currentStep + 1) / 2,
              backgroundColor: Colors.grey.shade300,
              color: const Color(0xFF1E5ED8),
              minHeight: 8,
            ),

            const SizedBox(height: 40),

            Expanded(
              child: currentStep == 0
                  ? ownerStep()
                  : petStep(),
            )

          ],
        ),
      ),
    );
  }

  /// PASO 1
  Widget ownerStep() {

    return Column(
      children: [

        const Text(
          "Datos del propietario",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 40),

        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: "Nombre",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),

        const Spacer(),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(

            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E5ED8),
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),

            onPressed: () {

              if (nameController.text.isEmpty) {

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Escribe tu nombre"),
                  ),
                );

                return;
              }

              nextStep();

            },

            child: const Text("Continuar"),
          ),
        ),

      ],
    );
  }

  /// PASO 2
  Widget petStep() {

    return Column(
      children: [

        const Text(
          "Datos de tu mascota",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 40),

        TextField(
          controller: petNameController,
          decoration: InputDecoration(
            labelText: "Nombre de la mascota",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),

        const Spacer(),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(

            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E5ED8),
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),

            onPressed: () {

              if (petNameController.text.isEmpty) {

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Escribe el nombre de la mascota"),
                  ),
                );

                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Perfil creado correctamente"),
                ),
              );

            },

            child: const Text("Finalizar"),
          ),
        ),

      ],
    );
  }
}