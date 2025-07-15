import 'package:flutter/material.dart';

import '../../../shared/widgets/custom_btn.dart';
import '../controller/order_details_controller.dart';

Widget buildViewMapButton(
    BuildContext context, OrderDetailsController controller) {
  return SliverToBoxAdapter(
    child: SizedBox(
      height: 45,
      child: CustomBtn(
        text: "View On Map",
        horizontalMargin: 0,
        horizontalPadding: 0,
        verticalPadding: 10,
        onTap: () => controller.viewOnMap(context),
      ),
    ),
  );
}
