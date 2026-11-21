import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gender_screen.dart';
import '../../widgets/user_progress_bar.dart';
import '../../data/user_data.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  static const int maxLength = 30;

  final TextEditingController nameController = TextEditingController();
  final FocusNode focus = FocusNode();

  @override
  void initState() {
    super.initState();

    // Si ya escribió su nombre antes, se muestra. Si no, se sugiere el
    // primer nombre con el que creó la cuenta.
    String initial = (UserData.profile["name"] ?? "").toString();

    if (initial.isEmpty) {
      final display = FirebaseAuth.instance.currentUser?.displayName ?? "";
      initial = display.trim().split(" ").first;
    }

    nameController.text = initial;

    nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    nameController.dispose();
    focus.dispose();
    super.dispose();
  }

  String get name => nameController.text.trim();

  bool get canContinue => name.length >= 2;

  void goNext() {
    if (!canContinue) return;

    UserData.updateProfile(name: name);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const GenderScreen(),
      ),
    );
  }

  /// Chapita de collar donde se escribe el nombre.
  Widget nameTag() {
    return Column(
      children: [
        // Argolla del collar
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade400, width: 6),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -14),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  "¡HOLA, SOY!",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: nameController,
                  focusNode: focus,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  cursorColor: Colors.white,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(maxLength),
                    // Solo letras (con tildes), espacios, guion y apóstrofe.
                    FilteringTextInputFormatter.allow(
                      RegExp(r"[A-Za-zÁÉÍÓÚÜÑáéíóúüñ' \-]"),
                    ),
                  ],
                  onSubmitted: (_) => goNext(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Tu nombre",
                    hintStyle: TextStyle(
                      color: Colors.white24,
                      fontWeight: FontWeight.w700,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 6),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 2,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 14),
                const Icon(Icons.pets, color: Colors.white38, size: 22),
              ],
            ),
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
            const UserProgressBar(step: 2),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 40, 28, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.pets,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      "¿Cómo te\nllamas?",
                      style: TextStyle(
                        fontSize: 34,
                        height: 1.15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Así te verán los demás dueños en PawMatch.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 36),
                    nameTag(),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        name.isEmpty
                            ? "Escribe al menos 2 letras"
                            : "${name.length}/$maxLength",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade500,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: canContinue ? goNext : null,
                  child: const Text(
                    "Continuar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
