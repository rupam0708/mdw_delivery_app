import 'package:flutter/material.dart';

import '../../../core/themes/styles.dart';

class build_stepper_indicator extends StatelessWidget {
  const build_stepper_indicator({
    super.key,
    required this.step,
    required this.child,
  });

  final int step;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColors.green,
      child: child,
    );
  }
}
