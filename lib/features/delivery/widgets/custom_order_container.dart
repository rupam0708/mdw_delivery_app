import 'package:flutter/material.dart';

import '../../../core/themes/styles.dart';
import '../../../shared/widgets/custom_divider.dart';

class CustomOrderContainer extends StatelessWidget {
  const CustomOrderContainer({
    super.key,
    this.index,
    this.middleWidget,
    required this.onTapContainer,
    required this.name,
    required this.phone,
    required this.address,
    this.maxLines,
    this.buttons,
    this.height,
    required this.id,
    required this.date,
    required this.time,
    required this.status,
    required this.amount,
  });

  final VoidCallback onTapContainer;
  final int? index, maxLines;
  final Widget? middleWidget, buttons;
  final String name, phone, address, id, date, time, status, amount;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapContainer,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.only(
          top: 15,
        ),
        decoration: AppColors.customDecoration,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "ID: $id",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: AppColors.iconColor,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text(
                        date,
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.green.withValues(alpha: 0.6),
                          // Shadow color
                          spreadRadius: 2,
                          // Spread radius
                          blurRadius: 5,
                          // Blur radius
                          offset: Offset(0, 0), // Offset in X and Y direction
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: Text(
                      address,
                      style: TextStyle(
                        color: AppColors.black,
                        overflow: TextOverflow.clip,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            CustomDivider(),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    status.replaceAll("_", " "),
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_filled_rounded,
                        color: AppColors.iconColor,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text(
                        time,
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.rupeesContainerColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.payments_rounded,
                    color: AppColors.green,
                    size: 25,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "\₹$amount",
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
