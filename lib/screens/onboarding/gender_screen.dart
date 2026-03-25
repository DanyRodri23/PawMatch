import 'package:flutter/material.dart';
import 'profile_photo_screen.dart';
import '../../widgets/user_progress_bar.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {

  String? selectedGender;
  bool showOnProfile = true;

  Widget genderOption(String gender) {

    bool isSelected = selectedGender == gender;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },

      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),

        padding: const EdgeInsets.symmetric(vertical: 18),

        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),

          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
          ),
        ),

        child: Center(
          child: Text(
            gender,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void goNext() {

    if (selectedGender == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecciona tu género"),
        ),
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePhotoScreen(),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            /// BARRA DE PROGRESO
            const UserProgressBar(step: 3),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(28),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 40),

                    const Text(
                      "¿Cuál es tu género?",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Selecciona lo que mejor te describa para mostrar tu perfil correctamente.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// OPCIONES
                    genderOption("Hombre"),
                    genderOption("Mujer"),
                    genderOption("Más allá del binario"),

                    const SizedBox(height: 20),

                    /// SWITCH MOSTRAR PERFIL
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        const Text(
                          "Mostrar en mi perfil",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),

                        Switch(
                          value: showOnProfile,
                          onChanged: (value) {
                            setState(() {
                              showOnProfile = value;
                            });
                          },
                        ),

                      ],
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

          ],
        ),
      ),
    );
  }
}