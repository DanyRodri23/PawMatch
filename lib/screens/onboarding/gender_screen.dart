import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'profile_photo_screen.dart';
import '../../widgets/user_progress_bar.dart';
import '../../data/user_data.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String? selectedGender;
  bool showOnProfile = true;

  // Los textos de "value" se usan en el resto de la app: no cambiarlos.
  static const List<Map<String, dynamic>> options = [
    {
      "value": "Hombre",
      "subtitle": "Me identifico como hombre",
      "icon": Icons.male,
    },
    {
      "value": "Mujer",
      "subtitle": "Me identifico como mujer",
      "icon": Icons.female,
    },
    {
      "value": "Más allá del binario",
      "subtitle": "Otra identidad o prefiero no decirlo",
      "icon": Icons.transgender,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Si regresa a esta pantalla, se muestra lo que ya eligió.
    final saved = (UserData.profile["gender"] ?? "").toString();

    if (options.any((o) => o["value"] == saved)) {
      selectedGender = saved;
    }

    showOnProfile = UserData.profile["showGender"] != false;
  }

  void goNext() {
    if (selectedGender == null) return;

    UserData.updateProfile(
      gender: selectedGender,
      showGender: showOnProfile,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePhotoScreen(),
      ),
    );
  }

  Widget genderOption(Map<String, dynamic> option) {
    final String value = option["value"];
    final bool isSelected = selectedGender == value;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          selectedGender = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade200,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.14)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                option["icon"] as IconData,
                size: 28,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    option["subtitle"] as String,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected ? Colors.white60 : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.black)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget showSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Icon(
            showOnProfile ? Icons.visibility : Icons.visibility_off,
            color: Colors.black54,
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              "Mostrar en mi perfil",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch(
            value: showOnProfile,
            activeTrackColor: Colors.black,
            onChanged: (value) {
              setState(() {
                showOnProfile = value;
              });
            },
          ),
        ],
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
            const UserProgressBar(step: 3),
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
                      "¿Cuál es tu\ngénero?",
                      style: TextStyle(
                        fontSize: 34,
                        height: 1.15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Elige lo que mejor te describa. Tú decides si se muestra en tu perfil.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ...options.map(genderOption),
                    const SizedBox(height: 6),
                    showSwitch(),
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
                  onPressed: selectedGender == null ? null : goNext,
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
