import 'package:flutter/material.dart';
import 'discover_results_page.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  Widget categoryCard(
    BuildContext context,
    String title,
    String emoji,
  ) {
    return GestureDetector(

      onTap: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiscoverResultsPage(
              goal: title,
            ),
          ),
        );

      },

      child: Container(

        padding: const EdgeInsets.all(22),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius: BorderRadius.circular(22),

          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0,4),
            )
          ],

        ),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Text(
              emoji,
              style: const TextStyle(
                fontSize: 42,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

          ],

        ),

      ),

    );
  }

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.all(20),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          const SizedBox(height: 10),

          const Text(
            "¿Qué busca tu mascota?",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Encuentra mascotas que buscan lo mismo dentro de PawMatch.",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 30),

          Expanded(

            child: GridView.count(

              crossAxisCount: 2,

              crossAxisSpacing: 16,
              mainAxisSpacing: 16,

              children: [

                categoryCard(
                  context,
                  "Compañero de juego",
                  "🐾",
                ),

                categoryCard(
                  context,
                  "Socializar",
                  "🐕",
                ),

                categoryCard(
                  context,
                  "Compañero de paseo",
                  "🦮",
                ),

                categoryCard(
                  context,
                  "Actividades",
                  "🎾",
                ),

                categoryCard(
                  context,
                  "Nuevos amigos",
                  "🐶",
                ),

                categoryCard(
                  context,
                  "Reproducción",
                  "❤️",
                ),

              ],

            ),

          ),

        ],

      ),

    );
  }
}