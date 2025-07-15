import 'package:flutter/material.dart';

import '../../../core/themes/styles.dart';
import '../../../shared/widgets/custom_btn.dart';
import '../../auth/screens/code_verification_screen.dart';
import '../controller/order_details_controller.dart';

Widget buildEnterCodeButton(
    BuildContext context, OrderDetailsController controller) {
  return SliverToBoxAdapter(
    child: CustomBtn(
      height: 45,
      text: "Mark as delivered",
      color: AppColors.red,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CodeVerificationScreen(
              head: "Code Verification",
              upperText:
                  "Enter the code to confirm the delivery\nof the order.",
              type: 1,
              btnText: "Confirm Order",
              orderId: controller.orderId,
            ),
          ),
        );
      },
      horizontalMargin: 0,
      verticalPadding: 7,
      fontSize: 12,
      horizontalPadding: 15,
    ),
  );
}
