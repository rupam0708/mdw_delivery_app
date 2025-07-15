import 'package:flutter/material.dart';
import 'package:mdw/core/services/app_function_services.dart';
import 'package:mdw/features/delivery/screens/earnings_screen.dart';

import '../controller/home_controller.dart';
import 'custom_container.dart';

class EarningsCard extends StatelessWidget {
  const EarningsCard({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final amount =
        AppFunctions.sumTodayDeliveredAmounts(controller.ordersList!.orders);
    return CustomContainer(
      head: "Earnings",
      value: "₹ $amount",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((_) => EarningsScreen(
                  currentMonthRange: AppFunctions.getCurrentMonthRange(),
                  currentMonthEarnings: 0,
                  previousMonthEarnings: 6000,
                )),
          ),
        );
      },
    );
  }
}
