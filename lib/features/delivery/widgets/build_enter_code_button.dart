import 'package:flutter/material.dart';

import '../../../core/themes/styles.dart';
import '../../../shared/widgets/custom_btn.dart';
import '../../auth/screens/code_verification_screen.dart';
import '../controller/order_details_controller.dart';
import '../screens/payment_screen.dart';

Widget buildMarkDeliveredButton(
    BuildContext context, OrderDetailsController controller) {
  return SliverToBoxAdapter(
    child: CustomBtn(
      height: 45,
      text: "Mark as delivered",
      color: AppColors.red,
      onTap: () {
        if (controller.order != null) {
          final mode = controller.order?.paymentMode;
          if (mode != null) {
            if (mode == "COD") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((ctx) => PaymentScreen(order: controller.order!)),
                ),
              );
            } else {
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
                    order: controller.order,
                  ),
                ),
              );
            }
          }
        }
      },
      horizontalMargin: 0,
      verticalPadding: 7,
      fontSize: 12,
      horizontalPadding: 15,
    ),
  );
}
