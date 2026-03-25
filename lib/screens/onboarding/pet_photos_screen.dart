import 'package:flutter/material.dart';
import 'pet_personality_screen.dart';
import 'pet_vaccines_screen.dart';

class PetPhotosScreen extends StatelessWidget {

  final bool isBreedDog;

  const PetPhotosScreen({
    super.key,
    required this.isBreedDog,
  });

  void goNext(BuildContext context){

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetPersonalityScreen(
          isBreedDog: isBreedDog,
        ),
      ),
    );

  }

  void goBack(BuildContext context){

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetVaccinesScreen(
          isBreedDog: isBreedDog,
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
          icon: const Icon(Icons.arrow_back,color:Colors.black),
          onPressed: ()=>goBack(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(28),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height:40),

            const Text(
              "Fotos de tu mascota",
              style: TextStyle(
                fontSize:32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height:20),

            const Text(
              "Agrega fotos de tu mascota para que otros usuarios puedan conocerla mejor.",
              style: TextStyle(
                color: Colors.black54,
              ),
            ),

            const SizedBox(height:30),

            Expanded(
              child: GridView.builder(

                itemCount:6,

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:3,
                  crossAxisSpacing:10,
                  mainAxisSpacing:10,
                ),

                itemBuilder: (context,index){

                  return Container(

                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: const Icon(Icons.add_a_photo),

                  );

                },

              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),

                onPressed: ()=>goNext(context),

                child: const Text("Continuar"),

              ),
            )

          ],
        ),
      ),
    );
  }
}