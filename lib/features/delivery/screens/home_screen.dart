import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mdw/core/themes/styles.dart';
import 'package:mdw/features/delivery/screens/go_to_bin_screen.dart';
import 'package:mdw/shared/utils/snack_bar_utils.dart';
import 'package:mdw/shared/widgets/custom_btn.dart';
import 'package:mdw/shared/widgets/custom_loading_indicator.dart';
import 'package:provider/provider.dart';

import '../../../core/services/storage_services.dart';
import '../../auth/models/login_user_model.dart';
import '../../auth/screens/login/login_screen.dart';
import '../controller/home_controller.dart';
import '../models/orders_model.dart';
import '../widgets/earnings_card.dart';
import '../widgets/orders_card.dart';
import '../widgets/welcome_card.dart';

extension OrdersListModelX on OrdersListModel {
  /// Returns only today's orders with status: Received, Confirmed, or Packing
  List<Order> getTodayOrders() {
    final now = DateTime.now();
    const allowedStatuses = ["Received", "Confirmed", "Packing", "Packed"];

    return orders.where((order) {
      final date = order.createdAt; // or order.orderDate if you prefer
      final isToday = date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;

      return isToday && allowedStatuses.contains(order.status);
    }).toList();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onChangeIndex});

  final Function(int) onChangeIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late LoginUserModel? rider;
  bool hasLastIDs = false;

  getRider() async {
    final String? temp = await StorageServices.getLoginUserDetails();
    if (temp != null) {
      rider = LoginUserModel.fromRawJson(temp);
      log(rider!.token);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getRider();
    Future.microtask(() {
      final controller = context.read<HomeController>();
      controller.initialize(); // 🚀 Start location + other init
      _checkLastIds(controller);
    });
  }

  Future<void> _checkLastIds(HomeController controller) async {
    final result = await StorageServices.hasLastOrderIDs();
    log(result.toString());
    setState(() {
      hasLastIDs = result;
    });
  }

  // LoginUserModel? rider;
  Widget _buildSliverContent(HomeController controller) {
    // bool hasLastIds = false;
    // Future.delayed(Duration.zero, (() async {
    //   hasLastIds = await controller.hasLastIDs();
    // }));
    // final hasOrders =
    //     !controller.ordersListEmpty && controller.ordersList != null;
    // List<Order> activeOrders = [];
    // if (hasOrders) {
    //   activeOrders = controller.ordersList!.getTodayOrders();
    // }
    // final currentPosition = controller.currentPosition;
    // int distance = 0;
    // if (currentPosition != null) {
    //   distance = controller.calculateDistanceInKm(currentPosition.latitude,
    //       currentPosition.longitude, 22.5354273, 88.360297);
    // }
    // if (distance <= 100 && !hasLastIds && activeOrders.isNotEmpty) {
    //   Future.delayed(Duration.zero, (() {
    //     activeOrders.map((order) async {
    //       await HapticFeedback.mediumImpact();
    //     });
    //   }));
    // }

    final hasOrders = !controller.ordersListEmpty &&
        controller.ordersList != null &&
        controller.earnings != null;
    final List<Order> activeOrders =
        hasOrders ? controller.ordersList!.getTodayOrders() : [];

    final currentPosition = controller.currentPosition;
    int distance = 0;
    if (currentPosition != null) {
      distance = controller.calculateDistanceInKm(
        currentPosition.latitude,
        currentPosition.longitude,
        22.5354273,
        88.360297,
      );
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   if (distance >= 100 && !hasLastIDs && activeOrders.isNotEmpty) {
    //     for (var order in activeOrders) {
    //       await HapticFeedback.lightImpact();
    //     }
    //   }
    // });

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: WelcomeCard()),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: CustomBtn(
            onTap: (() {
              controller.toggleShift(context);
            }),
            text: "${controller.isShiftActive ? "End" : "Start"} Shift",
            horizontalMargin: 0,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: Text(
            controller.ordersListEmpty ? "No orders found" : "Progress",
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
        if (controller.tokenInvalid)
          SliverToBoxAdapter(
            child: Text(
              "${controller.message.isEmpty ? "Something went wrong." : controller.message} You need to re-login. Logging out in ${controller.timer.toString()} seconds",
              textAlign: TextAlign.center,
            ),
          ),
        if (hasOrders)
          SliverToBoxAdapter(child: EarningsCard(controller: controller)),
        if (hasOrders) const SliverToBoxAdapter(child: SizedBox(height: 15)),
        if (hasOrders)
          SliverToBoxAdapter(
            child: OrdersCard(
              controller: controller,
              onTap: () => widget.onChangeIndex(1),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 15)),
        if (!hasLastIDs && activeOrders.isNotEmpty)
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: (() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((ctx) => GoToBinScreen(
                          activeOrders: activeOrders,
                          controller: controller,
                        )),
                  ),
                );
              }),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.containerBorderColor),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Active ${activeOrders.length <= 1 ? "Order" : "Orders"}",
                          style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          activeOrders.length.toString(),
                          style: TextStyle(
                            color: AppColors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (distance != 0)
          const SliverToBoxAdapter(child: SizedBox(height: 25)),
        if (distance != 0 &&
            !controller.arrivedLoading &&
            controller.rider2 != null &&
            hasLastIDs)
          SliverToBoxAdapter(
            child: CustomBtn(
              onTap: (() async {
                controller.toggleArrivedLoading();

                if (controller.rider2 != null) {
                  // log(controller.rider2!.rider.isBlocked.toString());

                  // await controller.getOrders();

                  final lastOrderIDs = await StorageServices.getLastOrderIDs();

                  List<Order> lastOrders = [];

                  if (lastOrderIDs?.isNotEmpty ?? false) {
                    final idSet = lastOrderIDs!.toSet(); // ✅ faster lookups
                    log(idSet.toString());
                    lastOrders = controller.ordersList!.orders
                        .where((order) => idSet.contains(order.orderId))
                        .toList();
                  }
                  log(lastOrders.length.toString());

                  if (distance <= 100) {
                    if (lastOrders.isNotEmpty) {
                      bool success = false;

                      for (final order in lastOrders) {
                        if (order.orderId.trim().isNotEmpty &&
                            order.status == "Delivered") {
                          final res = await controller
                              .markArrivedAtWarehouse(order.orderId);

                          if (res != null) {
                            if (res.statusCode == 200) {
                              success = true;
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                AppSnackBar().customizedAppSnackBar(
                                  message:
                                      "${order.orderId} successfully arrived at warehouse",
                                  context: context,
                                ),
                              );
                            } else {
                              // Parse error response if available
                              Map<String, dynamic> resJson = {};
                              try {
                                resJson = jsonDecode(res.body);
                              } catch (_) {}
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                AppSnackBar().customizedAppSnackBar(
                                  message: resJson["message"] ??
                                      "Failed to mark ${order.orderId}",
                                  context: context,
                                ),
                              );
                            }
                          }
                        }
                      }

                      // ✅ check mounted before showing snackbar
                      if (success && context.mounted) {
                        // ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          AppSnackBar().customizedAppSnackBar(
                            message: "Successfully arrived at warehouse",
                            context: context,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(AppSnackBar()
                          .customizedAppSnackBar(
                              message: "No active orders", context: context));
                    }
                  } else {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(AppSnackBar()
                        .customizedAppSnackBar(
                            message: "Go nearer to the warehouse",
                            context: context));
                  }
                }

                controller.toggleArrivedLoading();
              }),
              horizontalMargin: 0,
              text: "Arrived at warehouse",
              color: distance > 100 ? AppColors.containerColor : null,
              textColor: distance > 100 ? AppColors.black : null,
            ),
          ),
        if (controller.arrivedLoading) CustomLoadingIndicator(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context);
    // final mainController = Provider.of<MainController>(context);
    homeController.onSessionExpired = () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    };

    // Show message in SnackBar if available
    if (homeController.message.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            AppSnackBar().customizedAppSnackBar(
              message: homeController.message,
              context: context,
            ),
          );
          homeController.message = ""; // reset after showing
        }
      });
    }

    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
        child: RefreshIndicator(
          onRefresh: (() async {
            await homeController.initialize();
            await _checkLastIds(homeController);
            // await mainController.init;
          }),
          child: _buildSliverContent(homeController),
        ),
      ),
    );
  }
}
