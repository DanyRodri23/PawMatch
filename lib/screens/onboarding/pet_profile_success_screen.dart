import 'package:flutter/material.dart';
import '../../data/pet_profile_data.dart';
import '../../data/user_data.dart';
import '../../services/user_services.dart';

class PetProfileSuccessScreen
    extends StatelessWidget {
  const PetProfileSuccessScreen({
    super.key,
  });

  Future<void> goToDashboard(
    BuildContext context,
  ) async {
    // "Verificado" no se activa solo: se otorga cuando se revisen los documentos.
    PetProfileData.updatePet(
      profileCompleted: true,
    );

    try {
      await UserService.saveUserProfile(
        data: UserData.profile,
      );
    } catch (e) {
      debugPrint(
        "Error guardando perfil final: $e",
      );
    }

    if (!context.mounted) {
      return;
    }

    // Vuelve a la pantalla raíz; ProfileGate muestra el dashboard.
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Widget buildSuccessIcon() {
    return const Icon(
      Icons.check_circle,
      color: Colors.green,
      size: 100,
    );
  }

  Widget buildTitle() {
    return const Text(
      "¡Perfil creado con éxito!",
      style: TextStyle(
        fontSize: 32,
        fontWeight:
            FontWeight.bold,
      ),
      textAlign:
          TextAlign.center,
    );
  }

  Widget buildDescription() {
    return const Text(
      "Tu mascota ya forma parte de PawMatch. Ahora puedes comenzar a explorar y encontrar compañeros ideales.",
      style: TextStyle(
        fontSize: 16,
        color:
            Colors.black54,
      ),
      textAlign:
          TextAlign.center,
    );
  }

  Widget buildButton(
    BuildContext context,
  ) {
    return SizedBox(
      width:
          double.infinity,
      height: 55,
      child:
          ElevatedButton(
        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              Colors.black,
          foregroundColor:
              Colors.white,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              18,
            ),
          ),
        ),
        onPressed: () =>
            goToDashboard(
          context,
        ),
        child:
            const Text(
          "Ir al inicio",
          style:
              TextStyle(
            fontSize: 18,
            fontWeight:
                FontWeight
                    .bold,
          ),
        ),
      ),
    );
  }

  Widget buildBody(
    BuildContext context,
  ) {
    return Padding(
      padding:
          const EdgeInsets.all(
        28,
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment
                .center,
        children: [
          buildSuccessIcon(),

          const SizedBox(
            height: 30,
          ),

          buildTitle(),

          const SizedBox(
            height: 20,
          ),

          buildDescription(),

          const SizedBox(
            height: 40,
          ),

          buildButton(
            context,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          Colors.white,
      body: SafeArea(
        child: buildBody(
          context,
        ),
      ),
    );
  }
}