import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../data/app_data.dart'; // 🔥 AGREGADO
import '../chats/chat_detail_page.dart'; // 🔥 AGREGADO

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
  State<MatchSuccessScreen> createState() => _MatchSuccessScreenState();
}

class _MatchSuccessScreenState extends State<MatchSuccessScreen>
    with TickerProviderStateMixin {

  late ConfettiController _leftConfetti;
  late ConfettiController _rightConfetti;

  late AnimationController _zoomController;
  late Animation<double> _zoomAnimation;

  late AnimationController _pawController;
  late Animation<double> _pawAnimation;

  @override
  void initState() {
    super.initState();

    _leftConfetti = ConfettiController(duration: const Duration(seconds: 3));
    _rightConfetti = ConfettiController(duration: const Duration(seconds: 3));

    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _zoomAnimation = CurvedAnimation(
      parent: _zoomController,
      curve: Curves.easeOutBack,
    );

    _pawController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pawAnimation = Tween<double>(begin: 0.9, end: 1.2).animate(_pawController);

    Future.delayed(const Duration(milliseconds: 300), () {
      _zoomController.forward();
      _leftConfetti.play();
      _rightConfetti.play();
    });
  }

  @override
  void dispose() {
    _leftConfetti.dispose();
    _rightConfetti.dispose();
    _zoomController.dispose();
    _pawController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.network(
              widget.image1,
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color: const Color.fromRGBO(0, 0, 0, 0.65),
            ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: ConfettiWidget(
              confettiController: _leftConfetti,
              blastDirection: 0.5,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.3,
            ),
          ),

          Align(
            alignment: Alignment.topRight,
            child: ConfettiWidget(
              confettiController: _rightConfetti,
              blastDirection: 2.5,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.3,
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(height: 40),

                const Text(
                  "¡Tu mascota hizo Match!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "${widget.otherPet} también le dio like a ${widget.myPet}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                ScaleTransition(
                  scale: _zoomAnimation,
                  child: SizedBox(
                    width: width,
                    height: 170,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [

                        Positioned(
                          left: width * 0.22,
                          child: CircleAvatar(
                            radius: 65,
                            backgroundImage: NetworkImage(widget.image1),
                          ),
                        ),

                        Positioned(
                          right: width * 0.22,
                          child: CircleAvatar(
                            radius: 65,
                            backgroundImage: NetworkImage(widget.image2),
                          ),
                        ),

                        ScaleTransition(
                          scale: _pawAnimation,
                          child: const Icon(
                            Icons.pets,
                            color: Colors.pink,
                            size: 48,
                          ),
                        ),

                      ],
                    ),
                  ),
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [

                      /// 🔥 BOTÓN CORREGIDO
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {

                            /// 🔥 CREAR CHAT
                            AppData.createChat({
                              "name": widget.otherPet,
                              "images": [widget.image2],
                            });

                            /// 🔥 IR AL CHAT
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatDetailPage(
                                  name: widget.otherPet,
                                  image: widget.image2,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Enviar mensaje",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Seguir explorando",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                    ],
                  ),
                )

              ],
            ),
          )

        ],
      ),
    );
  }
}