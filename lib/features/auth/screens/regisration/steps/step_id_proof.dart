import 'package:flutter/material.dart';

import '../../../../../core/services/app_function_services.dart';
import '../../../../../core/themes/styles.dart';
import '../../../controllers/registration_controller.dart';
import '../../../widgets/custom_text_field.dart';

class StepIdProof extends StatelessWidget {
  final RegistrationController controller;

  const StepIdProof({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Rider ID Proof Type",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: controller.idProofTypes.map((type) {
            return ChoiceChip(
              selectedColor: AppColors.btnColor,
              checkmarkColor: controller.selectedIdProofType == type
                  ? AppColors.white
                  : AppColors.btnColor,
              labelStyle: TextStyle(
                color: controller.selectedIdProofType == type
                    ? AppColors.white
                    : AppColors.btnColor,
              ),
              label: Text(type),
              selected: controller.selectedIdProofType == type,
              onSelected: (_) => controller.selectIdProofType(type),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        CustomTextField(
          textEditingController: controller.idProofUrlController,
          head: "Rider ID Proof URL",
          hint: "Paste your ID proof link",
          keyboard: TextInputType.url,
          validator: AppFunctions.urlValidator,
        ),
      ],
    );
  }
}
