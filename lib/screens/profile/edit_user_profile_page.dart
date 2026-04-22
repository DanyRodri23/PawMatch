import 'package:flutter/material.dart';
import '../../data/user_profile_data.dart';
import '../../photos/user_photos_page.dart';

class EditUserProfilePage extends StatefulWidget {
  const EditUserProfilePage({super.key});

  @override
  State<EditUserProfilePage> createState() =>
      _EditUserProfilePageState();
}

class _EditUserProfilePageState
    extends State<EditUserProfilePage> {

  late TextEditingController nameController;
  late TextEditingController bioController;
  late TextEditingController instagramController;

  String gender = "Masculino";
  bool verified = false;
  bool showGender = true;

  @override
  void initState() {
    super.initState();

    final user = UserProfileData.user;

    nameController =
        TextEditingController(
      text: user["name"] ?? "",
    );

    bioController =
        TextEditingController(
      text: user["bio"] ?? "",
    );

    instagramController =
        TextEditingController(
      text:
          user["instagram"] ??
              "@usuario",
    );

    gender =
        user["gender"] ??
            "Masculino";

    verified =
        user["verified"] ??
            false;

    showGender =
        user["showGender"] ??
            true;
  }

  void saveProfile() {
    UserProfileData.updateUser(
      name:
          nameController.text
              .trim(),
      bio:
          bioController.text
              .trim(),
      instagram:
          instagramController
              .text
              .trim(),
      gender: gender,
      verified:
          verified,
      showGender:
          showGender,
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

  Widget titleText(
    String text,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        top: 24,
        bottom: 12,
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
    {int maxLines = 1}
  ) {
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

  Widget dropdown() {
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
              gender,
          isExpanded:
              true,
          style:
              const TextStyle(
            color:
                Colors.white,
          ),
          items: const [
            DropdownMenuItem(
              value:
                  "Masculino",
              child: Text(
                "Masculino",
              ),
            ),
            DropdownMenuItem(
              value:
                  "Femenino",
              child: Text(
                "Femenino",
              ),
            ),
            DropdownMenuItem(
              value:
                  "Prefiero no decir",
              child: Text(
                "Prefiero no decir",
              ),
            ),
          ],
          onChanged: (v) {
            setState(() {
              gender = v!;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(
      BuildContext context) {

    final user =
        UserProfileData.user;

    final images =
        user["images"] ?? [];

    final mainImage =
        images.isNotEmpty
            ? images[0]
            : "https://i.pravatar.cc/300";

    return Scaffold(
      backgroundColor:
          const Color(
        0xFF0B0B0B,
      ),

      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,
        title:
            const Text(
          "Editar propietario",
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
          20,
        ),
        child: Column(
          children: [

            /// FOTO + EDITAR
            Column(
              children: [

                Stack(
                  alignment:
                      Alignment.bottomRight,
                  children: [

                    CircleAvatar(
                      radius: 55,
                      backgroundImage:
                          NetworkImage(
                        mainImage,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const UserPhotosPage(),
                          ),
                        ).then((_) {
                          setState(() {});
                        });
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.all(
                          8,
                        ),
                        decoration:
                            const BoxDecoration(
                          color:
                              Colors.blue,
                          shape:
                              BoxShape.circle,
                        ),
                        child:
                            const Icon(
                          Icons.photo_camera,
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
                    height: 14),

                SizedBox(
                  width:
                      double.infinity,
                  height: 52,
                  child:
                      ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const UserPhotosPage(),
                        ),
                      ).then((_) {
                        setState(() {});
                      });
                    },
                    icon:
                        const Icon(
                      Icons.photo_library,
                      color:
                          Colors.white,
                    ),
                    label:
                        const Text(
                      "Editar fotos",
                      style:
                          TextStyle(
                        color:
                            Colors.white,
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

            const SizedBox(
                height: 18),

            Text(
              nameController.text,
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

            const SizedBox(
                height: 8),

            titleText(
              "Información",
            ),

            input(
              "Nombre",
              nameController,
            ),

            const SizedBox(
                height: 14),

            dropdown(),

            const SizedBox(
                height: 14),

            SwitchListTile(
              value:
                  showGender,
              activeThumbColor:
                  Colors.blue,
              title:
                  const Text(
                "Mostrar género en perfil",
                style:
                    TextStyle(
                  color:
                      Colors.white,
                ),
              ),
              onChanged:
                  (v) {
                setState(() {
                  showGender =
                      v;
                });
              },
            ),

            const SizedBox(
                height: 14),

            input(
              "Instagram",
              instagramController,
            ),

            titleText(
              "Biografía",
            ),

            input(
              "Cuéntanos sobre ti",
              bioController,
              maxLines: 4,
            ),

            const SizedBox(
                height: 18),

            SwitchListTile(
              value:
                  verified,
              activeThumbColor:
                  Colors.blue,
              title:
                  const Text(
                "Perfil verificado",
                style:
                    TextStyle(
                  color:
                      Colors.white,
                ),
              ),
              subtitle:
                  const Text(
                "Mayor confianza para matches",
                style:
                    TextStyle(
                  color:
                      Colors.white54,
                ),
              ),
              onChanged:
                  (v) {
                setState(() {
                  verified =
                      v;
                });
              },
            ),

            const SizedBox(
                height: 28),

            Container(
              width:
                  double.infinity,
              height: 58,
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
                  18,
                ),
              ),
              child:
                  ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.transparent,
                  shadowColor:
                      Colors.transparent,
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
                height: 30),
          ],
        ),
      ),
    );
  }
}