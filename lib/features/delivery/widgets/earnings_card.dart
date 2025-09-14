import 'package:flutter/material.dart';
import 'package:mdw/features/delivery/screens/earnings_screen.dart';

import '../controller/home_controller.dart';
import 'custom_container.dart';

class EarningsCard extends StatelessWidget {
  const EarningsCard({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      head: "Earnings",
      value: "₹ ${controller.earnings!.data.totalEarnings}",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((_) => EarningsScreen(
                  homeController: controller,
                )),
          ),
        );
      },
    );
  }
}
