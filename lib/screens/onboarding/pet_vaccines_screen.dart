import 'package:flutter/material.dart';
import 'pet_photos_screen.dart';
import 'pet_pedigree_screen.dart';
import 'pet_breed_type_screen.dart';
import 'pet_vaccine_card_screen.dart';

class PetVaccinesScreen extends StatefulWidget {

  final bool isBreedDog;

  const PetVaccinesScreen({
    super.key,
    required this.isBreedDog,
  });

  @override
  State<PetVaccinesScreen> createState() => _PetVaccinesScreenState();
}

class _PetVaccinesScreenState extends State<PetVaccinesScreen> {

  bool? hasVaccines;
  int vaccineCount = 1;

  void goBack(){

    if(widget.isBreedDog){

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PetPedigreeScreen(),
        ),
      );

    }else{

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PetBreedTypeScreen(),
        ),
      );

    }

  }

  void goNext(){

    if(hasVaccines == null){

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecciona una opción"),
        ),
      );

      return;
    }

    /// 🔥 SI TIENE VACUNAS → VA AL CARNET
    if(hasVaccines == true){

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PetVaccineCardScreen(),
        ),
      );

    } else {

      /// 🔥 SI NO TIENE → VA DIRECTO A FOTOS
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PetPhotosScreen(
            isBreedDog: widget.isBreedDog,
            fromVaccineCard: false, // 🔥 ESTE ERA EL ERROR
          ),
        ),
      );

    }

  }

  Widget option(bool value,String label){

    final selected = hasVaccines == value;

    return GestureDetector(

      onTap: (){
        setState(() {
          hasVaccines = value;
        });
      },

      child: Container(

        margin: const EdgeInsets.symmetric(vertical:10),

        padding: const EdgeInsets.symmetric(
          vertical:18,
          horizontal:20,
        ),

        decoration: BoxDecoration(

          color: selected ? Colors.black : Colors.grey.shade100,

          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: selected ? Colors.black : Colors.grey.shade300,
          ),

        ),

        child: Row(
          children: [

            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selected ? Colors.white : Colors.black54,
            ),

            const SizedBox(width:12),

            Text(
              label,
              style: TextStyle(
                fontSize:18,
                color: selected ? Colors.white : Colors.black,
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
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.black),
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
              "Vacunas de tu mascota",
              style: TextStyle(
                fontSize:32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height:10),

            const Text(
              "Indica si tu mascota tiene vacunas registradas.",
              style: TextStyle(
                fontSize:16,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height:30),

            option(true,"Sí tiene vacunas"),
            option(false,"No tiene vacunas"),

            const SizedBox(height:20),

            if(hasVaccines == true)

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "¿Cuántas vacunas tiene?",
                  style: TextStyle(
                    fontSize:18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height:10),

                Container(

                  padding: const EdgeInsets.symmetric(horizontal:15),

                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: DropdownButton<int>(

                    value: vaccineCount,

                    underline: const SizedBox(),

                    isExpanded: true,

                    items: List.generate(10,(index){

                      int value = index + 1;

                      return DropdownMenuItem(
                        value: value,
                        child: Text("$value vacunas"),
                      );

                    }),

                    onChanged: (value){

                      setState(() {
                        vaccineCount = value!;
                      });

                    },

                  ),
                ),

              ],
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