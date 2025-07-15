import 'package:flutter/material.dart';
import 'package:mdw/shared/utils/snack_bar_utils.dart';

import '../../features/auth/controllers/registration_controller.dart';

class SnackBarUtils {
  static void showError(
    BuildContext context,
    String message,
    RegistrationController controller,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBar().customizedAppSnackBar(
        message: message,
        context: context,
      ),
    );

    controller.setLoading(false);
  }
}
