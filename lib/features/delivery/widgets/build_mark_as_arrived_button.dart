import 'package:flutter/material.dart';

import '../../../core/themes/styles.dart';
import '../../../shared/widgets/custom_btn.dart';
import '../controller/order_details_controller.dart';

Widget buildMarkAsArrivedButton(
    BuildContext context, OrderDetailsController controller) {
  return SliverToBoxAdapter(
    child: CustomBtn(
      height: 45,
      text: "Mark as arrived",
      color: AppColors.lightGreen,
      textColor: AppColors.black,
      onTap: (() {}),
      horizontalMargin: 0,
      verticalPadding: 7,
      fontSize: 12,
      horizontalPadding: 15,
    ),
  );
}
