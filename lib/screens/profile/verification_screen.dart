import 'package:flutter/material.dart';
import '../../data/pet_profile_data.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() =>
      _VerificationScreenState();
}

class _VerificationScreenState
    extends State<VerificationScreen> {

  bool vaccineUploaded = false;
  bool pedigreeUploaded = false;

  @override
  void initState() {
    super.initState();

    final pet = PetProfileData.pet;

    vaccineUploaded =
        pet["verifiedVaccines"] ?? false;

    pedigreeUploaded =
        pet["verifiedPedigree"] ?? false;
  }

  void saveVerification() {
    final blueCheck =
        vaccineUploaded &&
        pedigreeUploaded;

    PetProfileData.pet[
        "verifiedVaccines"] =
        vaccineUploaded;

    PetProfileData.pet[
        "verifiedPedigree"] =
        pedigreeUploaded;

    PetProfileData.pet[
        "blueCheck"] =
        blueCheck;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Verificación actualizada ",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    final verified =
        vaccineUploaded &&
        pedigreeUploaded;

    return Scaffold(
      backgroundColor:
          const Color(0xFF050505),

      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,
        title: const Text(
          "Centro de Verificación",
          style: TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          children: [

            /// ICONO CENTRAL
            Container(
              width: 110,
              height: 110,
              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,
                gradient:
                    LinearGradient(
                  colors: verified
                      ? [
                          Colors.blue,
                          Colors.cyan
                        ]
                      : [
                          Colors.grey,
                          Colors.black54
                        ],
                ),
              ),
              child: Icon(
                verified
                    ? Icons.verified
                    : Icons.shield,
                color:
                    Colors.white,
                size: 54,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              verified
                  ? "Perfil Verificado"
                  : "Pendiente de Verificación",
              style:
                  const TextStyle(
                color:
                    Colors.white,
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Sube documentos para aumentar confianza y recibir más matches.",
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color:
                    Colors.white60,
              ),
            ),

            const SizedBox(height: 28),

            /// VACUNAS
            _cardUpload(
              title:
                  "Carnet de vacunas",
              subtitle:
                  "Foto o PDF del carnet",
              icon:
                  Icons.health_and_safety,
              verified:
                  vaccineUploaded,
              onTap: () {
                setState(() {
                  vaccineUploaded =
                      true;
                });
              },
            ),

            const SizedBox(height: 16),

            /// PEDIGREE
            _cardUpload(
              title:
                  "Certificado pedigree",
              subtitle:
                  "Documento oficial",
              icon:
                  Icons.workspace_premium,
              verified:
                  pedigreeUploaded,
              onTap: () {
                setState(() {
                  pedigreeUploaded =
                      true;
                });
              },
            ),

            const SizedBox(height: 28),

            /// BENEFICIOS
            _benefit(
              "Check azul en perfil",
            ),
            _benefit(
              "Más confianza",
            ),
            _benefit(
              "Más matches",
            ),
            _benefit(
              "Mayor visibilidad",
            ),

            const SizedBox(height: 34),

            SizedBox(
              width:
                  double.infinity,
              height: 58,
              child:
                  ElevatedButton(
                onPressed:
                    saveVerification,
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),
                ),
                child:
                    const Text(
                  "Guardar verificación",
                  style:
                      TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _cardUpload({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool verified,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width:
            double.infinity,
        padding:
            const EdgeInsets.all(18),
        decoration:
            BoxDecoration(
          color:
              Colors.white10,
          borderRadius:
              BorderRadius.circular(
            22,
          ),
          border: Border.all(
            color: verified
                ? Colors.green
                : Colors.white10,
          ),
        ),
        child: Row(
          children: [

            Container(
              width: 56,
              height: 56,
              decoration:
                  BoxDecoration(
                color: verified
                    ? Colors.green
                        .withValues(
                        alpha:
                            0.15)
                    : Colors.blue
                        .withValues(
                        alpha:
                            0.15),
                shape:
                    BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: verified
                    ? Colors.green
                    : Colors.blue,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [

                  Text(
                    title,
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                      height: 4),

                  Text(
                    subtitle,
                    style:
                        const TextStyle(
                      color:
                          Colors.white54,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              verified
                  ? Icons.check_circle
                  : Icons.upload_file,
              color: verified
                  ? Colors.green
                  : Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _benefit(String text) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        children: [

          const Icon(
            Icons.check,
            color: Colors.blue,
            size: 18,
          ),

          const SizedBox(width: 10),

          Text(
            text,
            style:
                const TextStyle(
              color:
                  Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}