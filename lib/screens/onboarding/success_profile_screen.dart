import 'package:flutter/material.dart';
import 'pet_intro_screen.dart';
import '../../services/user_services.dart';
import '../../data/user_data.dart';

class SuccessProfileScreen extends StatelessWidget {
  const SuccessProfileScreen({
    super.key,
  });

  Future<void> saveAndContinue(
    BuildContext context,
  ) async {
    try {
      await UserService.saveUserProfile(
        data: UserData.profile,
      );
    } catch (e) {
      debugPrint(
        "Error guardando usuario: $e",
      );
    }

    if (!context.mounted) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const PetIntroScreen(),
      ),
    );
  }

  Widget buildSuccessIcon() {
    return Container(
      width: 150,
      height: 150,
      decoration:
          BoxDecoration(
        shape:
            BoxShape.circle,
        color: Colors.green
            .withValues(
          alpha: 0.08,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green
                .withValues(
              alpha: 0.18,
            ),
            blurRadius: 30,
            spreadRadius: 4,
          ),
        ],
      ),
      child: const Icon(
        Icons.check_rounded,
        color:
            Colors.green,
        size: 90,
      ),
    );
  }

  Widget buildTitle() {
    return const Text(
      "Perfil creado con éxito",
      textAlign:
          TextAlign.center,
      style: TextStyle(
        fontSize: 30,
        fontWeight:
            FontWeight.w800,
        letterSpacing:
            -0.5,
      ),
    );
  }

  Widget buildDescription() {
    return Container(
      padding:
          const EdgeInsets.all(
        20,
      ),
      decoration:
          BoxDecoration(
        color: Colors
            .grey
            .shade50,
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        border: Border.all(
          color: Colors
              .grey
              .shade200,
        ),
      ),
      child: const Text(
        "Hemos finalizado con los datos del propietario.\nAhora agregaremos la información de tu mascota.",
        textAlign:
            TextAlign.center,
        style: TextStyle(
          fontSize: 17,
          color:
              Colors.black54,
          height: 1.5,
        ),
      ),
    );
  }

  Widget buildContinueButton(
    BuildContext context,
  ) {
    return SizedBox(
      width:
          double.infinity,
      height: 58,
      child:
          ElevatedButton(
        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              Colors.black,
          foregroundColor:
              Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              20,
            ),
          ),
        ),
        onPressed: () =>
            saveAndContinue(
          context,
        ),
        child:
            const Text(
          "Continuar",
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
        30,
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment
                .center,
        children: [
          buildSuccessIcon(),

          const SizedBox(
            height: 38,
          ),

          buildTitle(),

          const SizedBox(
            height: 16,
          ),

          buildDescription(),

          const SizedBox(
            height: 55,
          ),

          buildContinueButton(
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