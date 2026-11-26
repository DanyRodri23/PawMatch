import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'data/pet_profile_data.dart';
import 'screens/onboarding/onboarding_intro.dart';
import 'services/discover_service.dart';
import 'services/location_service.dart';
import 'services/profile_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const PawMatchApp());
}

class PawMatchApp extends StatelessWidget {
  const PawMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PawMatch',

      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),

      home: const AuthGate(),
    );
  }
}

/// Decide qué pantalla mostrar según si hay una sesión iniciada.
/// - Con sesión: va al dashboard (la sesión se recuerda al cerrar la app).
/// - Sin sesión: va al login.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        if (snapshot.hasData) {
          return ProfileGate(
            key: ValueKey(snapshot.data!.uid),
          );
        }

        return const LoginScreen();
      },
    );
  }
}


/// Carga el perfil guardado del usuario y, si es nuevo, abre el registro.
class ProfileGate extends StatefulWidget {
  const ProfileGate({super.key});

  /// Se avisa desde el final del registro para que se muestre el dashboard.
  static final ValueNotifier<int> profileChanged = ValueNotifier<int>(0);

  @override
  State<ProfileGate> createState() => _ProfileGateState();
}

class _ProfileGateState extends State<ProfileGate>
    with WidgetsBindingObserver {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ProfileGate.profileChanged.addListener(_onProfileChanged);
    _start();
  }

  void _onProfileChanged() {
    if (mounted) setState(() {});
  }

  void _openOnboarding() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const OnboardingIntro()),
    );
  }

  @override
  void dispose() {
    ProfileGate.profileChanged.removeListener(_onProfileChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Al volver a abrir la app, se revisa si cambió de provincia.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        PetProfileData.pet["profileCompleted"] == true) {
      LocationService.refreshIfNeeded();
    }
  }

  Future<void> _start() async {
    await ProfileStore.load();
    await DiscoverService.publish();
    await DiscoverService.loadLikesAndMatches();

    if (!mounted) return;

    setState(() {
      _loaded = true;
    });

    // Usuario con perfil: se actualiza su provincia si se movió.
    if (PetProfileData.pet["profileCompleted"] == true) {
      LocationService.refreshIfNeeded(force: true);
    }

    // Usuario nuevo: se abre el registro una sola vez.
    if (PetProfileData.pet["profileCompleted"] != true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const OnboardingIntro()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    // Sin mascota registrada no se muestra el dashboard: primero el registro.
    if (PetProfileData.pet["profileCompleted"] != true) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Termina tu registro",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Necesitas registrar a tu mascota para usar PawMatch.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _openOnboarding,
                      child: const Text("Continuar"),
                    ),
                  ),
                  TextButton(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    child: const Text("Cerrar sesión"),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (!kDebugMode) return const DashboardScreen();

    // Botón SOLO de pruebas (no aparece en la app final).
    return Stack(
      children: [
        const DashboardScreen(),
        Positioned(
          left: 6,
          top: MediaQuery.of(context).size.height * 0.45,
          child: Material(
            color: Colors.orange,
            shape: const CircleBorder(),
            elevation: 4,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _confirmReset,
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.restart_alt_rounded,
                    color: Colors.white, size: 22),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmReset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Modo pruebas"),
        content: const Text(
          "¿Borrar tu perfil y repetir el registro desde cero? "
          "Solo afecta a esta cuenta.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Repetir registro"),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;

    setState(() => _loaded = false);

    await ProfileStore.resetForTesting();

    if (!mounted) return;

    await _start();
  }
}
