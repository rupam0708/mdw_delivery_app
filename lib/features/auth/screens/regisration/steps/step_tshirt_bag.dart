import 'package:flutter/material.dart';

import '../../../../../core/themes/styles.dart';
import '../../../controllers/registration_controller.dart';

class StepTshirtAndBag extends StatelessWidget {
  const StepTshirtAndBag({super.key, required this.controller});

  final RegistrationController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select T-Shirt Size",
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: controller.shirtSizes.map((size) {
            return ChoiceChip(
              selectedColor: AppColors.btnColor,
              checkmarkColor: controller.selectedShirtSize == size
                  ? AppColors.white
                  : AppColors.btnColor,
              labelStyle: TextStyle(
                color: controller.selectedShirtSize == size
                    ? AppColors.white
                    : AppColors.btnColor,
              ),
              label: Text(size),
              selected: controller.selectedShirtSize == size,
              onSelected: (_) => controller.selectShirtSize(size),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Row(
          children: const [
            Icon(Icons.card_giftcard, color: Colors.green),
            SizedBox(width: 8),
            Text(
              "A bag will be provided automatically",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}
