import 'package:flutter/material.dart';
import 'pet_vaccines_screen.dart';
import '../../widgets/pet_progress_bar.dart';
import '../../data/pet_profile_data.dart';
import 'package:pawmatch/helpers/pet_flow_helper.dart';

class PetPedigreeScreen extends StatefulWidget {
  const PetPedigreeScreen({super.key});

  @override
  State<PetPedigreeScreen> createState() =>
      _PetPedigreeScreenState();
}

class _PetPedigreeScreenState
    extends State<PetPedigreeScreen> {
  bool isLoading = false;

  bool uploadedCertificate = false;

  void uploadFile() {
    setState(() {
      uploadedCertificate = true;
    });

    PetProfileData.updatePet(
      pedigree: true,
      pedigreeCertificate:
          "uploaded_demo_certificate",
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Certificado cargado correctamente (Demo)",
        ),
      ),
    );
  }

  void cannotUpload() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              20,
            ),
          ),
          title: const Text(
            "Información importante",
          ),
          content: const Text(
            "Sube el certificado de pedigrí de tu mascota para validar que "
            "tu mascota es 100% de raza.\n\n"
            "Esta información será visible únicamente para PawMatch y no "
            "será compartida con otros usuarios.\n\n"
            "Los usuarios verán un check azul indicando que la mascota ha "
            "sido verificada como pedigrí.\n\n"
            "Si no puedes subirlo ahora, podrás hacerlo más adelante desde "
            "el perfil de tu mascota.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context);
              },
              child: const Text(
                "Entendido",
              ),
            )
          ],
        );
      },
    );
  }

  void continueNext() async {
    setState(() {
      isLoading = true;
    });

    if (!uploadedCertificate) {
      PetProfileData.updatePet(
        pedigree: false,
        pedigreeCertificate:
            "",
      );
    }

    await Future.delayed(
      const Duration(
        milliseconds: 900,
      ),
    );

    if (!mounted) return;

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration:
            const Duration(
          milliseconds: 400,
        ),
        pageBuilder:
            (_, __, ___) =>
                const PetVaccinesScreen(
          isBreedDog: true,
        ),
        transitionsBuilder:
            (
          _,
          animation,
          __,
          child,
        ) {
          return FadeTransition(
            opacity: animation,
            child:
                SlideTransition(
              position: Tween(
                begin:
                    const Offset(
                  0.1,
                  0,
                ),
                end:
                    Offset.zero,
              ).animate(
                  animation),
              child: child,
            ),
          );
        },
      ),
    );

    setState(() {
      isLoading = false;
    });
  }

  void goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white,

      appBar: AppBar(
        backgroundColor:
            Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: goBack,
        ),
      ),

      body: Column(
        children: [
          PetProgressBar(
            step: PetFlowHelper.getStep("pedigree"),
            totalSteps: PetFlowHelper.totalSteps,
          ),

          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.all(
                28,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),

                  const Text(
                    "Certificación de Pedigrí",
                    style:
                        TextStyle(
                      fontSize: 32,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Text(
                    "Sube el certificado de pedigrí de tu mascota para validar "
                    "que tu mascota es 100% de raza.\n\n"
                    "Esta información solo será visible para PawMatch.",
                    style:
                        TextStyle(
                      fontSize: 16,
                      color: Colors
                          .black54,
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  GestureDetector(
                    onTap: uploadFile,
                    child:
                        Container(
                      width: double
                          .infinity,
                      height: 150,
                      decoration:
                          BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                          24,
                        ),
                        gradient:
                            const LinearGradient(
                          colors: [
                            Color(
                              0xFFF7F7F7,
                            ),
                            Color(
                              0xFFEDEDED,
                            ),
                          ],
                        ),
                        border:
                            Border.all(
                          color: Colors
                              .grey
                              .shade300,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [
                          const Icon(
                            Icons
                                .cloud_upload_rounded,
                            size: 45,
                            color: Colors
                                .black87,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            uploadedCertificate
                                ? "Certificado cargado"
                                : "Subir certificado",
                            style:
                                const TextStyle(
                              fontSize:
                                  17,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          const Text(
                            "PDF, imagen o documento",
                            style:
                                TextStyle(
                              fontSize:
                                  13,
                              color: Colors
                                  .black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  Center(
                    child:
                        GestureDetector(
                      onTap:
                          cannotUpload,
                      child:
                          const Text(
                        "No puedo subirlo en este momento",
                        style:
                            TextStyle(
                          fontSize:
                              14,
                          color: Colors
                              .black54,
                          decoration:
                              TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  GestureDetector(
                    onTap: isLoading
                        ? null
                        : continueNext,
                    child:
                        AnimatedContainer(
                      duration:
                          const Duration(
                        milliseconds:
                            200,
                      ),
                      width: double
                          .infinity,
                      height: 65,
                      decoration:
                          BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                          30,
                        ),
                        gradient:
                            const LinearGradient(
                          colors: [
                            Color(
                              0xFF000000,
                            ),
                            Color(
                              0xFF1C1C1E,
                            ),
                          ],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors
                                .black26,
                            blurRadius:
                                15,
                            offset:
                                Offset(
                              0,
                              6,
                            ),
                          )
                        ],
                      ),
                      child: Center(
                        child: isLoading
                            ? const SizedBox(
                                height:
                                    24,
                                width:
                                    24,
                                child:
                                    CircularProgressIndicator(
                                  color: Colors
                                      .white,
                                  strokeWidth:
                                      2.5,
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Continuar",
                                    style:
                                        TextStyle(
                                      fontSize:
                                          18,
                                      fontWeight:
                                          FontWeight.w600,
                                      letterSpacing:
                                          0.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          10),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}