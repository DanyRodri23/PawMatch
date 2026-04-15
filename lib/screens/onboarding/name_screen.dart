import 'package:flutter/material.dart';
import 'gender_screen.dart';
import '../../widgets/user_progress_bar.dart';
import '../../data/user_data.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() =>
      _NameScreenState();
}

class _NameScreenState
    extends State<NameScreen> {

  final TextEditingController
      nameController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void goNext() {
    final name =
        nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Escribe tu nombre",
          ),
        ),
      );

      return;
    }

    UserData.updateProfile(
      name: name,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const GenderScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const UserProgressBar(
              step: 2,
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
                      height: 40,
                    ),
                    const Text(
                      "¿Cómo te llamas?",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Este será tu nombre en PawMatch.",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            Colors.black54,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TextField(
                      controller:
                          nameController,
                      style:
                          const TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.w500,
                      ),
                      decoration:
                          InputDecoration(
                        hintText:
                            "Tu nombre",
                        filled: true,
                        fillColor:
                            Colors.grey
                                .shade100,
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                          borderSide:
                              BorderSide
                                  .none,
                        ),
                        focusedBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                          borderSide:
                              const BorderSide(
                            color:
                                Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width:
                          double.infinity,
                      height: 55,
                      child:
                          ElevatedButton(
                        style:
                            ElevatedButton
                                .styleFrom(
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
                        onPressed:
                            goNext,
                        child:
                            const Text(
                          "Continuar",
                          style:
                              TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
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
      ),
    );
  }
}