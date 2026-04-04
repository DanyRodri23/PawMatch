import 'package:flutter/material.dart';
import 'dart:ui';
import '../match/match_page.dart';

class DiscoverResultsPage extends StatelessWidget {

  final String goal;

  const DiscoverResultsPage({
    super.key,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      body: Stack(
        children: [

          /// 🔥 MATCH PAGE (FONDO)
          const MatchPage(),

          /// 🔥 HEADER PRO
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      children: [

                        /// 🔙 BOTÓN ATRÁS
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// 🔥 TITULO
                        Expanded(
                          child: Text(
                            goal,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),

                        /// ✨ ICONO OPCIONAL
                        const Icon(
                          Icons.tune,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}