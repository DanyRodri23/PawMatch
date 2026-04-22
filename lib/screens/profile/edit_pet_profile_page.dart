import 'package:flutter/material.dart';
import '../../data/pet_profile_data.dart';
import '../../photos/pet_photos_page.dart';

class EditPetProfilePage extends StatefulWidget {
  const EditPetProfilePage({super.key});

  @override
  State<EditPetProfilePage> createState() =>
      _EditPetProfilePageState();
}

class _EditPetProfilePageState
    extends State<EditPetProfilePage> {

  final nameController =
      TextEditingController();

  final ageController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  String breed =
      "Golden Retriever";

  String gender =
      "Macho";

  String lookingFor =
      "Compañero de juego";

  bool pedigree = false;
  bool vaccinated = false;

  List<String> selectedTraits = [];

  final breeds = [
    "Golden Retriever",
    "Labrador",
    "Pastor Alemán",
    "Poodle",
    "Bulldog",
    "Chihuahua",
    "Beagle",
    "Husky",
    "Shih Tzu",
    "Mestizo",
  ];

  final traits = [
    "Juguetón",
    "Cariñoso",
    "Activo",
    "Sociable",
    "Protector",
    "Tranquilo",
    "Inteligente",
    "Territorial",
  ];

  final goals = [
    "Compañero de juego",
    "Reproducción",
    "Paseos",
    "Amistad",
    "Socializar",
  ];

  @override
  void initState() {
    super.initState();

    final pet =
        PetProfileData.pet;

    nameController.text =
        pet["name"] ?? "";

    ageController.text =
        pet["age"]
            .toString();

    descriptionController.text =
        pet["description"] ??
            "";

    breed =
        pet["breed"] ??
            breed;

    gender =
        pet["gender"] ??
            gender;

    lookingFor =
        pet["lookingFor"] ??
            lookingFor;

    pedigree =
        pet["pedigree"] ??
            false;

    vaccinated =
        pet["vaccinated"] ??
            false;

    selectedTraits =
        List<String>.from(
      pet["traits"] ?? [],
    );
  }

  void saveProfile() {
    PetProfileData.updatePet(
      name:
          nameController.text
              .trim(),
      age: int.tryParse(
              ageController
                  .text) ??
          0,
      breed: breed,
      gender: gender,
      lookingFor:
          lookingFor,
      description:
          descriptionController
              .text
              .trim(),
      pedigree:
          pedigree,
      vaccinated:
          vaccinated,
      traits:
          selectedTraits,
    );

    ScaffoldMessenger.of(
            context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Perfil actualizado 🔥",
        ),
      ),
    );

    Navigator.pop(
        context);
  }

  Widget sectionTitle(
      String text) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 12,
        top: 24,
      ),
      child: Align(
        alignment:
            Alignment.centerLeft,
        child: Text(
          text,
          style:
              const TextStyle(
            color:
                Colors.white,
            fontSize:
                22,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget input(
    String label,
    TextEditingController c,
  ) {
    return TextField(
      controller: c,
      style:
          const TextStyle(
        color:
            Colors.white,
      ),
      decoration:
          InputDecoration(
        labelText:
            label,
        labelStyle:
            const TextStyle(
          color:
              Colors.white60,
        ),
        filled: true,
        fillColor:
            Colors.white10,
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
                  18),
          borderSide:
              BorderSide.none,
        ),
      ),
    );
  }

  Widget dropdown(
    String value,
    List<String> items,
    Function(String?)
        onChanged,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            16,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white10,
        borderRadius:
            BorderRadius.circular(
                18),
      ),
      child:
          DropdownButtonHideUnderline(
        child:
            DropdownButton<String>(
          dropdownColor:
              Colors.black,
          value:
              value,
          isExpanded:
              true,
          style:
              const TextStyle(
            color:
                Colors.white,
          ),
          items: items
              .map(
                (e) =>
                    DropdownMenuItem(
                  value:
                      e,
                  child:
                      Text(
                    e,
                  ),
                ),
              )
              .toList(),
          onChanged:
              onChanged,
        ),
      ),
    );
  }

  Widget chip(
      String text) {
    final selected =
        selectedTraits
            .contains(
                text);

    return GestureDetector(
      onTap: () {
        setState(() {
          selected
              ? selectedTraits
                  .remove(
                      text)
              : selectedTraits
                  .add(
                      text);
        });
      },
      child: Container(
        margin:
            const EdgeInsets.only(
          right:
              8,
          bottom:
              8,
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal:
              16,
          vertical:
              10,
        ),
        decoration:
            BoxDecoration(
          color: selected
              ? Colors.blue
              : Colors.white10,
          borderRadius:
              BorderRadius.circular(
                  30),
        ),
        child: Text(
          text,
          style:
              const TextStyle(
            color:
                Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(
      BuildContext context) {
    final pet =
        PetProfileData.pet;

    final image =
        pet["images"] !=
                    null &&
                pet["images"]
                    .isNotEmpty
            ? pet["images"][0]
            : "https://placedog.net/500";

    return Scaffold(
      backgroundColor:
          const Color(
              0xFF0B0B0B),
      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,
        title:
            const Text(
          "Editar mascota",
          style:
              TextStyle(
            color:
                Colors.white,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
      body:
          SingleChildScrollView(
        padding:
            const EdgeInsets.all(
                20),
        child: Column(
          children: [

            /// FOTO
            // BUSCA la parte del CircleAvatar y REEMPLÁZALA por esto:

Column(
  children: [

    Stack(
      alignment: Alignment.bottomRight,
      children: [

        CircleAvatar(
          radius: 55,
          backgroundImage:
              NetworkImage(image),
        ),

        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const PetPhotosPage(),
              ),
            ).then((_) {
              setState(() {});
            });
          },
          child: Container(
            padding:
                const EdgeInsets.all(8),
            decoration:
                const BoxDecoration(
              color: Colors.blue,
              shape:
                  BoxShape.circle,
            ),
            child: const Icon(
              Icons.photo_camera,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ],
    ),

    const SizedBox(height: 14),

    SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const PetPhotosPage(),
            ),
          ).then((_) {
            setState(() {});
          });
        },
        icon: const Icon(
          Icons.photo_library,
          color: Colors.white,
        ),
        label: const Text(
          "Editar fotos",
          style: TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.bold,
          ),
        ),
        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              Colors.white10,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              18,
            ),
          ),
        ),
      ),
    ),
  ],
),

            Text(
              nameController
                      .text
                      .isEmpty
                  ? "Tu mascota"
                  : nameController
                      .text,
              style:
                  const TextStyle(
                color:
                    Colors.white,
                fontSize:
                    24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            sectionTitle(
                "Información"),

            input(
              "Nombre",
              nameController,
            ),

            const SizedBox(
                height:
                    14),

            input(
              "Edad",
              ageController,
            ),

            const SizedBox(
                height:
                    14),

            dropdown(
              breed,
              breeds,
              (v) {
                setState(() {
                  breed =
                      v!;
                });
              },
            ),

            const SizedBox(
                height:
                    14),

            dropdown(
              gender,
              [
                "Macho",
                "Hembra"
              ],
              (v) {
                setState(() {
                  gender =
                      v!;
                });
              },
            ),

            const SizedBox(
                height:
                    14),

            dropdown(
              lookingFor,
              goals,
              (v) {
                setState(() {
                  lookingFor =
                      v!;
                });
              },
            ),

            sectionTitle(
                "Personalidad"),

            Wrap(
              children: traits
                  .map(
                    (e) =>
                        chip(
                            e),
                  )
                  .toList(),
            ),

            sectionTitle(
                "Descripción"),

            input(
              "Cuéntanos sobre tu mascota",
              descriptionController,
            ),

            const SizedBox(
                height:
                    20),

            SwitchListTile(
              value:
                  vaccinated,
              activeThumbColor:
                  Colors.blue,
              title:
                  const Text(
                "Vacunas al día",
                style:
                    TextStyle(
                  color: Colors.white,
                ),
              ),
              onChanged:
                  (v) {
                setState(() {
                  vaccinated =
                      v;
                });
              },
            ),

            SwitchListTile(
              value:
                  pedigree,
              activeThumbColor:
                  Colors.orange,
              title:
                  const Text(
                "Tiene pedigree",
                style:
                    TextStyle(
                  color: Colors.white,
                ),
              ),
              onChanged:
                  (v) {
                setState(() {
                  pedigree =
                      v;
                });
              },
            ),

            const SizedBox(
                height:
                    30),

            Container(
              width: double.infinity,
              height:
                  58,
              decoration:
                  BoxDecoration(
                gradient:
                    const LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.purple,
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(
                        18),
              ),
              child:
                  ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors
                          .transparent,
                  shadowColor:
                      Colors
                          .transparent,
                ),
                onPressed:
                    saveProfile,
                child:
                    const Text(
                  "Guardar cambios",
                  style:
                      TextStyle(
                    fontSize:
                        16,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(
                height:
                    30),
          ],
        ),
      ),
    );
  }
}