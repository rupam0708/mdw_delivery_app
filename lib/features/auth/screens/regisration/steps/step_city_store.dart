import 'package:flutter/material.dart';

import '../../../../../core/themes/styles.dart';
import '../../../controllers/registration_controller.dart';

class StepCityAndStore extends StatelessWidget {
  const StepCityAndStore({
    super.key,
    required this.controller,
  });

  final RegistrationController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Select City",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: controller.cityList.map((city) {
            final isEnabled = city == 'Kolkata';

            return ChoiceChip(
              selectedColor: AppColors.btnColor,
              disabledColor: AppColors.containerBorderColor.withOpacity(0.3),
              checkmarkColor: AppColors.white,
              labelStyle: TextStyle(
                color: controller.selectedCity == city
                    ? AppColors.white
                    : isEnabled
                        ? AppColors.btnColor
                        : Colors.grey,
              ),
              label: Text(city),
              selected: controller.selectedCity == city,
              onSelected: isEnabled
                  ? (_) => controller.selectCity(city)
                  : null, // disables tap
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        const Text(
          "Select Store",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: controller.storeList.map((store) {
            final isEnabled = store == 'NewTown';

            return ChoiceChip(
              selectedColor: AppColors.btnColor,
              disabledColor: AppColors.containerBorderColor.withOpacity(0.3),
              checkmarkColor: AppColors.white,
              labelStyle: TextStyle(
                color: controller.selectedStore == store
                    ? AppColors.white
                    : isEnabled
                        ? AppColors.btnColor
                        : Colors.grey,
              ),
              label: Text(store),
              selected: controller.selectedStore == store,
              onSelected:
                  isEnabled ? (_) => controller.selectStore(store) : null,
            );
          }).toList(),
        ),
      ],
    );
  }
}
