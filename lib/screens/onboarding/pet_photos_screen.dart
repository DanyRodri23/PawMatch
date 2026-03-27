import 'package:flutter/material.dart';
import 'pet_personality_screen.dart';
import 'pet_vaccines_screen.dart';

class PetPhotosScreen extends StatelessWidget {

  final bool isBreedDog;
  final bool fromVaccineCard;

  const PetPhotosScreen({
    super.key,
    required this.isBreedDog,
    this.fromVaccineCard = false,
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
    if(fromVaccineCard){
      Navigator.pop(context); // 🔥 vuelve a carnet
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PetVaccinesScreen(
            isBreedDog: isBreedDog,
          ),
        ),
      );
    }
  }

  Widget photoBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
          )
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.add_a_photo,
          size: 28,
          color: Colors.black54,
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

            const SizedBox(height:10),

            const Text(
              "Agrega al menos una foto para que tu mascota destaque 🐾",
              style: TextStyle(
                color: Colors.black54,
              ),
            ),

            const SizedBox(height:25),

            Expanded(
              child: GridView.builder(

                itemCount:6,

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:3,
                  crossAxisSpacing:12,
                  mainAxisSpacing:12,
                ),

                itemBuilder: (context,index){
                  return photoBox();
                },

              ),
            ),

            const SizedBox(height:10),

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

                onPressed: ()=>goNext(context),

                child: const Text(
                  "Continuar",
                  style: TextStyle(
                    fontSize:18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
            )

          ],
        ),
      ),
    );
  }
}