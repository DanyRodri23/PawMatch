import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

import '../../data/chats_data.dart';
import '../chats/chat_detail_page.dart';

class MatchSuccessScreen extends StatefulWidget {
  final String myPet;
  final String otherPet;
  final String image1;
  final String image2;

  const MatchSuccessScreen({
    super.key,
    required this.myPet,
    required this.otherPet,
    required this.image1,
    required this.image2,
  });

  @override
  State<MatchSuccessScreen> createState() =>
      _MatchSuccessScreenState();
}

class _MatchSuccessScreenState
    extends State<MatchSuccessScreen>
    with TickerProviderStateMixin {

  late ConfettiController leftConfetti;
  late ConfettiController rightConfetti;

  late AnimationController zoomController;
  late Animation<double> zoomAnimation;

  @override
  void initState() {
    super.initState();

    leftConfetti = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    rightConfetti = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    zoomAnimation = CurvedAnimation(
      parent: zoomController,
      curve: Curves.easeOutBack,
    );

    Future.delayed(
      const Duration(milliseconds: 250),
      () {
        zoomController.forward();
        leftConfetti.play();
        rightConfetti.play();
      },
    );
  }

  @override
  void dispose() {
    leftConfetti.dispose();
    rightConfetti.dispose();
    zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),

      body: Stack(
        children: [

          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1A1A1A),
                    Color(0xFF050505),
                  ],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: ConfettiWidget(
              confettiController: leftConfetti,
              blastDirection: 0.5,
              gravity: 0.25,
              emissionFrequency: 0.05,
              numberOfParticles: 18,
            ),
          ),

          Align(
            alignment: Alignment.topRight,
            child: ConfettiWidget(
              confettiController: rightConfetti,
              blastDirection: 2.6,
              gravity: 0.25,
              emissionFrequency: 0.05,
              numberOfParticles: 18,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [

                  const Spacer(),

                  const Text(
                    "¡Es un Match!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "${widget.otherPet} también le dio like a ${widget.myPet}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 45),

                  ScaleTransition(
                    scale: zoomAnimation,
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [

                        _petAvatar(widget.image1),

                        Container(
                          margin:
                              const EdgeInsets.symmetric(
                            horizontal: 14,
                          ),
                          padding:
                              const EdgeInsets.all(14),
                          decoration:
                              BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pinkAccent
                                .withValues(
                              alpha: 0.15,
                            ),
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.pinkAccent,
                            size: 32,
                          ),
                        ),

                        _petAvatar(widget.image2),
                      ],
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.pinkAccent,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),
                      ),
                      onPressed: () {
                        ChatsData.createChat({
                          "id": widget.otherPet,
                          "name": widget.otherPet,
                          "images": [widget.image2],
                          "pedigree": true,
                        });

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ChatDetailPage(
                              name:
                                  widget.otherPet,
                              image:
                                  widget.image2,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Enviar mensaje",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: OutlinedButton(
                      style:
                          OutlinedButton.styleFrom(
                        foregroundColor:
                            Colors.white,
                        side: BorderSide(
                          color: Colors.white
                              .withValues(
                            alpha: 0.2,
                          ),
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Seguir explorando",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _petAvatar(String image) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.pinkAccent,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 56,
        backgroundImage: NetworkImage(image),
      ),
    );
  }
}