import 'package:flutter/material.dart';
import 'pet_photos_screen.dart';
import 'pet_goal_screen.dart';

class PetPersonalityScreen extends StatefulWidget {

  final bool isBreedDog;

  const PetPersonalityScreen({
    super.key,
    required this.isBreedDog,
  });

  @override
  State<PetPersonalityScreen> createState() => _PetPersonalityScreenState();
}

class _PetPersonalityScreenState extends State<PetPersonalityScreen> {

  List<String> selectedTraits = [];

  final List<String> traits = [

    "Juguetón",
    "Cariñoso",
    "Activo",
    "Protector",
    "Tranquilo",
    "Sociable",
    "Curioso",
    "Energético",
    "Amigable",
    "Dormilón",
    "Inteligente",
    "Travieso",
    "Valiente",
    "Leal",
    "Aventurero",
    "Obediente",
    "Independiente",
    "Territorial",
    "Paciente",
    "Alerta",
    "Tímido",
    "Divertido",
    "Explorador",
    "Amoroso",
    "Atlético",
    "Juguetón con otros perros",
    "Protector con la familia",
    "Muy sociable",
    "Calmado",
    "Curioso con todo"

  ];

  void goBack(){

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PetPhotosScreen(
          isBreedDog: widget.isBreedDog,
        ),
      ),
    );

  }

  void goNext(){

    if(selectedTraits.isEmpty){

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecciona al menos una personalidad"),
        ),
      );

      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PetGoalScreen(
          isBreedDog: widget.isBreedDog,
        ),
      ),
    );

  }

  void toggleTrait(String trait){

    setState(() {

      if(selectedTraits.contains(trait)){

        selectedTraits.remove(trait);

      }else{

        if(selectedTraits.length < 6){

          selectedTraits.add(trait);

        }else{

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Máximo 6 características"),
            ),
          );

        }

      }

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color:Colors.black),
          onPressed: goBack,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(28),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height:30),

            const Text(
              "Personalidad de tu mascota",
              style: TextStyle(
                fontSize:32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height:10),

            const Text(
              "Selecciona las características que mejor describan a tu mascota (máximo 6).",
              style: TextStyle(
                fontSize:16,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height:20),

            Wrap(
              spacing:10,
              runSpacing:10,
              children: traits.map((trait){

                final selected = selectedTraits.contains(trait);

                return ChoiceChip(

                  label: Text(trait),

                  selected: selected,

                  selectedColor: Colors.black,

                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.black,
                  ),

                  onSelected: (_) => toggleTrait(trait),

                );

              }).toList(),
            ),

            const Spacer(),

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
                    fontSize:18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
            ),

            const SizedBox(height:20),

          ],
        ),
      ),
    );
  }
}