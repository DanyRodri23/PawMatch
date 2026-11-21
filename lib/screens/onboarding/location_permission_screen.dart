import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'success_profile_screen.dart';
import '../../services/location_service.dart';
import '../../widgets/user_progress_bar.dart';

enum _Step { idle, detecting, found, problem }

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  _Step step = _Step.idle;
  LocationStatus? problem;
  String? province;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> detect() async {
    setState(() {
      step = _Step.detecting;
      problem = null;
    });

    final result = await LocationService.detect();

    if (!mounted) return;

    if (result.status == LocationStatus.ok && result.province != null) {
      LocationService.saveProvince(result.province!);

      setState(() {
        province = result.province;
        step = _Step.found;
      });

      // Se deja ver la provincia un momento antes de seguir.
      await Future.delayed(const Duration(milliseconds: 1600));

      if (!mounted) return;

      goNext();
      return;
    }

    setState(() {
      problem = result.status;
      step = _Step.problem;
    });
  }

  void goNext() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SuccessProfileScreen(),
      ),
    );
  }

  /// Solo para pruebas (en la app final no aparece).
  Future<void> pickForTesting() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Solo para pruebas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...LocationService.provinces.map(
              (p) => ListTile(
                title: Text(p),
                onTap: () => Navigator.pop(context, p),
              ),
            ),
          ],
        ),
      ),
    );

    if (selected == null || !mounted) return;

    LocationService.saveProvince(selected);
    goNext();
  }

  String get problemTitle {
    switch (problem) {
      case LocationStatus.denied:
        return "Necesitamos tu permiso";
      case LocationStatus.deniedForever:
        return "El permiso está bloqueado";
      case LocationStatus.serviceOff:
        return "La ubicación está apagada";
      case LocationStatus.outsideCountry:
        return "Aún no llegamos a tu zona";
      default:
        return "No pudimos ubicarte";
    }
  }

  String get problemText {
    switch (problem) {
      case LocationStatus.denied:
        return "Sin tu ubicación no podemos mostrarte mascotas cerca de ti.";
      case LocationStatus.deniedForever:
        return "Actívalo en Ajustes > PawMatch > Ubicación y vuelve aquí.";
      case LocationStatus.serviceOff:
        return "Enciende la ubicación de tu teléfono y vuelve a intentarlo.";
      case LocationStatus.outsideCountry:
        return "Por ahora PawMatch está disponible solo en Costa Rica.";
      default:
        return "Revisa tu conexión y la señal GPS, e inténtalo otra vez.";
    }
  }

  Future<void> onProblemAction() async {
    if (problem == LocationStatus.deniedForever) {
      await Geolocator.openAppSettings();
    } else if (problem == LocationStatus.serviceOff) {
      await Geolocator.openLocationSettings();
    } else {
      await detect();
    }
  }

  String get problemButton {
    switch (problem) {
      case LocationStatus.deniedForever:
        return "Abrir ajustes";
      case LocationStatus.serviceOff:
        return "Activar ubicación";
      default:
        return "Intentar de nuevo";
    }
  }

  // ---------------- DIBUJO ----------------

  Widget radar() {
    final found = step == _Step.found;

    return SizedBox(
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ondas que se expanden
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Stack(
                alignment: Alignment.center,
                children: List.generate(3, (i) {
                  final t = (_controller.value + i / 3) % 1.0;

                  return Container(
                    width: 90 + 160 * t,
                    height: 90 + 160 * t,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: (found ? Colors.green : Colors.black)
                            .withValues(alpha: (1 - t) * 0.35),
                        width: 2,
                      ),
                    ),
                  );
                }),
              );
            },
          ),

          // Pin con huellita
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: found ? Colors.green : Colors.black,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (found ? Colors.green : Colors.black)
                      .withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              found ? Icons.check_rounded : Icons.pets,
              color: Colors.white,
              size: 46,
            ),
          ),
        ],
      ),
    );
  }

  Widget benefit(IconData icon, String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 22, color: Colors.black87),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget content() {
    switch (step) {
      case _Step.detecting:
        return const Column(
          children: [
            Text(
              "Buscando tu provincia...",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Esto toma unos segundos.",
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
          ],
        );

      case _Step.found:
        return Column(
          children: [
            const Text(
              "¡Te encontramos!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    "$province, Costa Rica",
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

      case _Step.problem:
        return Column(
          children: [
            Text(
              problemTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              problemText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 15,
                height: 1.35,
              ),
            ),
          ],
        );

      case _Step.idle:
        return Column(
          children: [
            benefit(
              Icons.pets,
              "Mascotas cerca de ti",
              "Te mostramos perros de tu provincia.",
            ),
            benefit(
              Icons.lock_outline,
              "Tu ubicación exacta es privada",
              "Solo guardamos la provincia, nunca dónde estás.",
            ),
            benefit(
              Icons.sync,
              "Se actualiza sola",
              "Si cambias de provincia, lo detectamos automáticamente.",
            ),
          ],
        );
    }
  }

  Widget bottomButton() {
    if (step == _Step.found) return const SizedBox(height: 56);

    final busy = step == _Step.detecting;
    final isProblem = step == _Step.problem;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade300,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: busy ? null : (isProblem ? onProblemAction : detect),
            child: busy
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    isProblem ? problemButton : "Activar ubicación",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),

        // Solo en modo de pruebas (no aparece en la app final)
        if (kDebugMode && isProblem)
          TextButton(
            onPressed: pickForTesting,
            child: const Text(
              "Elegir provincia (solo pruebas)",
              style: TextStyle(color: Colors.black45),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const UserProgressBar(step: 5),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 32, 28, 16),
                child: Column(
                  children: [
                    const Text(
                      "Activa tu ubicación",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Así encontramos mascotas cerca de ti.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                    radar(),
                    const SizedBox(height: 10),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: double.infinity,
                        child: content(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 16),
              child: bottomButton(),
            ),
          ],
        ),
      ),
    );
  }
}
