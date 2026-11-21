import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'name_screen.dart';
import '../../widgets/bone_painter.dart';
import '../../widgets/user_progress_bar.dart';
import '../../data/user_data.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key});

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  static const int minAge = 18;
  static const int oldestYear = 1930;

  static const List<String> months = [
    "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
    "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre",
  ];

  final DateTime today = DateTime.now();

  late final int newestYear = today.year - minAge;

  late int day;
  late int month; // 1 a 12
  late int year;

  /// El botón se activa cuando la persona mueve las ruedas.
  bool touched = false;

  late FixedExtentScrollController dayController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;

  @override
  void initState() {
    super.initState();

    final saved = UserData.profile["birthDate"];

    if (saved is DateTime) {
      day = saved.day;
      month = saved.month;
      year = saved.year;
      touched = true;
    } else {
      // Punto de partida cercano a la edad típica de los usuarios.
      day = 15;
      month = 6;
      year = newestYear - 7;
    }

    dayController = FixedExtentScrollController(initialItem: day - 1);
    monthController = FixedExtentScrollController(initialItem: month - 1);
    yearController =
        FixedExtentScrollController(initialItem: newestYear - year);
  }

  @override
  void dispose() {
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }

  int daysInMonth(int y, int m) => DateTime(y, m + 1, 0).day;

  int calculateAge(DateTime birthDate) {
    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  DateTime get birthDate => DateTime(year, month, day);

  bool get isAdult => calculateAge(birthDate) >= minAge;

  bool get canContinue => touched && isAdult;

  /// Si se pasa de días (ej. 31 en febrero), baja al último día del mes.
  void fixDay() {
    final max = daysInMonth(year, month);

    if (day > max) {
      day = max;
      dayController.jumpToItem(day - 1);
    }
  }

  void goNext() {
    if (!canContinue) return;

    UserData.updateProfile(
      birthDate: birthDate,
      age: calculateAge(birthDate),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const NameScreen(),
      ),
    );
  }

  Widget wheel({
    required FixedExtentScrollController controller,
    required int count,
    required String Function(int) label,
    required ValueChanged<int> onChanged,
    required int flex,
  }) {
    return Expanded(
      flex: flex,
      child: CupertinoPicker.builder(
        scrollController: controller,
        itemExtent: 46,
        magnification: 1.08,
        useMagnifier: true,
        squeeze: 1.1,
        selectionOverlay: const SizedBox.shrink(),
        onSelectedItemChanged: (i) {
          HapticFeedback.selectionClick();
          setState(() {
            touched = true;
            onChanged(i);
          });
        },
        childCount: count,
        itemBuilder: (context, i) => Center(
          child: Text(
            label(i),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget feedback() {
    if (!touched) {
      return const SizedBox(height: 46);
    }

    if (!isAdult) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              "Debes tener $minAge años o más para usar PawMatch.",
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.pets, color: Colors.green, size: 22),
          const SizedBox(width: 10),
          Text(
            "¡Tienes ${calculateAge(birthDate)} años!",
            style: const TextStyle(
              color: Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final yearCount = newestYear - oldestYear + 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const UserProgressBar(step: 1),
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
                      "¿Cuándo es tu\ncumpleaños?",
                      style: TextStyle(
                        fontSize: 34,
                        height: 1.15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Tu perfil muestra tu edad, no tu fecha de nacimiento.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ----- RUEDAS DE FECHA -----
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Franja que marca la fecha elegida
                          IgnorePointer(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: SizedBox(
                                height: 70,
                                width: double.infinity,
                                child: CustomPaint(
                                  painter: BonePainter(
                                    color: Colors.white,
                                    shadowColor:
                                        Colors.black.withValues(alpha: 0.35),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                wheel(
                                  controller: dayController,
                                  count: daysInMonth(year, month),
                                  label: (i) => "${i + 1}",
                                  onChanged: (i) => day = i + 1,
                                  flex: 2,
                                ),
                                wheel(
                                  controller: monthController,
                                  count: 12,
                                  label: (i) => months[i],
                                  onChanged: (i) {
                                    month = i + 1;
                                    fixDay();
                                  },
                                  flex: 4,
                                ),
                                wheel(
                                  controller: yearController,
                                  count: yearCount,
                                  label: (i) => "${newestYear - i}",
                                  onChanged: (i) {
                                    year = newestYear - i;
                                    fixDay();
                                  },
                                  flex: 3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      alignment: Alignment.topLeft,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: feedback(),
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
