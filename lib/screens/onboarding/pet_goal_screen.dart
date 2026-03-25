import 'package:flutter/material.dart';
import 'pet_personality_screen.dart';
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

class _PetGoalScreenState extends State<PetGoalScreen> {

  String? selectedGoal;

  final List<Map<String,String>> goals = [

    {"emoji":"🐶","text":"Compañero de juego"},
    {"emoji":"🐾","text":"Socializar mascotas"},
    {"emoji":"🚶","text":"Compañero de paseo"},
    {"emoji":"❤️","text":"Reproducción"},
    {"emoji":"🌳","text":"Actividades"},
    {"emoji":"🐕","text":"Nuevos amigos"}

  ];

  void goBack(){

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PetPersonalityScreen(
          isBreedDog: widget.isBreedDog,
        ),
      ),
    );

  }

  void goNext(){

    if(selectedGoal == null){

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecciona una opción"),
        ),
      );

      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const PetProfileSuccessScreen(),
      ),
    );

  }

  Widget goalCard(String emoji,String text){

    final selected = selectedGoal == text;

    return GestureDetector(

      onTap: (){
        setState(() {
          selectedGoal = text;
        });
      },

      child: Container(

        decoration: BoxDecoration(

          color: selected
              ? Colors.black
              : const Color(0xffF1F1F1),

          borderRadius: BorderRadius.circular(18),

        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              emoji,
              style: const TextStyle(fontSize:34),
            ),

            const SizedBox(height:10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal:10),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize:16,
                  fontWeight: FontWeight.w500,
                  color: selected ? Colors.white : Colors.black,
                ),
              ),
            )

          ],
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
        elevation:0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color:Colors.black),
          onPressed: goBack,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const SizedBox(height:10),

            const Text(
              "¿Qué buscas para tu mascota?",
              style: TextStyle(
                fontSize:32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height:8),

            const Text(
              "Selecciona el objetivo dentro de PawMatch.",
              style: TextStyle(
                fontSize:16,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height:30),

            Expanded(

              child: GridView.builder(

                itemCount: goals.length,

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,

                ),

                itemBuilder: (context,index){

                  final goal = goals[index];

                  return goalCard(
                    goal["emoji"]!,
                    goal["text"]!,
                  );

                },

              ),

            ),

            const SizedBox(height:10),

            SizedBox(
              width: double.infinity,
              height:55,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(

                  backgroundColor: selectedGoal == null
                      ? Colors.grey.shade300
                      : Colors.black,

                  foregroundColor: selectedGoal == null
                      ? Colors.grey
                      : Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),

                ),

                onPressed: selectedGoal == null
                    ? null
                    : goNext,

                child: const Text(
                  "Siguiente",
                  style: TextStyle(
                    fontSize:18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
            ),

            const SizedBox(height:10),

          ],
        ),
      ),
    );
  }
}