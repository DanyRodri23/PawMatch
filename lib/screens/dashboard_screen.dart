import 'package:flutter/material.dart';
import 'match/match_page.dart';
import 'discover/discover_page.dart';
import 'profile/profile_page.dart';
import '../data/app_data.dart';
import 'chats/chats_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {

  int currentIndex = 0;

  final GlobalKey<MatchPageState> matchKey = GlobalKey<MatchPageState>();

  late final List<Widget> pages = [
    MatchPage(key: matchKey),
    const DiscoverPage(),
    const LikesPage(),
    const ChatsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasChats = AppData.chats.isNotEmpty;

    return Scaffold(
      extendBody: true,

      /// 🔥 ADAPTADO A MODO CLARO / OSCURO
      backgroundColor: isDark ? Colors.black : Colors.grey[100],

      /// 🔥 TRANSICIÓN MÁS SUAVE
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: Container(
          key: ValueKey(currentIndex),
          child: pages[currentIndex],
        ),
      ),

      /// 🔥 NAVBAR MÁS CLEAN (TIPO APP MODERNA)
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),

        child: Container(
          height: 65,

          decoration: BoxDecoration(
            color: isDark
                ? Colors.grey[900]!.withOpacity(0.9)
                : Colors.white.withOpacity(0.95),

            borderRadius: BorderRadius.circular(30),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
                blurRadius: 20,
              )
            ],
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              navItem(Icons.local_fire_department, 0, "Swipe", isDark),
              navItem(Icons.explore, 1, "Explorar", isDark),
              navItem(Icons.favorite, 2, "Likes", isDark),

              /// 🔥 CHAT CON NOTIFICACIÓN
              Stack(
                children: [
                  navItem(Icons.chat_bubble_outline, 3, "Chat", isDark),

                  if (hasChats)
                    Positioned(
                      right: 6,
                      top: 6,
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

              navItem(Icons.person_outline, 4, "Perfil", isDark),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 ITEM NAVBAR MEJORADO
  Widget navItem(IconData icon, int index, String label, bool isDark) {

    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        if (index == currentIndex) return;
        setState(() => currentIndex = index);
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05))
              : Colors.transparent,

          borderRadius: BorderRadius.circular(16),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              icon,
              color: isSelected
                  ? (isDark ? Colors.white : Colors.black)
                  : Colors.grey,
              size: 22,
            ),

            const SizedBox(height: 3),

            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? (isDark ? Colors.white : Colors.black)
                    : Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}