import 'package:flutter/material.dart';
import 'package:mdw/core/themes/styles.dart';

import '../../../../../core/services/app_function_services.dart';
import '../../../controllers/registration_controller.dart';
import '../../../widgets/custom_text_field.dart';

class StepVehicleDetails extends StatelessWidget {
  final RegistrationController controller;

  const StepVehicleDetails({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Rider Vehicle Type",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: controller.vehicleTypes.map((type) {
            return ChoiceChip(
              selectedColor: AppColors.btnColor,
              checkmarkColor: controller.selectedVehicleType == type
                  ? AppColors.white
                  : AppColors.btnColor,
              labelStyle: TextStyle(
                color: controller.selectedVehicleType == type
                    ? AppColors.white
                    : AppColors.btnColor,
              ),
              label: Text(type),
              selected: controller.selectedVehicleType == type,
              onSelected: (_) => controller.selectVehicleType(type),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        CustomTextField(
          textEditingController: controller.vNumberController,
          head: "Rider Vehicle Number",
          hint: "XX-XX-XXXX",
          keyboard: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          validator: AppFunctions.indianVehicleNumberValidator,
        ),
      ],
    );
  }
}
