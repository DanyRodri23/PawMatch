import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'hotels_screen.dart';

class IntroHotelsScreen extends StatelessWidget {
  const IntroHotelsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [

          Image.network(
            "https://images.unsplash.com/photo-1566073771259-6a8506099945",
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          Container(color: Colors.black.withValues(alpha: 0.6)),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Spacer(),

                  const Text(
                    "Pet-Friendly Hotels 🏨",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Encuentra hoteles ideales para ti y tu mascota.",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 30),

                  GestureDetector(
                    onTap: () async {

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('seenHotelsIntro', true);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HotelsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.purple],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text(
                          "Explorar hoteles",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}