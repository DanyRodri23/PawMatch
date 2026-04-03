import 'package:flutter/material.dart';
import '../../data/social_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    fadeAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),

      body: SafeArea(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 20),
            children: [

              /// 🔥 HEADER
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: const [
                    Icon(Icons.pets, color: Color(0xffFF9F1C), size: 28),
                    SizedBox(width: 8),
                    Text(
                      "PawMatch",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.notifications_none),
                  ],
                ),
              ),

              /// 🔥 STORIES PRO
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: SocialData.users.length,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemBuilder: (_, i) {

                    final user = SocialData.users[i];

                    return TweenAnimationBuilder(
                      duration: Duration(milliseconds: 400 + (i * 100)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (_, double value, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Column(
                          children: [

                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.orange, Colors.red],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.pets),
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              user.name,
                              style: const TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// 🔥 MINI MATCH PRO
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  "🔥 Cerca de ti",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 230,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [

                    buildMatchCard(
                      "https://images.unsplash.com/photo-1558788353-f76d92427f16",
                      "Max",
                    ),

                    buildMatchCard(
                      "https://images.unsplash.com/photo-1548199973-03cce0bbc87b",
                      "Luna",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// 🔥 FEED
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  "Comunidad",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              ...SocialData.posts.map((post) => buildPost(post)),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 MATCH CARD PRO
  Widget buildMatchCard(String image, String name) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          children: [

            Positioned.fill(
              child: Image.network(image, fit: BoxFit.cover),
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

            Positioned(
              bottom: 12,
              left: 12,
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 POST PRO
  Widget buildPost(PostModel post) {

    final user = SocialData.users
        .firstWhere((u) => u.id == post.userId);

    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (_, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// USER
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [

                  const CircleAvatar(child: Icon(Icons.pets)),
                  const SizedBox(width: 10),

                  Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            /// IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                post.image,
                height: 230,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            /// DESCRIPTION
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                post.description,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}