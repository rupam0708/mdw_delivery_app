import 'package:flutter/material.dart';

import '../../../core/themes/styles.dart';

class EarningsScreen extends StatelessWidget {
  final String currentMonthRange;
  final double currentMonthEarnings;
  final double previousMonthEarnings;

  const EarningsScreen({
    super.key,
    required this.currentMonthRange,
    required this.currentMonthEarnings,
    required this.previousMonthEarnings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Earnings"),
        backgroundColor: AppColors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.containerBorderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentMonthRange,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "₹ ${currentMonthEarnings.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: AppColors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Last month",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "₹ ${previousMonthEarnings.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: AppColors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
