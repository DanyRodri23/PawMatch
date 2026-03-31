import 'package:flutter/material.dart';

class PetPost {
  final String name;
  final String image;
  final String description;
  int likes;
  bool isLiked;

  PetPost({
    required this.name,
    required this.image,
    required this.description,
    this.likes = 0,
    this.isLiked = false,
  });
}

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {

  List<PetPost> posts = [

    PetPost(
      name: "Rocky 🐶",
      image: "https://images.unsplash.com/photo-1558788353-f76d92427f16",
      description: "Le encanta correr en el parque 🌳",
      likes: 120,
    ),

    PetPost(
      name: "Luna 🐾",
      image: "https://images.unsplash.com/photo-1548199973-03cce0bbc87b",
      description: "Súper cariñosa y juguetona 💕",
      likes: 89,
    ),

    PetPost(
      name: "Max 🐕",
      image: "https://images.unsplash.com/photo-1507149833265-60c372daea22",
      description: "El más travieso 😈",
      likes: 200,
    ),

  ];

  void toggleLike(int index) {

    setState(() {

      posts[index].isLiked = !posts[index].isLiked;

      if (posts[index].isLiked) {
        posts[index].likes++;
      } else {
        posts[index].likes--;
      }

    });
  }

  Widget buildPost(PetPost post, int index) {

    return Container(
      margin: const EdgeInsets.only(bottom: 20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔥 HEADER
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [

                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey,
                ),

                const SizedBox(width: 10),

                Text(
                  post.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ),

          /// 🔥 IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              post.image,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          /// 🔥 ACTIONS
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),

            child: Row(
              children: [

                GestureDetector(
                  onTap: () => toggleLike(index),

                  child: Icon(
                    post.isLiked
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: post.isLiked ? Colors.red : Colors.black,
                  ),
                ),

                const SizedBox(width: 6),

                Text("${post.likes}"),

                const SizedBox(width: 16),

                const Icon(Icons.chat_bubble_outline),

                const SizedBox(width: 6),

                const Text("Comentar"),

              ],
            ),
          ),

          /// 🔥 DESCRIPTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),

            child: Text(
              post.description,
              style: const TextStyle(fontSize: 14),
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Comunidad 🐾",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: posts.length,

        itemBuilder: (context, index) {
          return buildPost(posts[index], index);
        },
      ),
    );
  }
}