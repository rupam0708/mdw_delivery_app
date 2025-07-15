import 'package:flutter/material.dart';

import '../../../../../core/services/app_function_services.dart';
import '../../../../../core/themes/styles.dart';
import '../../../widgets/custom_text_field.dart';

class StepPassword extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscure;
  final bool confirmObscure;
  final VoidCallback onToggleObscure;
  final VoidCallback onToggleConfirmObscure;

  const StepPassword({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscure,
    required this.confirmObscure,
    required this.onToggleObscure,
    required this.onToggleConfirmObscure,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          textEditingController: passwordController,
          head: "Rider Login Password",
          hint: "********",
          keyboard: TextInputType.visiblePassword,
          obscure: obscure,
          suffix: GestureDetector(
            onTap: onToggleObscure,
            child: Icon(
              obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded,
              color: AppColors.black.withAlpha(100),
            ),
          ),
          validator: AppFunctions.passwordValidator,
        ),
        const SizedBox(height: 15),
        CustomTextField(
          textEditingController: confirmPasswordController,
          head: "Confirm Rider Login Password",
          hint: "********",
          keyboard: TextInputType.visiblePassword,
          obscure: confirmObscure,
          suffix: GestureDetector(
            onTap: onToggleConfirmObscure,
            child: Icon(
              confirmObscure
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              color: AppColors.black.withAlpha(100),
            ),
          ),
          validator: (value) {
            if (passwordController.text.trim() !=
                confirmPasswordController.text.trim()) {
              return "Password is not matching";
            }
            return null;
          },
        ),
      ],
    );
  }
}
