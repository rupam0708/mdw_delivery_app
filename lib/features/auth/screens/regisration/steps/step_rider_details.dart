import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../../../../core/services/app_function_services.dart';
import '../../../widgets/custom_text_field.dart';

class StepRiderDetails extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  const StepRiderDetails({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          textEditingController: nameController,
          head: "Name",
          hint: "Enter Your Name",
          keyboard: TextInputType.name,
          validator: AppFunctions.nameValidator,
        ),
        const SizedBox(height: 15),
        CustomTextField(
          textEditingController: emailController,
          head: "Email",
          hint: "johndoe@example.com",
          keyboard: TextInputType.emailAddress,
          validator: (val) {
            if (!EmailValidator.validate(val?.trim() ?? '')) {
              return "Please check the email";
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        CustomTextField(
          textEditingController: phoneController,
          head: "Phone Number",
          hint: "XXXXX-XXXXX",
          keyboard: TextInputType.phone,
          validator: AppFunctions.phoneNumberValidator,
        ),
        const SizedBox(height: 15),
        CustomTextField(
          textEditingController: addressController,
          head: "Address",
          hint: "Enter Your Address",
          keyboard: TextInputType.streetAddress,
          isMultiline: true,
          validator: AppFunctions.addressValidator,
        ),
      ],
    );
  }
}
