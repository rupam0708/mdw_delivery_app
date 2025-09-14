import 'package:flutter/material.dart';
import 'package:mdw/shared/widgets/custom_loading_indicator.dart';

import '../../../shared/widgets/custom_btn.dart';
import '../controller/order_details_controller.dart';

Widget buildViewMapButton(
    BuildContext context, OrderDetailsController controller) {
  return SliverToBoxAdapter(
    child: SizedBox(
      height: 45,
      child: controller.isLocationLoading
          ? CustomLoadingIndicator()
          : CustomBtn(
              text: "View On Map",
              horizontalMargin: 0,
              horizontalPadding: 0,
              verticalPadding: 10,
              onTap: () => controller.viewOnMap(context),
            ),
    ),
  );
}
