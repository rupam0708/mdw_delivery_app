import 'package:flutter/material.dart';
import 'package:mdw/features/delivery/controller/orders_controller.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/constant.dart';
import '../../../core/themes/styles.dart';
import '../../auth/screens/code_verification_screen.dart';
import '../widgets/build_current_orders.dart';
import '../widgets/build_loading_indicator.dart';
import '../widgets/build_previous_orders.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({
    super.key,
    this.type,
    this.message,
  });

  final String? message;

  final int? type;

  // OrdersListModel? ordersList;
  @override
  Widget build(BuildContext context) {
    // final controller = Provider.of<OrdersController>(context);
    return ChangeNotifierProvider(
      create: (_) => OrdersController(context, type: type),
      child: _OrderScreenBody(),
    );
  }
}

class _OrderScreenBody extends StatelessWidget {
  const _OrderScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<OrdersController>(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.green,
          onRefresh: () => controller.getOrders(),
          child: CustomScrollView(
            physics: AppConstant.physics,
            slivers: [
              if (controller.tokenInvalid)
                SliverToBoxAdapter(
                  child: CustomUpperPortion(
                    head:
                        "Token Invalid. Logging out in ${controller.timer} seconds",
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 15)),
              if (controller.type == 1)
                SliverAppBar(
                  backgroundColor: AppColors.white,
                  leading: BackButton(color: AppColors.green),
                  title: CustomAppBarTitle(
                    title: controller.type == 1 ? "Previous Orders" : "Orders",
                  ),
                ),
              SliverToBoxAdapter(
                child: CustomUpperPortion(
                  head: controller.message.isNotEmpty
                      ? controller.message
                      : controller.type == 1
                          ? "View previously delivered orders."
                          : "View orders you need to deliver.",
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 15)),
              if (controller.type == null &&
                  controller.ordersList == null &&
                  !controller.ordersListEmpty)
                buildLoadingIndicator(),
              if (controller.type == 1 &&
                  controller.prevOrdersList == null &&
                  !controller.prevOrdersListEmpty)
                buildLoadingIndicator(),
              if (controller.ordersList != null) buildCurrentOrders(controller),
              if (controller.prevOrdersList != null)
                buildPreviousOrders(controller),
              const SliverToBoxAdapter(child: SizedBox(height: 15)),
            ],
          ),
        ),
      ),
    );
  }
}
