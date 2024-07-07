import 'package:flutter/material.dart';

import '../styles.dart';

class AppSnackBar {
  SnackBar customizedAppSnackBar({
    required String message,
    required BuildContext context,
  }) {
    return SnackBar(
      margin: EdgeInsets.only(
        bottom: 30,
        left: MediaQuery.of(context).size.width / 10,
        right: MediaQuery.of(context).size.width / 10,
      ),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      backgroundColor: AppColors.white,
      content: Text(
        message,
        style: const TextStyle(
          color: AppColors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
