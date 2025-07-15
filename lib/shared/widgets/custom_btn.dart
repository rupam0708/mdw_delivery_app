import 'package:flutter/material.dart';

import '../../core/themes/styles.dart';

class CustomBtn extends StatelessWidget {
  const CustomBtn({
    super.key,
    required this.onTap,
    required this.text,
    this.fontSize,
    this.horizontalMargin,
    this.verticalPadding,
    this.horizontalPadding,
    this.width,
    this.height,
    this.child,
    this.color,
    this.textColor,
  });

  final VoidCallback onTap;
  final String text;
  final double? fontSize,
      horizontalMargin,
      verticalPadding,
      horizontalPadding,
      width,
      height;
  final Widget? child;
  final Color? color, textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin ?? 45),
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(
            vertical: verticalPadding ?? 15,
            horizontal: horizontalPadding ?? 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color ?? AppColors.btnColor,
        ),
        child: child ??
            Center(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textColor ?? AppColors.white,
                  fontSize: fontSize,
                ),
              ),
            ),
      ),
    );
  }
}
