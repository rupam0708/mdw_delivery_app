// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mdw/features/auth/models/login_user_model.dart';
import 'package:mdw/features/delivery/controller/order_details_controller.dart';
import 'package:mdw/features/delivery/models/orders_model.dart';
import 'package:mdw/features/delivery/models/prev_orders_model.dart';
import 'package:mdw/features/delivery/widgets/build_mark_as_arrived_button.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/constant.dart';
import '../../../core/themes/styles.dart';
import '../../auth/screens/code_verification_screen.dart';
import '../widgets/build_enter_code_button.dart';
import '../widgets/build_order_details_card.dart';
import '../widgets/build_product_details.dart';
import '../widgets/build_view_map_button.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({
    super.key,
    this.order,
    this.prevOrder,
    this.rider,
  });

  final Order? order;
  final PreviousOrder? prevOrder;
  final LoginUserModel? rider;

  // bool isPinVerified = false, isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderDetailsController(order: order, prevOrder: prevOrder),
      child: _OrderDetailsView(),
    );
  }
}

class _OrderDetailsView extends StatelessWidget {
  const _OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<OrderDetailsController>(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: false,
        title: CustomAppBarTitle(
          title: "#${controller.orderId}",
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: CustomScrollView(
          physics: AppConstant.physics,
          slivers: [
            buildOrderDetailsCard(controller),
            const SliverToBoxAdapter(child: SizedBox(height: 15)),
            buildViewMapButton(context, controller),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            buildProductDetails(controller),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            buildMarkAsArrivedButton(context, controller),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            if (controller.isCurrentOrder)
              buildEnterCodeButton(context, controller),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      )),
    );
  }
}
