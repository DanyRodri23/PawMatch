import 'package:flutter/material.dart';
import '../../data/social_data.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {

  /// 🔥 LIKE
  void toggleLike(String postId) {
    setState(() {
      SocialData.toggleLike(postId);
    });
  }

  /// 🔥 FOLLOW
  void toggleFollow(String userId) {
    setState(() {
      final currentUser = SocialData.users
          .firstWhere((u) => u.id == SocialData.currentUserId);

      if (currentUser.following.contains(userId)) {
        currentUser.following.remove(userId);
      } else {
        SocialData.follow(userId);
      }
    });
  }

  /// 🔥 STORIES
  Widget buildStories() {
    return SizedBox(
      height: 95,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: SocialData.users.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (_, i) {

          final user = SocialData.users[i];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              children: [

                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.orange, Colors.red],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  user.name,
                  style: const TextStyle(fontSize: 12),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  /// 🔥 POST REAL
  Widget buildPost(PostModel post) {

    final user = SocialData.users
        .firstWhere((u) => u.id == post.userId);

    final isLiked = post.likes.contains(SocialData.currentUserId);

    final currentUser = SocialData.users
        .firstWhere((u) => u.id == SocialData.currentUserId);

    final isFollowing = currentUser.following.contains(user.id);

    return GestureDetector(
      onDoubleTap: () => toggleLike(post.id),

      child: Container(
        margin: const EdgeInsets.only(bottom: 22),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
            )
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 HEADER INSTAGRAM
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [

                  const CircleAvatar(radius: 20),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  /// 🔥 FOLLOW BUTTON
                  GestureDetector(
                    onTap: () => toggleFollow(user.id),

                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),

                      decoration: BoxDecoration(
                        color: isFollowing
                            ? Colors.grey.shade300
                            : Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Text(
                        isFollowing ? "Siguiendo" : "Seguir",
                        style: TextStyle(
                          color: isFollowing
                              ? Colors.black
                              : Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  const Icon(Icons.more_vert)
                ],
              ),
            ),

            /// 🔥 IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Stack(
                children: [

                  Image.network(
                    post.image,
                    height: 280,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.black45,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// 🔥 ACTIONS
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),

              child: Row(
                children: [

                  GestureDetector(
                    onTap: () => toggleLike(post.id),

                    child: AnimatedScale(
                      scale: isLiked ? 1.3 : 1,
                      duration: const Duration(milliseconds: 200),

                      child: Icon(
                        isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: isLiked
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  const Icon(Icons.chat_bubble_outline),

                  const SizedBox(width: 10),

                  const Icon(Icons.send),

                  const Spacer(),

                  const Icon(Icons.bookmark_border),
                ],
              ),
            ),

            /// 🔥 LIKES
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                "${post.likes.length} likes",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 6),

            /// 🔥 DESCRIPTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: "${user.name} ",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: post.description),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final posts = SocialData.posts;

    return Scaffold(

      backgroundColor: const Color(0xFFF7F7F7),

      body: SafeArea(
        child: Column(
          children: [

            /// 🔥 HEADER PRO
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Row(
                children: [

                  const Text(
                    "Comunidad",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  const Icon(Icons.search),
                  const SizedBox(width: 12),
                  const Icon(Icons.notifications_none),
                ],
              ),
            ),

            /// STORIES
            buildStories(),

            const Divider(height: 1),

            /// FEED REAL
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return buildPost(posts[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}