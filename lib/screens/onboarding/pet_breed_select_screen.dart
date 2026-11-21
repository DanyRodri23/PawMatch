import 'package:flutter/material.dart';
import 'pet_pedigree_screen.dart';
import '../../widgets/pet_step_scaffold.dart';
import '../../data/pet_profile_data.dart';

class PetBreedSelectScreen extends StatefulWidget {
  const PetBreedSelectScreen({super.key});

  @override
  State<PetBreedSelectScreen> createState() =>
      _PetBreedSelectScreenState();
}

class _PetBreedSelectScreenState
    extends State<PetBreedSelectScreen> {
  final TextEditingController
      searchController =
      TextEditingController();

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

    selectedBreed =
        PetProfileData.pet["breed"];

    filteredBreeds =
        List.from(allBreeds)
          ..sort();

    
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterBreeds(
      String query) {
    setState(() {
      filteredBreeds =
          allBreeds
              .where(
                (breed) => breed
                    .toLowerCase()
                    .contains(
                      query
                          .toLowerCase(),
                    ),
              )
              .toList()
            ..sort();
    });
  }

  void goNext() {
    if (selectedBreed == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Selecciona la raza de tu mascota",
          ),
        ),
      );
      return;
    }

    PetProfileData.updatePet(
      breed: selectedBreed,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const PetPedigreeScreen(),
      ),
    );
  }

  Widget breedItem(String breed) {
    final selected = breed == selectedBreed;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() => selectedBreed = breed);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? Colors.black : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.pets,
              size: 20,
              color: selected ? Colors.white : Colors.black45,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                breed,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : Colors.black,
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PetStepScaffold(
      stepKey: "breed",
      emoji: "🧬",
      title: "¿Cuál es su raza?",
      subtitle: "Búscala o elígela de la lista.",
      scrollable: false,
      onNext: selectedBreed == null ? null : goNext,
      child: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: filterBreeds,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: "Buscar raza",
              filled: true,
              fillColor: Colors.grey.shade100,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: searchController.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        searchController.clear();
                        filterBreeds("");
                      },
                    ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: filteredBreeds.isEmpty
                ? const Center(
                    child: Text(
                      "No encontramos esa raza",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: filteredBreeds.length,
                    itemBuilder: (context, i) => breedItem(filteredBreeds[i]),
                  ),
          ),
        ],
      ),
    );
  }
}
