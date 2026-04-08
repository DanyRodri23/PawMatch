import 'package:flutter/material.dart';
import 'dart:ui';

import 'match/match_page.dart';
import 'discover/discover_page.dart';
import 'profile/profile_page.dart';
import 'chats/chats_page.dart';
import 'community/community_screen.dart';
import 'likes/likes_page.dart';
import 'package:pawmatch/screens/news/news_screen.dart';

// 🔥 CAMBIO AQUÍ (IMPORTS)
import 'package:pawmatch/screens/parks/parks_entry_screen.dart';
import 'package:pawmatch/screens/hotels/hotels_entry_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  int currentIndex = 2;

  final GlobalKey<MatchPageState> matchKey = GlobalKey<MatchPageState>();

  late final List<Widget> pages = [
    NewsScreen(), // 0
    const DiscoverPage(), // 1
    MatchPage(key: matchKey), // 2
    const LikesPage(), // 3
    const ChatsPage(), // 4
    const CommunityScreen(), // 5
    const ProfilePage(), // 6
    const ParksEntryScreen(), // 🔥 CAMBIO
    const HotelsEntryScreen(), // 🔥 CAMBIO
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,

      body: Stack(
        children: [

          /// 🔥 CONTENIDO
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: KeyedSubtree(
              key: ValueKey(currentIndex),
              child: pages[currentIndex],
            ),
          ),

          /// 🔥 HEADER SOLO EN MATCH
          if (currentIndex == 2)
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          children: [

                            IconButton(
                              icon: const Icon(Icons.tune, color: Colors.white),
                              onPressed: () {
                                if (currentIndex == 2) {
                                  matchKey.currentState?.openFilters();
                                }
                              },
                            ),

                            /// 🔥 TABS SCROLL (IGUAL, NO CAMBIADO)
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    _tab("Para ti", 2),
                                    _tab("Noticias", 0),
                                    _tab("Comunidad", 5),
                                    _tab("Parques", 7),
                                    _tab("Hoteles", 8),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),

      /// 🔥 NAVBAR (SIN CAMBIOS)
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  _navItem(Icons.pets, 2),
                  _navItem(Icons.search, 1),
                  _navItem(Icons.favorite, 3),
                  _navItem(Icons.chat_bubble_outline, 4),
                  _navItem(Icons.person, 6),

                ],
              ),
            ),
          ),
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
        color: isSelected ? Colors.pinkAccent : Colors.white54,
      ),
    );
  }

  Widget _tab(String text, int index) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.white54,
          ),
        ),
      ),
    );
  }
}