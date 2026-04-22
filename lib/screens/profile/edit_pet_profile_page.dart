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

  String breed = "Golden Retriever";
  String gender = "Macho";
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

  final goals = [
    "Compañero de juego",
    "Reproducción",
    "Paseos",
    "Amistad",
    "Socializar",
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
    "Aventurero",
    "Dormilón",
    "Curioso",
    "Leal",
    "Travieso",
    "Amigable",
  ];

  @override
  void initState() {
    super.initState();

    final pet =
        PetProfileData.pet;

    nameController.text =
        pet["name"] ?? "";

    ageController.text =
        pet["age"].toString();

    descriptionController.text =
        pet["description"] ?? "";

    breed =
        pet["breed"] ?? breed;

    gender =
        pet["gender"] ?? gender;

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
              ageController.text) ??
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

    Navigator.pop(context);
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
        0xFF050505,
      ),

      body: SafeArea(
        child:
            SingleChildScrollView(
          padding:
              const EdgeInsets.all(
            18,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [

              /// HEADER
              Row(
                children: [

                  _circleButton(
                    Icons.arrow_back,
                    () {
                      Navigator.pop(
                          context);
                    },
                  ),

                  const Spacer(),

                  const Text(
                    "Editar Mascota",
                    style:
                        TextStyle(
                      color:
                          Colors.white,
                      fontSize:
                          20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  const SizedBox(
                    width: 46,
                  ),
                ],
              ),

              const SizedBox(
                  height: 28),

              /// FOTO PRINCIPAL
              Center(
                child: Column(
                  children: [

                    Stack(
                      alignment:
                          Alignment
                              .bottomRight,
                      children: [

                        Container(
                          width: 130,
                          height: 130,
                          decoration:
                              BoxDecoration(
                            shape:
                                BoxShape
                                    .circle,
                            border:
                                Border.all(
                              color:
                                  Colors.blue,
                              width: 3,
                            ),
                            image:
                                DecorationImage(
                              image:
                                  NetworkImage(
                                image,
                              ),
                              fit: BoxFit
                                  .cover,
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        const PetPhotosPage(),
                              ),
                            ).then(
                              (_) {
                                setState(
                                    () {});
                              },
                            );
                          },
                          child:
                              Container(
                            width: 42,
                            height: 42,
                            decoration:
                                const BoxDecoration(
                              color:
                                  Colors.blue,
                              shape:
                                  BoxShape.circle,
                            ),
                            child:
                                const Icon(
                              Icons
                                  .photo_camera,
                              color:
                                  Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                        height: 14),

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
                            28,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),

                    const SizedBox(
                        height: 6),

                    Text(
                      breed,
                      style:
                          const TextStyle(
                        color:
                            Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                  height: 28),

              _title(
                  "Información"),

              _input(
                "Nombre",
                nameController,
              ),

              const SizedBox(
                  height: 14),

              _input(
                "Edad",
                ageController,
              ),

              const SizedBox(
                  height: 14),

              _dropdown(
                breed,
                breeds,
                (v) {
                  setState(() {
                    breed = v!;
                  });
                },
              ),

              const SizedBox(
                  height: 14),

              _dropdown(
                gender,
                [
                  "Macho",
                  "Hembra"
                ],
                (v) {
                  setState(() {
                    gender = v!;
                  });
                },
              ),

              const SizedBox(
                  height: 14),

              _dropdown(
                lookingFor,
                goals,
                (v) {
                  setState(() {
                    lookingFor =
                        v!;
                  });
                },
              ),

              const SizedBox(
                  height: 26),

              _title(
                  "Personalidad"),

              const SizedBox(
                  height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: traits
                    .map(
                      (e) =>
                          _chip(e),
                    )
                    .toList(),
              ),

              const SizedBox(
                  height: 26),

              _title(
                  "Descripción"),

              const SizedBox(
                  height: 12),

              _input(
                "Cuéntanos sobre tu mascota",
                descriptionController,
                maxLines: 4,
              ),

              const SizedBox(
                  height: 26),

              _title(
                  "Verificaciones"),

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
                    color:
                        Colors.white,
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
                    color:
                        Colors.white,
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
                  height: 30),

              SizedBox(
                width:
                    double.infinity,
                height: 58,
                child:
                    ElevatedButton(
                  onPressed:
                      saveProfile,
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blue,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),
                  ),
                  child:
                      const Text(
                    "Guardar cambios",
                    style:
                        TextStyle(
                      color:
                          Colors.white,
                      fontWeight:
                          FontWeight.bold,
                      fontSize:
                          17,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                  height: 35),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration:
            BoxDecoration(
          color:
              Colors.white10,
          shape:
              BoxShape.circle,
        ),
        child: Icon(
          icon,
          color:
              Colors.white,
        ),
      ),
    );
  }

  Widget _title(
      String text) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 12,
      ),
      child: Text(
        text,
        style:
            const TextStyle(
          color:
              Colors.white,
          fontSize: 22,
          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }

  Widget _input(
    String label,
    TextEditingController c, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: c,
      maxLines: maxLines,
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
            18,
          ),
          borderSide:
              BorderSide.none,
        ),
      ),
    );
  }

  Widget _dropdown(
    String value,
    List<String> items,
    Function(String?)
        onChanged,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white10,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
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
                      Text(e),
                ),
              )
              .toList(),
          onChanged:
              onChanged,
        ),
      ),
    );
  }

  Widget _chip(
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
        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration:
            BoxDecoration(
          color: selected
              ? Colors.blue
              : Colors.white10,
          borderRadius:
              BorderRadius.circular(
            30,
          ),
        ),
        child: Text(
          text,
          style:
              const TextStyle(
            color:
                Colors.white,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),
    );
  }
}