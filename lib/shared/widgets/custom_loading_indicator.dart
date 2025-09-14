import 'package:flutter/material.dart';

import '../../core/themes/styles.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key, this.strokeWidth});

  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.green,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
