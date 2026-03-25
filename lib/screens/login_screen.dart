import 'dart:ui';
import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'auth/phone_number_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(
      'assets/videos/dogs_background.mp4',
    );

    _controller.initialize().then((_) {
      setState(() {});
      _controller.setLooping(true);
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // GOOGLE LOGIN
  Future<void> signInWithGoogle(BuildContext context) async {
    try {

      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      final userCredential =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);

      if (!context.mounted) return;

      if (userCredential.user != null) {

        final user = FirebaseAuth.instance.currentUser;

        if (user?.phoneNumber == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const PhoneNumberScreen(),
            ),
          );
        }
      }

    } catch (e) {
      debugPrint("Error Google Sign In: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Stack(
        children: [

          /// VIDEO FONDO
          if (_controller.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          else
            Container(color: Colors.black),

          /// FILTRO OSCURO
          Container(
            color: Colors.black.withValues(alpha: 0.55),
          ),

          /// CONTENIDO
          SingleChildScrollView(
            child: Column(
              children: [

                const SizedBox(height: 120),

                Image.asset(
                  'assets/logo.png',
                  height: 110,
                ),

                const SizedBox(height: 12),

                const Text(
                  "PAWMATCH",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Encuentra la pareja perfecta para tu mascota",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 40),

                /// TARJETA GLASS (ESTILO BUMBLE)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 15,
                        sigmaY: 15,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),

                        child: Column(
                          children: [

                            /// GOOGLE
                            ElevatedButton.icon(
                              icon: Image.asset(
                                'assets/google_icon.png',
                                height: 24,
                              ),
                              label: const Text("Continuar con Google"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withValues(alpha: 0.9),
                                foregroundColor: Colors.black87,
                                elevation: 0,
                                minimumSize: const Size(double.infinity, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () async {
                                await signInWithGoogle(context);
                              },
                            ),

                            const SizedBox(height: 14),

                            /// FACEBOOK
                            ElevatedButton.icon(
                              icon: const Icon(Icons.facebook),
                              label: const Text("Continuar con Facebook"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1877F2),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Facebook login se activará próximamente",
                                    ),
                                  ),
                                );

                              },
                            ),

                            const SizedBox(height: 14),

                            /// TELEFONO
                            ElevatedButton.icon(
                              icon: const Icon(Icons.phone),
                              label: const Text("Continuar con móvil"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withValues(alpha: 0.9),
                                foregroundColor: Colors.black87,
                                elevation: 0,
                                minimumSize: const Size(double.infinity, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PhoneNumberScreen(),
                                  ),
                                );

                              },
                            ),

                            const SizedBox(height: 14),

                            /// EMAIL
                            ElevatedButton.icon(
                              icon: const Icon(Icons.email_outlined),
                              label: const Text("Continuar con correo"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withValues(alpha: 0.9),
                                foregroundColor: Colors.black87,
                                elevation: 0,
                                minimumSize: const Size(double.infinity, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ),
                                );

                              },
                            ),

                            const SizedBox(height: 20),

                            /// CREAR CUENTA
                            OutlinedButton(
                              onPressed: () {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ),
                                );

                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 55),
                                side: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                "Crear cuenta",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  "Nunca compartiremos tu información sin tu permiso",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 40),

              ],
            ),
          ),

        ],
      ),
    );
  }
}