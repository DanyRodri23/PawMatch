import 'package:flutter/material.dart';
import 'pet_vaccines_screen.dart';

class PetPedigreeScreen extends StatefulWidget {
  const PetPedigreeScreen({super.key});

  @override
  State<PetPedigreeScreen> createState() => _PetPedigreeScreenState();
}

class _PetPedigreeScreenState extends State<PetPedigreeScreen> {

  void uploadFile(){

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "La carga de archivos estará disponible en la versión móvil.",
        ),
      ),
    );

  }

  void cannotUpload(){

    showDialog(
      context: context,
      builder: (context){

        return AlertDialog(

          title: const Text("Información importante"),

          content: const Text(
            "Sube el certificado de pedigrí de tu mascota para validar que "
            "tu mascota es 100% de raza.\n\n"
            "Esta información será visible únicamente para PawMatch y no "
            "será compartida con otros usuarios.\n\n"
            "Los usuarios verán un check azul indicando que la mascota ha "
            "sido verificada como pedigrí.\n\n"
            "Si no puedes subirlo ahora, podrás hacerlo más adelante desde "
            "el perfil de tu mascota."
          ),

          actions: [

            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text("Entendido"),
            )

          ],

        );

      },
    );

  }

  void continueNext(){

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PetVaccinesScreen(
          isBreedDog: true,
        ),
      ),
    );

  }

  void goBack(){
    Navigator.pop(context);
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

            const SizedBox(height: 10),

            const Text(
              "Certificación de Pedigrí",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Sube el certificado de pedigrí de tu mascota para validar "
              "que tu mascota es 100% de raza.\n\n"
              "Esta información solo será visible para PawMatch y no será "
              "compartida con otros usuarios.\n\n"
              "En el perfil de tu mascota aparecerá un check azul que "
              "indicará que su pedigrí ha sido verificado.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 40),

            GestureDetector(

              onTap: uploadFile,

              child: Container(

                width: double.infinity,
                height: 140,

                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.grey.shade300),
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [

                    Icon(Icons.upload_file,
                        size:40,
                        color:Colors.black54),

                    SizedBox(height:10),

                    Text(
                      "Subir certificado",
                      style: TextStyle(fontSize:16),
                    )

                  ],
                ),

              ),

            ),

            const SizedBox(height:15),

            Center(
              child: GestureDetector(

                onTap: cannotUpload,

                child: const Text(
                  "No puedo subirlo en este momento",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    decoration: TextDecoration.underline,
                  ),
                ),

              ),
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

                onPressed: continueNext,

                child: const Text(
                  "Continuar",
                  style: TextStyle(
                    fontSize: 18,
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