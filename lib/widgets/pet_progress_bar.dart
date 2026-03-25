import 'package:flutter/material.dart';

class PetProgressBar extends StatelessWidget {

  final int step;
  final int totalSteps;

  const PetProgressBar({
    super.key,
    required this.step,
    this.totalSteps = 9,
  });

  @override
  Widget build(BuildContext context) {

    double progress = step / totalSteps;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 10),

          LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.grey.shade300,
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),

          const SizedBox(height: 6),

          Text(
            "Paso $step de $totalSteps",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),

        ],
      ),
    );
  }
}