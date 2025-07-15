import 'package:flutter/material.dart';

import '../../../../../core/themes/styles.dart';
import '../../../controllers/registration_controller.dart';

class StepJobType extends StatelessWidget {
  const StepJobType({super.key, required this.controller});

  final RegistrationController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Select Job Type",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: controller.jobTypes.map((type) {
            return ChoiceChip(
              selectedColor: AppColors.btnColor,
              checkmarkColor: controller.selectedJobType == type
                  ? AppColors.white
                  : AppColors.btnColor,
              labelStyle: TextStyle(
                color: controller.selectedJobType == type
                    ? AppColors.white
                    : AppColors.btnColor,
              ),
              label: Text(type),
              selected: controller.selectedJobType == type,
              onSelected: (_) => controller.selectJobType(type),
            );
          }).toList(),
        ),
      ],
    );
  }
}
