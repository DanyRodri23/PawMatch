import 'package:flutter/material.dart';

class PetFullProfile extends StatelessWidget {

  final Map<String, dynamic> pet;

  const PetFullProfile({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SingleChildScrollView(

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Stack(
              children: [

                Image.network(
                  pet["image"],
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                Container(
                  height: 400,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black87,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 50,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    "${pet["name"]}, ${pet["age"]}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text("Raza: ${pet["breed"]}"),
                  const SizedBox(height: 10),

                  Text("Busca: ${pet["goal"]}"),
                  const SizedBox(height: 10),

                  const Text("Vacunas: ✔ Verificadas"),
                  const SizedBox(height: 20),

                  const Text("Dueño",
                      style: TextStyle(fontWeight: FontWeight.bold)),

                  const SizedBox(height: 10),

                  Row(
                    children: const [
                      CircleAvatar(radius: 20),
                      SizedBox(width: 10),
                      Text("Daniel, 21"),
                    ],
                  ),

                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}