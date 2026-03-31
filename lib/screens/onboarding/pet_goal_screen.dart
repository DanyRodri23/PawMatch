import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pet_profile_success_screen.dart';

class PetGoalScreen extends StatefulWidget {
  final bool isBreedDog;

  const PetGoalScreen({
    super.key,
    required this.isBreedDog,
  });

  @override
  State<PetGoalScreen> createState() => _PetGoalScreenState();
}

class _PetGoalScreenState extends State<PetGoalScreen>
    with TickerProviderStateMixin {

  String? selectedGoal;

  final List<Map<String, String>> goals = [
    {"emoji": "🐶", "text": "Compañero de juego"},
    {"emoji": "🐾", "text": "Socializar mascotas"},
    {"emoji": "🚶", "text": "Compañero de paseo"},
    {"emoji": "❤️", "text": "Reproducción"},
    {"emoji": "🌳", "text": "Actividades"},
    {"emoji": "🐕", "text": "Nuevos amigos"}
  ];

  void goNext() {
    if (selectedGoal == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PetProfileSuccessScreen(),
      ),
    );
  }

  Widget goalCard(String emoji, String text, int index) {
    final selected = selectedGoal == text;

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 80)),
      tween: Tween<double>(begin: 0.8, end: 1),
      curve: Curves.easeOutBack,

      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },

      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact(); // 🔥 vibración pro

          setState(() {
            selectedGoal = text;
          });
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,

          decoration: BoxDecoration(
            color: selected ? Colors.black : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(24),

            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
          ),

          child: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: selected ? 1.08 : 1.0,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: selected ? 1.3 : 1.0,

                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : Colors.black,
                    ),
                  ),
                ),

                if (selected)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 18,
                    ),
                  )
              ],
            ),
          ),
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
          onPressed: () => Navigator.pop(context), // 🔥 FIX BACK REAL
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10),

            const Text(
              "¿Qué buscas para tu mascota?",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Selecciona el objetivo dentro de PawMatch 🐾",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),

                itemCount: goals.length,

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 🔥 más premium
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),

                itemBuilder: (context, index) {
                  final goal = goals[index];

                  return goalCard(
                    goal["emoji"]!,
                    goal["text"]!,
                    index,
                  );
                },
              ),
            ),

            /// 🔥 BOTÓN PRO NIVEL APP GRANDE
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),

              width: double.infinity,
              height: 60,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),

                gradient: selectedGoal != null
                    ? const LinearGradient(
                        colors: [
                          Color(0xFF000000),
                          Color(0xFF1C1C1C),
                        ],
                      )
                    : null,

                color: selectedGoal == null
                    ? Colors.grey.shade300
                    : null,

                boxShadow: selectedGoal != null
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ]
                    : [],
              ),

              child: ElevatedButton(
                onPressed: selectedGoal == null ? null : goNext,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [

                    Text(
                      "Continuar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(width: 8),

                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}