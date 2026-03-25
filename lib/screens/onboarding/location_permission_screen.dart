import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'success_profile_screen.dart';
import '../../widgets/user_progress_bar.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() => _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen>
    with SingleTickerProviderStateMixin {

  bool isLoading = false;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 0.9,
      upperBound: 1.1,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> requestLocation() async {

    setState(() {
      isLoading = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!mounted) return;

    if (!serviceEnabled) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Activa la ubicación en tu dispositivo"),
        ),
      );

      setState(() {
        isLoading = false;
      });

      return;
    }

    permission = await Geolocator.checkPermission();

    if (!mounted) return;

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (!mounted) return;

    if (permission == LocationPermission.deniedForever) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Los permisos de ubicación están bloqueados"),
        ),
      );

      setState(() {
        isLoading = false;
      });

      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (!mounted) return;

    debugPrint("Latitud: ${position.latitude}");
    debugPrint("Longitud: ${position.longitude}");

    setState(() {
      isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SuccessProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            /// BARRA PROGRESO
            const UserProgressBar(step: 5),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),

                child: Column(
                  children: [

                    const SizedBox(height: 60),

                    const Text(
                      "Activa tu ubicación",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Necesitamos tu ubicación para mostrar mascotas cerca de ti y ayudarte a encontrar el match perfecto.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// PLANETA + RADAR
                    Expanded(
                      child: Center(
                        child: Transform.translate(
                          offset: const Offset(0, -20),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [

                              Container(
                                width: 420,
                                height: 420,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue.withValues(alpha: 0.05),
                                ),
                              ),

                              Container(
                                width: 360,
                                height: 360,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue.withValues(alpha: 0.08),
                                ),
                              ),

                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.25),
                                      blurRadius: 40,
                                      spreadRadius: 5,
                                    )
                                  ],
                                ),
                                child: Image.asset(
                                  "assets/earth.png",
                                  width: 350,
                                ),
                              ),

                              Transform.translate(
                                offset: const Offset(0, -30),
                                child: ScaleTransition(
                                  scale: _controller,
                                  child: Image.asset(
                                    "assets/location_icon.png",
                                    width: 200,
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      height: 60,

                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),

                        onPressed: isLoading ? null : requestLocation,

                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Permitir ubicación",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 30),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}