import 'package:flutter/material.dart';
import 'match/match_page.dart';
import 'discover/discover_page.dart';
import 'profile/profile_page.dart';
import '../data/app_data.dart';
import 'chats/chats_page.dart';
import 'community/community_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  int currentIndex = 2;

  final GlobalKey<MatchPageState> matchKey = GlobalKey<MatchPageState>();

  late final List<Widget> pages = [
    const ProfilePage(),
    const DiscoverPage(),
    MatchPage(key: matchKey),
    LikesPage(), // 🔥 SIN CONST (ARREGLADO)
    const ChatsPage(),
    const CommunityScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    final hasChats = AppData.chats.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black,

      /// 🔥 APPBAR MINIMAL PRO
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.black,

        title: Row(
          children: const [
            Icon(Icons.pets, color: Color(0xffFF9F1C), size: 26),
            SizedBox(width: 8),
            Text(
              "PawMatch",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ],
        ),

        actions: [
          if(currentIndex == 2)
            IconButton(
              icon: const Icon(Icons.tune, color: Colors.white),
              onPressed: () {
                final state = matchKey.currentState;
                if(state != null){
                  state.openFilters(); // 🔥 ya no da error
                }
              },
            ),
          const SizedBox(width: 10)
        ],
      ),

      /// 🔥 BODY
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: pages[currentIndex],
      ),

      /// 🔥 NAVBAR TIPO TINDER PRO
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 20)
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index){
              if(index == currentIndex) return;
              setState(() => currentIndex = index);
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white38,
            showSelectedLabels: false,
            showUnselectedLabels: false,

            items: [

              const BottomNavigationBarItem(
                icon: Icon(Icons.pets),
                label: "",
              ),

              const BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: "",
              ),

              const BottomNavigationBarItem(
                icon: Icon(Icons.local_fire_department, size: 30),
                label: "",
              ),

              const BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "",
              ),

              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.chat),
                    if (hasChats)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                  ],
                ),
                label: "",
              ),

              const BottomNavigationBarItem(
                icon: Icon(Icons.public),
                label: "",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 🔥 LIKES PAGE PRO
class LikesPage extends StatelessWidget {
  const LikesPage({super.key});

  @override
  Widget build(BuildContext context) {

    final likes = AppData.likedPets;

    if (likes.isEmpty) {
      return const Center(
        child: Text(
          "No tienes likes aún 💔",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: likes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {

        final pet = likes[index];

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Colors.black54, blurRadius: 10)
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
                          Colors.black87,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Text(
                    pet["name"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Positioned(
                  top: 10,
                  right: 10,
                  child: Icon(Icons.favorite, color: Colors.red),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}