import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'name_screen.dart';
import '../../widgets/user_progress_bar.dart';
import '../../data/user_data.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key});

  @override
  State<BirthdayScreen> createState() =>
      _BirthdayScreenState();
}

class _BirthdayScreenState
    extends State<BirthdayScreen> {

  final TextEditingController dayController =
      TextEditingController();

  final TextEditingController monthController =
      TextEditingController();

  final TextEditingController yearController =
      TextEditingController();

  Widget dateBox(
    String hint,
    TextEditingController controller,
    int maxLength,
    double width,
  ) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter
              .digitsOnly,
          LengthLimitingTextInputFormatter(
            maxLength,
          ),
        ],
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: hint,
          counterText: "",
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding:
              const EdgeInsets.symmetric(
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(18),
            borderSide:
                const BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  int calculateAge(DateTime birthDate) {
    final today = DateTime.now();

    int age =
        today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month ==
                birthDate.month &&
            today.day <
                birthDate.day)) {
      age--;
    }

    return age;
  }

  void goNext() {
    if (dayController.text.isEmpty ||
        monthController.text.isEmpty ||
        yearController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Completa tu fecha de nacimiento",
          ),
        ),
      );
      return;
    }

    final int day =
        int.parse(dayController.text);

    final int month =
        int.parse(monthController.text);

    final int year =
        int.parse(yearController.text);

    final birthDate =
        DateTime(year, month, day);

    final age =
        calculateAge(birthDate);

    UserData.updateProfile(
      birthDate: birthDate,
      age: age,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const NameScreen(),
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
              step: 1,
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
                      "Tu cumpleaños",
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
                      "Tu perfil muestra tu edad, no tu fecha de nacimiento.",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            Colors.black54,
                      ),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children: [
                        dateBox(
                          "DD",
                          dayController,
                          2,
                          70,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        dateBox(
                          "MM",
                          monthController,
                          2,
                          70,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        dateBox(
                          "AAAA",
                          yearController,
                          4,
                          100,
                        ),
                      ],
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
                          elevation: 0,
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