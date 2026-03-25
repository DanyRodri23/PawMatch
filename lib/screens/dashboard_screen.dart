import 'package:flutter/material.dart';
import 'match/match_page.dart';
import 'discover/discover_page.dart';
import 'profile/profile_page.dart';
import '../data/app_data.dart';
import 'chats/chats_page.dart'; // 🔥 IMPORTANTE

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  int currentIndex = 2;

  final GlobalKey<MatchPageState> matchKey = GlobalKey<MatchPageState>();

  late final List<Widget> pages = [
    ProfilePage(),
    const DiscoverPage(),
    MatchPage(key: matchKey),
    const LikesPage(),
    const ChatsPage(),
    const CommunityPage(),
  ];

  @override
  Widget build(BuildContext context) {

    final hasChats = AppData.chats.isNotEmpty;

    return Scaffold(

      backgroundColor: const Color(0xffF7F7F7),

      /// APPBAR
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,

        title: Row(
          children: const [
            Icon(Icons.pets, color: Color(0xffFF9F1C), size: 26),
            SizedBox(width: 8),
            Text(
              "PawMatch",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          ],
        ),

        actions: [

          if(currentIndex == 2)
            IconButton(
              icon: const Icon(Icons.tune, color: Colors.black),
              onPressed: () {
                final state = matchKey.currentState;
                if(state != null){
                  state.openFilters();
                }
              },
            ),

          const SizedBox(width: 10)
        ],
      ),

      /// BODY
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Container(
          key: ValueKey(currentIndex),
          child: pages[currentIndex],
        ),
      ),

      /// NAVBAR
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10)
          ],
        ),

        child: BottomNavigationBar(

          currentIndex: currentIndex,

          onTap: (index){
            if(index == currentIndex) return;
            setState(() => currentIndex = index);
          },

          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,

          selectedItemColor: const Color(0xffFF9F1C),
          unselectedItemColor: Colors.grey,

          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold),

          items: [

            const BottomNavigationBarItem(
              icon: Icon(Icons.pets),
              label: "Perfil",
            ),

            const BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: "Descubre",
            ),

            const BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: "Match",
            ),

            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Me gustas",
            ),

            /// 🔥 CHAT CON BADGE
            BottomNavigationBarItem(
              icon: Stack(
                children: [

                  const Icon(Icons.chat),

                  if (hasChats)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )

                ],
              ),
              label: "Chats",
            ),

            const BottomNavigationBarItem(
              icon: Icon(Icons.public),
              label: "Comunidad",
            ),

          ],
        ),
      ),
    );
  }
}

/// --------------------------------------------
/// 🔥 LIKES PAGE (NO TOCADA)
/// --------------------------------------------

class LikesPage extends StatelessWidget {
  const LikesPage({super.key});

  @override
  Widget build(BuildContext context) {

    final likes = AppData.likedPets;

    return Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 10),

          const Text(
            "Te dieron like 💛",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          if (likes.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  "Aún no tienes likes",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          else
            Expanded(
              child: GridView.builder(
                itemCount: likes.length,

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),

                itemBuilder: (context, index) {

                  final pet = likes[index];

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),

                      child: Stack(
                        children: [

                          Positioned.fill(
                            child: Image.network(
                              pet["images"][0],
                              fit: BoxFit.cover,
                            ),
                          ),

                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.center,
                                  colors: [
                                    Colors.black54,
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const Positioned(
                            top: 10,
                            right: 10,
                            child: Icon(Icons.favorite, color: Colors.red),
                          ),

                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                Text(
                                  "${pet["name"]}, ${pet["age"]}${pet["ageType"]}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text(
                                  pet["breed"],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),

                                Text(
                                  pet["distance"],
                                  style: const TextStyle(
                                    color: Colors.white54,
                                  ),
                                ),

                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

        ],
      ),
    );
  }
}

/// --------------------------------------------
/// COMMUNITY
/// --------------------------------------------

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Comunidad PawMatch",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}