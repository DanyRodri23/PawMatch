import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'pet_name_screen.dart';

class PetIntroScreen extends StatefulWidget {
  const PetIntroScreen({super.key});

  @override
  State<PetIntroScreen> createState() => _PetIntroScreenState();
}

class _PetIntroScreenState extends State<PetIntroScreen> {

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(
      "assets/videos/pet_intro.mp4",
    )
      ..initialize().then((_) {
        setState(() {});
      });

    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startPetProfile() {

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const PetNameScreen(),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

          /// VIDEO FONDO
          SizedBox.expand(
            child: _controller.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : Container(color: Colors.black),
          ),

          /// OSCURECER VIDEO (SIN withOpacity)
          Container(
            color: const Color.fromRGBO(0, 0, 0, 0.35),
          ),

          /// TARJETA CENTRAL
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              padding: const EdgeInsets.all(28),

              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 0.25),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color.fromRGBO(255, 255, 255, 0.5),
                  width: 1.5,
                ),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Text(
                    "Perfil de tu mascota 🐶",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Ahora agregaremos la información de tu mascota para encontrar el match perfecto.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),

                      onPressed: startPetProfile,

                      child: const Text(
                        "Comenzar",
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
          ),

        ],
      ),
    );
  }
}