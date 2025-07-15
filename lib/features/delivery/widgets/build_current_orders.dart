import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/themes/styles.dart';
import '../controller/orders_controller.dart';
import '../screens/order_details_screen.dart';
import 'custom_order_container.dart';

SliverList buildCurrentOrders(OrdersController controller) {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (context, index) {
        final order = controller.ordersList!.orders[index];
        return OpenContainer(
          transitionType: ContainerTransitionType.fade,
          closedElevation: 0,
          openElevation: 0,
          closedColor: AppColors.transparent,
          openColor: AppColors.transparent,
          transitionDuration: const Duration(milliseconds: 400),
          closedBuilder: (ctx, open) => CustomOrderContainer(
            id: order.orderId,
            name: order.customer.name,
            phone: order.customer.phoneNumber.toString(),
            address: order.customer.address.toString(),
            date: DateFormat("dd/MM/yyyy").format(order.orderDate),
            time: order.turnaroundTime ?? "",
            distance: order.status,
            amount: order.amount.toString(),
            onTapContainer: open,
          ),
          openBuilder: (_, __) => OrderDetailsScreen(order: order),
        );
      },
      childCount: controller.ordersList!.orders.length,
    ),
  );
}
