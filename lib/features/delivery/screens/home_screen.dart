import 'package:flutter/material.dart';
import 'package:mdw/core/themes/styles.dart';
import 'package:provider/provider.dart';

import '../controller/home_controller.dart';
import '../widgets/earnings_card.dart';
import '../widgets/orders_card.dart';
import '../widgets/welcome_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onChangeIndex});

  final Function(int) onChangeIndex;

  // LoginUserModel? rider;
  Widget _buildSliverContent(HomeController controller) {
    final hasOrders =
        !controller.ordersListEmpty && controller.ordersList != null;
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: WelcomeCard()),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: Text(
            controller.message.isNotEmpty ? controller.message : "Progress",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 20,
              fontWeight:
                  controller.message.isNotEmpty ? null : FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 15)),
        if (hasOrders)
          SliverToBoxAdapter(child: EarningsCard(controller: controller)),
        if (hasOrders) const SliverToBoxAdapter(child: SizedBox(height: 15)),
        if (hasOrders)
          SliverToBoxAdapter(
            child: OrdersCard(
              controller: controller,
              onTap: () => onChangeIndex(1),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context);

    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
        child: RefreshIndicator(
          onRefresh: homeController.initialize,
          // (() async {
          //   await getData();
          // }),
          child: _buildSliverContent(homeController),
        ),
      ),
    );
  }
}
