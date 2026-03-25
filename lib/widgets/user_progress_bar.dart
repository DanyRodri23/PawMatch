import 'package:flutter/material.dart';

class UserProgressBar extends StatelessWidget {

  final int step;
  final int totalSteps;

  const UserProgressBar({
    super.key,
    required this.step,
    this.totalSteps = 5,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),

      child: Row(
        children: List.generate(totalSteps, (index) {

          bool active = index < step;

          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,

              decoration: BoxDecoration(
                color: active ? Colors.black : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );

        }),
      ),
    );
  }
}