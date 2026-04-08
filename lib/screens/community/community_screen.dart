import 'dart:ui';
import 'package:flutter/material.dart';
import '../../data/social_data.dart';
import 'package:flutter/services.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {

  Map<String, bool> showPaw = {};
  Map<String, bool> savedPosts = {};

  void toggleLike(String postId) {
    setState(() {
      SocialData.toggleLike(postId);
    });
  }

  void toggleFollow(String userId) {
    setState(() {
      SocialData.toggleFollow(userId);
    });
  }

  void toggleSave(String postId) {
    setState(() {
      savedPosts[postId] = !(savedPosts[postId] ?? false);
    });
  }

  /// 🔥 STORIES
  Widget buildStories() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: SocialData.users.length,
        itemBuilder: (_, i) {

          final user = SocialData.users[i];

          return Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Column(
              children: [

                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.pets, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  user.name,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  /// 🔥 POST NIVEL DIOS
  Widget buildPost(PostModel post) {

    final user = SocialData.users.firstWhere((u) => u.id == post.userId);
    final isLiked = post.likes.contains(SocialData.currentUserId);
    final isSaved = savedPosts[post.id] ?? false;

    final currentUser = SocialData.users
        .firstWhere((u) => u.id == SocialData.currentUserId);

    final isFollowing = currentUser.following.contains(user.id);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,

      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),

          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [

                      const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.pets, color: Colors.white),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          user.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () => toggleFollow(user.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: isFollowing ? Colors.grey[800] : Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isFollowing ? "Siguiendo" : "Seguir",
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),
                      const Icon(Icons.more_vert, color: Colors.white)
                    ],
                  ),
                ),

                /// IMAGEN + EFECTOS
                GestureDetector(
                  onDoubleTap: () {
                    HapticFeedback.lightImpact();
                    toggleLike(post.id);

                    setState(() => showPaw[post.id] = true);

                    Future.delayed(const Duration(milliseconds: 800), () {
                      if (mounted) {
                        setState(() => showPaw[post.id] = false);
                      }
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          post.image,
                          height: 320,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      /// 🐾 HUELLA GLOW
                      if (showPaw[post.id] == true)
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 800),
                          builder: (_, value, __) {
                            return Opacity(
                              opacity: 1 - value,
                              child: Transform.scale(
                                scale: 0.7 + value,
                                child: const Icon(
                                  Icons.pets,
                                  color: Colors.red,
                                  size: 110,
                                  shadows: [
                                    Shadow(
                                      color: Colors.red,
                                      blurRadius: 40,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                      /// 🔥 BOTONES FLOTANTES
                      Positioned(
                        bottom: 15,
                        left: 15,
                        right: 15,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [

                              IconButton(
                                icon: Icon(
                                  Icons.pets,
                                  color: isLiked ? Colors.red : Colors.white,
                                ),
                                onPressed: () => toggleLike(post.id),
                              ),

                              IconButton(
                                icon: const Icon(Icons.mode_comment_outlined, color: Colors.white),
                                onPressed: () {},
                              ),

                              IconButton(
                                icon: const Icon(Icons.send, color: Colors.white),
                                onPressed: () {},
                              ),

                              const Spacer(),

                              IconButton(
                                icon: Icon(
                                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                                  color: Colors.white,
                                ),
                                onPressed: () => toggleSave(post.id),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// TEXTO
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "${post.likes.length} likes",
                        style: const TextStyle(color: Colors.white),
                      ),

                      const SizedBox(height: 4),

                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                              text: "${user.name} ",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: post.description),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final posts = SocialData.posts;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),

      body: SafeArea(
        child: Column(
          children: [

            /// HEADER PRO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Text(
                    "PawMatch",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_none, color: Colors.white),
                  )
                ],
              ),
            ),

            buildStories(),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (_, i) => buildPost(posts[i]),
              ),
            )
          ],
        ),
      ),
    );
  }
}