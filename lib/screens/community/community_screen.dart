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

  /// PERFIL REAL
  void openProfile(UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(user.name)),
          body: Center(
            child: Text(
              "Perfil de ${user.name}",
              style: const TextStyle(fontSize: 22),
            ),
          ),
        ),
      ),
    );
  }

  /// STORIES
  Widget buildStories() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: SocialData.users.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (_, i) {

          final user = SocialData.users[i];

          return GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                children: [

                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.pink, Colors.orange],
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.pets, color: Colors.black),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    user.name,
                    style: const TextStyle(fontSize: 11),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// POST PRO
  Widget buildPost(PostModel post) {

    final user = SocialData.users
        .firstWhere((u) => u.id == post.userId);

    final isLiked = post.likes.contains(SocialData.currentUserId);

    final isSaved = savedPosts[post.id] ?? false;

    final currentUser = SocialData.users
        .firstWhere((u) => u.id == SocialData.currentUserId);

    final isFollowing = currentUser.following.contains(user.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFEAEAEA)),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [

                GestureDetector(
                  onTap: () => openProfile(user),
                  child: const CircleAvatar(
                    radius: 18,
                    child: Icon(Icons.pets, size: 18),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: GestureDetector(
                    onTap: () => openProfile(user),
                    child: Text(
                      user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () => toggleFollow(user.id),
                  child: Text(
                    isFollowing ? "Siguiendo" : "Seguir",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),

                const Icon(Icons.more_horiz),
              ],
            ),
          ),

          /// IMAGE
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

                Image.network(
                  post.image,
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                if (showPaw[post.id] == true)
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOut,
                    builder: (_, value, __) {
                      return Opacity(
                        opacity: 1 - value,
                        child: Transform.scale(
                          scale: 0.7 + value,
                          child: const Icon(
                            Icons.pets,
                            color: Colors.red,
                            size: 90,
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),

          /// ACTIONS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [

                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: isLiked ? Colors.red : Colors.black,
                  ),
                  onPressed: () => toggleLike(post.id),
                ),

                IconButton(
                  icon: const Icon(Icons.mode_comment_outlined),
                  onPressed: () {},
                ),

                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                ),

                const Spacer(),

                IconButton(
                  icon: Icon(
                    isSaved
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                  ),
                  onPressed: () => toggleSave(post.id),
                ),
              ],
            ),
          ),

          /// LIKES
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              "${post.likes.length} likes",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          const SizedBox(height: 4),

          /// DESCRIPTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: "${user.name} ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: post.description),
                ],
              ),
            ),
          ),

          const SizedBox(height: 4),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              "Hace 2 minutos",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final posts = SocialData.posts;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: ListView(
          children: [

            /// HEADER
            const Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                "PawMatch",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            buildStories(),

            const SizedBox(height: 10),

            ...posts.map((post) => buildPost(post)),
          ],
        ),
      ),
    );
  }
}