import 'package:flutter/material.dart';

class AppColors {
  static const white = Colors.white;
  static const transparent = Colors.transparent;
  static const black = Colors.black;
  static const grey = Colors.grey;
  static const red = Colors.red;
  static const green = Color(0xff4cca38);
  static const lightGreen = Color(0xffa5eb61);
  static const inactiveDotColor = Color(0xffdff8c3);
  static const containerColor = Color(0xffECE6F0);
  static const containerBorderColor = Color(0xffE1E6EF);
  static const iconColor = Color(0xff364B63);
  static const rupeesContainerColor = Color(0xffF0F5FF);
  static const btnColor = Color(0xff46CA36);
  static const splashColor = Color(0xffff4b92);
  static var customDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      width: 1,
      color: AppColors.containerBorderColor,
    ),
  );
}
