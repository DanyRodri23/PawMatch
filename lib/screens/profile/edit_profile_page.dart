import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  final TextEditingController nameController =
      TextEditingController(text: "Max");

  final TextEditingController ageController =
      TextEditingController(text: "2");

  String ageType = "años";

  String selectedBreed = "Golden Retriever";
  String selectedGoal = "Compañero de juego";

  List<String> selectedPersonality = ["Juguetón"];

  final List<String> breeds = [
    "Golden Retriever",
    "Labrador",
    "Pug",
    "Bulldog",
    "Pastor Alemán",
    "Chihuahua",
  ];

  final List<String> goals = [
    "Compañero de juego",
    "Socializar",
    "Paseo",
    "Actividades",
    "Nuevos amigos",
    "Reproducción",
  ];

  final List<String> personalities = [
    "Juguetón",
    "Cariñoso",
    "Curioso",
    "Tranquilo",
    "Activo",
    "Protector",
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF7F7F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Editar perfil", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// FOTO
            Center(
              child: Column(
                children: [

                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1507146426996-ef05306b995a",
                    ),
                  ),

                  TextButton(
                    onPressed: () {},
                    child: const Text("Cambiar foto"),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 25),

            /// NOMBRE
            buildInput("Nombre", nameController),

            const SizedBox(height: 20),

            /// EDAD
            const Text("Edad", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Edad",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: ageType,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: ["años", "meses"]
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        ageType = value!;
                      });
                    },
                  ),
                )

              ],
            ),

            const SizedBox(height: 20),

            /// RAZA
            const Text("Raza", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              initialValue: selectedBreed,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: breeds.map((breed) => DropdownMenuItem(
                value: breed,
                child: Text(breed),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBreed = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            /// PERSONALIDAD
            const Text("Personalidad", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: personalities.map((p) {

                final isSelected = selectedPersonality.contains(p);

                return FilterChip(
                  label: Text(p),
                  selected: isSelected,
                  selectedColor: const Color(0xffFF9F1C),
                  onSelected: (selected) {

                    setState(() {

                      if(selected){
                        if(!selectedPersonality.contains(p)){
                          selectedPersonality.add(p);
                        }
                      } else {
                        selectedPersonality.remove(p);
                      }

                    });

                  },
                );

              }).toList(),
            ),

            const SizedBox(height: 25),

            /// QUE BUSCA
            const Text("¿Qué busca?", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              initialValue: selectedGoal,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: goals.map((goal) => DropdownMenuItem(
                value: goal,
                child: Text(goal),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGoal = value!;
                });
              },
            ),

            const SizedBox(height: 35),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffFF9F1C),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Guardar cambios"),
            ),

          ],
        ),
      ),
    );
  }

  Widget buildInput(String label, TextEditingController controller){
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}