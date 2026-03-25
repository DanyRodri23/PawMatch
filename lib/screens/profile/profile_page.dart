import 'package:flutter/material.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {

    final bool hasPedigree = true;
    final double profileProgress = 0.75;

    return Scaffold(

      backgroundColor: const Color(0xffF7F7F7),

      body: SingleChildScrollView(

        child: Column(

          children: [

            /// HEADER
            Container(

              padding: const EdgeInsets.only(top: 50, bottom: 20),

              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10)
                ],
              ),

              child: Column(

                children: [

                  /// TOP BAR
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [

                        const Text(
                          "Perfil de tu mascota",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {},
                        )

                      ],

                    ),
                  ),

                  const SizedBox(height: 10),

                  /// FOTO
                  Stack(
                    children: [

                      const CircleAvatar(
                        radius: 55,
                        backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1507146426996-ef05306b995a",
                        ),
                      ),

                      if(hasPedigree)
                        const Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.check, color: Colors.white, size: 18),
                          ),
                        ),

                    ],
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Max, 2",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Golden Retriever",
                    style: TextStyle(color: Colors.black54),
                  ),

                  const SizedBox(height: 20),

                  /// PROGRESO
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(

                      children: [

                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Perfil completado"),
                            Text("75%"),
                          ],
                        ),

                        const SizedBox(height: 8),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: profileProgress,
                            minHeight: 8,
                            backgroundColor: Colors.grey,
                            color: const Color(0xffFF9F1C),
                          ),
                        ),

                      ],

                    ),
                  ),

                ],

              ),

            ),

            const SizedBox(height: 20),

            /// FOTOS
            sectionTitle("Fotos"),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [

                  photoItem("https://images.unsplash.com/photo-1507146426996-ef05306b995a"),
                  photoItem("https://images.unsplash.com/photo-1517423440428-a5a00ad493e8"),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 20),

            /// INFO
            sectionTitle("Información"),

            infoItem("Sexo", "Macho"),
            infoItem("Edad", "2 años"),
            infoItem("Personalidad", "Juguetón"),
            infoItem("Busca", "Compañero de juego"),

            const SizedBox(height: 20),

            /// BOTON EDITAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFF9F1C),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );

                },

                child: const Text("Editar perfil"),

              ),
            ),

            const SizedBox(height: 30),

          ],

        ),

      ),

    );

  }

  Widget sectionTitle(String title){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget infoItem(String title, String value){
    return ListTile(
      title: Text(title),
      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget photoItem(String url){
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(url, fit: BoxFit.cover),
    );
  }
}