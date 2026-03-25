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
    filteredBreeds = allBreeds;
  }

  void filterBreeds(String query) {

    setState(() {
      filteredBreeds = allBreeds
          .where((breed) =>
              breed.toLowerCase().contains(query.toLowerCase()))
          .toList();
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

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),

          child: Column(
            children: [

              const SizedBox(height: 10),

              const Text(
                "¿Qué raza es tu mascota?",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: searchController,
                onChanged: filterBreeds,
                decoration: InputDecoration(
                  hintText: "Buscar raza...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: filteredBreeds.length,
                  itemBuilder: (context, index) {

                    final breed = filteredBreeds[index];
                    final selected = breed == selectedBreed;

                    return GestureDetector(

                      onTap: () {
                        setState(() {
                          selectedBreed = breed;
                        });
                      },

                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.black
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),

                        child: Row(
                          children: [

                            Icon(
                              selected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: selected
                                  ? Colors.white
                                  : Colors.black54,
                            ),

                            const SizedBox(width: 10),

                            Text(
                              breed,
                              style: TextStyle(
                                fontSize: 18,
                                color: selected
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),

                          ],
                        ),
                      ),
                    );

                  },
                ),
              ),

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
                    style: TextStyle(fontSize: 18),
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