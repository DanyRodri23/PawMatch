import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import '../../data/pet_profile_data.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pet = PetProfileData.pet;

    final String name =
        pet["name"] ?? "Mascota";

    final int age =
        pet["age"] ?? 0;

    final String ageType =
        pet["ageType"] ?? "";

    final String breed =
        pet["breed"] ?? "Sin raza";

    final String gender =
        pet["gender"] ?? "No definido";

    final bool verified =
        pet["verified"] ?? false;

    final List<dynamic> images =
        pet["images"] ?? [];

    final List<dynamic> traits =
        pet["traits"] ?? [];

    final String lookingFor =
        pet["lookingFor"] ??
            "Compañía";

    final String mainPhoto =
        images.isNotEmpty
            ? images[0].toString()
            : "https://placedog.net/500";

    final String secondPhoto =
        images.length > 1
            ? images[1].toString()
            : mainPhoto;

    final String personality =
        traits.isNotEmpty
            ? traits[0].toString()
            : "Amigable";

    return Scaffold(
      backgroundColor:
          Colors.black,
      body: SafeArea(
        child:
            SingleChildScrollView(
          padding:
              const EdgeInsets.all(
            20,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .center,
            children: [

              /// HEADER
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: const [
                  Text(
                    "Perfil de tu mascota",
                    style:
                        TextStyle(
                      color:
                          Colors.white,
                      fontSize:
                          22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.settings,
                    color:
                        Colors.white54,
                  ),
                ],
              ),

              const SizedBox(
                height: 30,
              ),

              /// FOTO + VERIFICADO
              Stack(
                alignment:
                    Alignment.center,
                children: [
                  Container(
                    decoration:
                        BoxDecoration(
                      shape:
                          BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue
                              .withValues(
                            alpha: 0.4,
                          ),
                          blurRadius:
                              30,
                        ),
                      ],
                    ),
                    child:
                        CircleAvatar(
                      radius: 55,
                      backgroundImage:
                          NetworkImage(
                        mainPhoto,
                      ),
                    ),
                  ),

                  if (verified)
                    Positioned(
                      bottom: 0,
                      right: 10,
                      child:
                          Container(
                        decoration:
                            const BoxDecoration(
                          color:
                              Colors.blue,
                          shape:
                              BoxShape.circle,
                        ),
                        padding:
                            const EdgeInsets.all(
                          6,
                        ),
                        child:
                            const Icon(
                          Icons
                              .verified,
                          color:
                              Colors.white,
                          size:
                              18,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(
                height: 15,
              ),

              Text(
                "$name, $age",
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

              Text(
                breed,
                style:
                    const TextStyle(
                  color:
                      Colors.white54,
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              /// PROGRESO
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children:
                        const [
                      Text(
                        "Perfil completado",
                        style:
                            TextStyle(
                          color:
                              Colors.white70,
                        ),
                      ),
                      Text(
                        "100%",
                        style:
                            TextStyle(
                          color:
                              Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                    child:
                        LinearProgressIndicator(
                      value:
                          1,
                      minHeight:
                          8,
                      backgroundColor:
                          Colors.grey[
                              800],
                      valueColor:
                          const AlwaysStoppedAnimation<
                              Color>(
                        Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 30,
              ),

              /// FOTOS
              _sectionTitle(
                "Fotos",
              ),

              const SizedBox(
                height: 10,
              ),

              Row(
                children: [
                  _photo(
                    mainPhoto,
                  ),
                  _photo(
                    secondPhoto,
                  ),
                  _addPhoto(),
                ],
              ),

              const SizedBox(
                height: 30,
              ),

              /// INFO
              _sectionTitle(
                "Información",
              ),

              const SizedBox(
                height: 10,
              ),

              _infoItem(
                "Sexo",
                gender,
              ),

              _infoItem(
                "Edad",
                "$age $ageType",
              ),

              _infoItem(
                "Personalidad",
                personality,
              ),

              _infoItem(
                "Busca",
                lookingFor,
              ),

              const SizedBox(
                height: 40,
              ),

              /// BOTÓN EDITAR
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) =>
                              EditProfileSelectorPage(),
                    ),
                  );
                },
                child:
                    Container(
                  width:
                      double.infinity,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
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
                      14,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue
                            .withValues(
                          alpha: 0.5,
                        ),
                        blurRadius:
                            20,
                      ),
                    ],
                  ),
                  child:
                      const Center(
                    child: Text(
                      "Editar perfil",
                      style:
                          TextStyle(
                        color:
                            Colors.white,
                        fontSize:
                            16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(
    String text,
  ) {
    return Text(
      text,
      style:
          const TextStyle(
        color:
            Colors.white,
        fontSize:
            18,
        fontWeight:
            FontWeight.bold,
      ),
    );
  }

  Widget _photo(
    String url,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        right: 10,
      ),
      width: 80,
      height: 80,
      decoration:
          BoxDecoration(
        borderRadius:
            BorderRadius.circular(
          14,
        ),
        image:
            DecorationImage(
          image:
              NetworkImage(
            url,
          ),
          fit:
              BoxFit.cover,
        ),
      ),
    );
  }

  Widget _addPhoto() {
    return Container(
      width: 80,
      height: 80,
      decoration:
          BoxDecoration(
        color:
            Colors.grey[900],
        borderRadius:
            BorderRadius.circular(
          14,
        ),
      ),
      child:
          const Icon(
        Icons.add,
        color:
            Colors.white54,
      ),
    );
  }

  Widget _infoItem(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
        children: [
          Text(
            title,
            style:
                const TextStyle(
              color:
                  Colors.white54,
            ),
          ),
          Text(
            value,
            style:
                const TextStyle(
              color:
                  Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}