import 'package:flutter/material.dart';

import 'custom_container.dart';

class OrdersCard extends StatelessWidget {
  const OrdersCard({
    super.key,
    // required this.controller,
    required this.onTap,
  });

  // final HomeController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // final count =
    //     AppFunctions.countTodayPackedOrders(controller.ordersList!.orders);
    return CustomContainer(
      head: "Orders",
      // value: count.toString(),
      showArrow: true,
      onTap: onTap,
    );
  }
}
