import 'package:flutter/material.dart';


import 'match/match_page.dart';
import 'discover/discover_page.dart';
import 'profile/profile_page.dart';
import 'chats/chats_page.dart';
import 'community/community_screen.dart';
import 'likes/likes_page.dart';
import 'home/home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  int currentIndex = 2;

  final GlobalKey<MatchPageState> matchKey = GlobalKey<MatchPageState>();

  late final List<Widget> pages = [
    const HomeScreen(),
    const DiscoverPage(),
    MatchPage(key: matchKey),
    const LikesPage(),
    const ChatsPage(),
    const CommunityScreen(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,

      body: Stack(
        children: [

          /// 🔥 CONTENIDO
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: pages[currentIndex],
          ),

          /// 🔥 HEADER BLANCO PREMIUM (NO TRANSPARENTE)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    /// FILTRO
                    _circleButton(Icons.tune, () {
                      if (currentIndex == 2) {
                        matchKey.currentState?.openFilters();
                      }
                    }),

                    /// TABS
                    Row(
                      children: [
                        _tab("Para ti", 2),
                        _tab("Noticias", 0),
                        _tab("Comunidad", 5),
                      ],
                    ),

                    _circleButton(Icons.settings, () {
                      setState(() => currentIndex = 6);
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      /// 🔥 NAVBAR BLANCO PREMIUM
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(14),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            _navItem(Icons.search, 1),
            _mainButton(),
            _navItem(Icons.favorite, 3),
            _navItem(Icons.chat_bubble_outline, 4),
            _navItem(Icons.public, 5),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      child: Icon(
        icon,
        size: 26,
        color: isSelected ? Colors.deepPurple : Colors.grey,
      ),
    );
  }

  Widget _mainButton() {
    return GestureDetector(
      onTap: () => setState(() => currentIndex = 2),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.pinkAccent],
          ),
        ),
        child: const Icon(Icons.pets, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(icon),
      ),
    );
  }

  Widget _tab(String text, int index) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }
}