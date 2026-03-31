import 'package:flutter/material.dart';
import 'pet_personality_screen.dart';

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
    Navigator.pop(context);
  }

  Widget photoBox(int index) {

    final isMain = index == 0;

    return GestureDetector(
      onTap: () {
        // 🔥 luego aquí metemos picker
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),

          gradient: LinearGradient(
            colors: [
              Colors.grey.shade100,
              Colors.grey.shade200,
            ],
          ),

          border: Border.all(
            color: isMain ? Colors.black : Colors.grey.shade300,
            width: isMain ? 2 : 1,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 15,
              offset: const Offset(0, 6),
            )
          ],
        ),

        child: Stack(
          children: [

            /// ICONO
            const Center(
              child: Icon(
                Icons.add_a_photo_rounded,
                size: 32,
                color: Colors.black54,
              ),
            ),

            /// BADGE PRINCIPAL
            if (isMain)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Principal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

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
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => goBack(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(28),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 30),

            /// TITULO PRO
            const Text(
              "Fotos de tu mascota",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Agrega fotos increíbles para destacar 🐾",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 25),

            /// GRID PREMIUM
            Expanded(
              child: GridView.builder(
                itemCount: 6,

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),

                itemBuilder: (context, index){
                  return photoBox(index);
                },
              ),
            ),

            const SizedBox(height: 15),

            /// BOTÓN UNICORNIO 🦄
            SizedBox(
              width: double.infinity,
              height: 60,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,

                  elevation: 8,
                  shadowColor: Colors.black26,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),

                onPressed: ()=>goNext(context),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [

                    Text(
                      "Continuar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(width: 8),

                    Icon(Icons.arrow_forward_rounded)

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}