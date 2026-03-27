import 'package:flutter/material.dart';
import 'pet_pedigree_screen.dart';

class PetBreedSelectScreen extends StatefulWidget {
  const PetBreedSelectScreen({super.key});

  @override
  State<PetBreedSelectScreen> createState() => _PetBreedSelectScreenState();
}

class _PetBreedSelectScreenState extends State<PetBreedSelectScreen> {

  final TextEditingController searchController = TextEditingController();

  String? selectedBreed;

  final List<String> allBreeds = [
    "Akita",
    "Akita Americano",
    "Affenpinscher",
    "Afgano",
    "Airedale Terrier",
    "Akbash",
    "Alaskan Malamute",
    "American Bully",
    "American Staffordshire Terrier",
    "American Foxhound",
    "Basenji",
    "Basset Hound",
    "Beagle",
    "Bearded Collie",
    "Bedlington Terrier",
    "Berger Picard",
    "Bernés de la Montaña",
    "Bichón Frisé",
    "Bichón Habanero",
    "Bichón Maltés",
    "Biewer Terrier",
    "Bloodhound",
    "Bobtail",
    "Boerboel",
    "Border Collie",
    "Border Terrier",
    "Borzoi",
    "Boston Terrier",
    "Bóxer",
    "Boyero de Berna",
    "Boyero de Flandes",
    "Boyero de Appenzell",
    "Braco Alemán",
    "Braco Italiano",
    "Braco de Weimar",
    "Bull Terrier",
    "Bullmastiff",
    "Bulldog Americano",
    "Bulldog Francés",
    "Bulldog Inglés",
    "Cairn Terrier",
    "Cane Corso",
    "Cavalier King Charles Spaniel",
    "Chihuahua",
    "Chin Japonés",
    "Chow Chow",
    "Cocker Spaniel Americano",
    "Cocker Spaniel Inglés",
    "Collie",
    "Collie Barbudo",
    "Corgi Galés de Cardigan",
    "Corgi Galés de Pembroke",
    "Dachshund (Perro Salchicha)",
    "Dálmata",
    "Dandie Dinmont Terrier",
    "Doberman",
    "Dogo Argentino",
    "Dogo Alemán",
    "Dogo de Burdeos",
    "Drever",
    "Elkhound Noruego",
    "English Toy Terrier",
    "Epagneul Bretón",
    "Esquimal Americano",
    "Fox Terrier",
    "Foxhound Inglés",
    "Foxhound Americano",
    "Galgo Español",
    "Galgo Inglés (Greyhound)",
    "Galgo Italiano",
    "Golden Retriever",
    "Gran Danés",
    "Gran Pirineo",
    "Husky Siberiano",
    "Jack Russell Terrier",
    "Keeshond",
    "Komondor",
    "Kuvasz",
    "Labrador Retriever",
    "Leonberger",
    "Lhasa Apso",
    "Malamute de Alaska",
    "Maltipoo",
    "Mastín Español",
    "Mastín Inglés",
    "Mini Pinscher",
    "Pastor Alemán",
    "Pastor Australiano",
    "Pastor Belga",
    "Pastor Belga Malinois",
    "Pastor Suizo Blanco",
    "Pekinés",
    "Perro de Agua Español",
    "Pitbull Terrier Americano",
    "Pomerania",
    "Poodle (Caniche)",
    "Poodle Miniatura",
    "Poodle Toy",
    "Pug (Carlino)",
    "Rottweiler",
    "Samoyedo",
    "San Bernardo",
    "Schnauzer",
    "Schnauzer Miniatura",
    "Setter Inglés",
    "Shar Pei",
    "Shetland Sheepdog",
    "Shiba Inu",
    "Shih Tzu",
    "Staffordshire Bull Terrier",
    "Terranova",
    "Vizsla",
    "Weimaraner",
    "West Highland White Terrier",
    "Whippet",
    "Yorkshire Terrier",
  ];

  List<String> filteredBreeds = [];

  @override
  void initState() {
    super.initState();
    filteredBreeds = List.from(allBreeds)..sort();
  }

  void filterBreeds(String query) {
    setState(() {
      filteredBreeds = allBreeds
          .where((breed) =>
              breed.toLowerCase().contains(query.toLowerCase()))
          .toList()
        ..sort();
    });
  }

  void goNext() {
    if (selectedBreed == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecciona la raza de tu mascota"),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PetPedigreeScreen(),
      ),
    );
  }

  void goBack() {
    Navigator.pop(context);
  }

  Widget breedItem(String breed) {
    final selected = breed == selectedBreed;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBreed = breed;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.black : Colors.grey.shade300,
          ),
          boxShadow: selected
              ? [
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.check_circle
                  : Icons.radio_button_off,
              color: selected ? Colors.white : Colors.black54,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                breed,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: selected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customInputOption() {
    if (searchController.text.isEmpty) return const SizedBox();

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBreed = searchController.text;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const Icon(Icons.edit, color: Colors.blue),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Usar: "${searchController.text}"',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Text(
              "Seleccionar",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: goBack,
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "¿Qué raza es tu mascota?",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Esto nos ayuda a encontrar mejores coincidencias.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 25),

              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: filterBreeds,
                  decoration: const InputDecoration(
                    hintText: "Buscar raza...",
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              customInputOption(),

              const Text(
                "🐾 Todas las razas",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  itemCount: filteredBreeds.length,
                  itemBuilder: (context, index) {
                    return breedItem(filteredBreeds[index]);
                  },
                ),
              ),

              /// 🔥 BOTÓN ULTRA PRO (SIN MORADO)
              SizedBox(
                width: double.infinity,
                height: 65,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: selectedBreed != null
                        ? const LinearGradient(
                            colors: [
                              Color(0xFF000000),
                              Color(0xFF1C1C1E),
                            ],
                          )
                        : null,
                    color: selectedBreed == null
                        ? Colors.grey.shade200
                        : null,
                    boxShadow: selectedBreed != null
                        ? [
                            const BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15,
                              offset: Offset(0, 6),
                            ),
                          ]
                        : [],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      disabledForegroundColor: Colors.white54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: selectedBreed != null ? goNext : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const Text(
                          "Continuar",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(width: 10),

                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: selectedBreed != null
                              ? const Icon(
                                  Icons.arrow_forward_rounded,
                                  key: ValueKey(1),
                                  color: Colors.white,
                                )
                              : const SizedBox.shrink(key: ValueKey(2)),
                        ),

                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}