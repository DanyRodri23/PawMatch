import 'package:flutter/material.dart';
import 'match/match_page.dart';
import 'discover/discover_page.dart';
import 'profile/profile_page.dart';
import '../data/app_data.dart';
import 'chats/chats_page.dart';
import 'home/home_screen.dart'; // ✅ CORRECTO
import 'community/community_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  int currentIndex = 0; // 🔥 EMPIEZA EN HOME

  final GlobalKey<MatchPageState> matchKey = GlobalKey<MatchPageState>();

  late final List<Widget> pages = [
    const HomeScreen(), // 🔥 HOME PRO
    const DiscoverPage(),
    MatchPage(key: matchKey),
    const LikesPage(),
    const ChatsPage(),
    const CommunityScreen(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {

    final hasChats = AppData.chats.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),

      /// 🔥 APPBAR DINÁMICA
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
                fontSize: 22,
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
                state?.openFilters();
              },
            ),
          const SizedBox(width: 10)
        ],
      ),

      /// 🔥 BODY
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[currentIndex],
      ),

      /// 🔥 NAVBAR PRO
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
              icon: Icon(Icons.home),
              label: "Inicio",
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
              label: "Likes",
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

            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Perfil",
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔥 LIKES PAGE SIMPLE (SIN ERROR)
class LikesPage extends StatelessWidget {
  const LikesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Likes",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}