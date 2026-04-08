import 'package:flutter/material.dart';
import 'dart:ui';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final news = [
      {
        "title": "🐾 15% OFF en Veterinaria",
        "subtitle": "Solo por esta semana en Heredia",
        "image": "https://images.unsplash.com/photo-1583511655826-05700d52f4d9",
        "tag": "Promo"
      },
      {
        "title": "🐶 Jornada de Adopción",
        "subtitle": "Domingo 10AM - Parque Central",
        "image": "https://images.unsplash.com/photo-1601758228041-f3b2795255f1",
        "tag": "Evento"
      },
      {
        "title": "🐕 Nuevo parque canino",
        "subtitle": "Zona exclusiva para mascotas",
        "image": "https://images.unsplash.com/photo-1598133894008-61f7fdb8cc3a",
        "tag": "Noticias"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Column(
          children: [

            /// 🔥 HEADER PREMIUM
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Text(
                    "Noticias 📰",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.notifications_none, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            /// 🔥 LISTA PRO
            Expanded(
              child: ListView.builder(
                itemCount: news.length,
                padding: const EdgeInsets.only(bottom: 20),
                itemBuilder: (_, i) {

                  final item = news[i];

                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.15),
                            blurRadius: 25,
                            spreadRadius: 1,
                          )
                        ],
                      ),

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(26),
                        child: Stack(
                          children: [

                            /// 🔥 IMAGE
                            Image.network(
                              item["image"]!,
                              height: 230,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),

                            /// 🔥 DARK GRADIENT
                            Container(
                              height: 230,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withValues(alpha: 0.1),
                                    Colors.black.withValues(alpha: 0.9),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),

                            /// 🔥 TAG
                            Positioned(
                              top: 14,
                              left: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Colors.blue, Colors.purple],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  item["tag"]!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),

                            /// 🔥 CONTENIDO ABAJO
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      item["title"]!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      item["subtitle"]!,
                                      style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize: 13,
                                      ),
                                    ),

                                    const SizedBox(height: 14),

                                    Row(
                                      children: [

                                        /// 🔥 BOTÓN PRO
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [Colors.blue, Colors.purple],
                                              ),
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius: BorderRadius.circular(14),
                                                onTap: () {},
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 12),
                                                  child: Center(
                                                    child: Text(
                                                      "Ver más",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 10),

                                        /// 🔥 SHARE GLASS
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(14),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(alpha: 0.08),
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                              child: IconButton(
                                                icon: const Icon(Icons.share, color: Colors.white),
                                                onPressed: () {},
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}