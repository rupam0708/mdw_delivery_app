import 'package:flutter/material.dart';

class StepCompleted extends StatelessWidget {
  const StepCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "🎉 Complete!",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Congratulations! You’ve successfully filled out all the required details.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Please tap the register button below to finalize your onboarding.",
          style: TextStyle(
            fontSize: 15,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
