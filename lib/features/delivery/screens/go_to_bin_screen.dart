import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mdw/features/delivery/models/orders_model.dart';

import '../../../core/services/storage_services.dart';
import '../../../core/themes/styles.dart';
import '../../../shared/utils/snack_bar_utils.dart';
import '../../../shared/widgets/custom_btn.dart';
import '../../../shared/widgets/custom_loading_indicator.dart';
import '../controller/home_controller.dart';

class GoToBinScreen extends StatefulWidget {
  const GoToBinScreen({
    super.key,
    required this.activeOrders,
    required this.controller,
  });

  final List<Order> activeOrders;
  final HomeController controller;

  @override
  State<GoToBinScreen> createState() => _GoToBinScreenState();
}

class _GoToBinScreenState extends State<GoToBinScreen> {
  @override
  Widget build(BuildContext context) {
    final currentPosition = widget.controller.currentPosition;
    int distance = 0;
    if (currentPosition != null) {
      distance = widget.controller.calculateDistanceInKm(
        currentPosition.latitude,
        currentPosition.longitude,
        22.5354273,
        88.360297,
      );
    }
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Go to bin"),
        backgroundColor: AppColors.white,
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        height: 75,
        padding: EdgeInsets.only(bottom: 20),
        child: !widget.controller.packedLoading
            ? CustomBtn(
                onTap: (distance <= 100)
                    ? (() async {
                        widget.controller
                            .togglePackedLoading(); // explicitly set to true

                        List<String> ids = [];

                        for (final order in widget.activeOrders) {
                          final success = await widget.controller
                              .markOrderAsPacked(order.orderId);
                          if (success != null) {
                            if (success.statusCode == 200) {
                              ids.add(order.orderId);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  AppSnackBar().customizedAppSnackBar(
                                      message: "${order.orderId} is successful",
                                      context: context));
                            } else {
                              Map<String, dynamic> resJson =
                                  jsonDecode(success.body);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  AppSnackBar().customizedAppSnackBar(
                                      message: resJson["message"],
                                      context: context));
                            }
                          }
                        }

                        await StorageServices.setLastOrderIDs(ids);
                        if (mounted) {
                          widget.controller.togglePackedLoading();
                        }
                        Navigator.pop(context);
                      })
                    : (() {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(AppSnackBar()
                            .customizedAppSnackBar(
                                message: "Go nearer to the warehouse",
                                context: context));
                      }),
                horizontalMargin: 20,
                text: "Start Delivery",
              )
            : CustomLoadingIndicator(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  "${widget.activeOrders.length <= 1 ? "Order" : "Orders"} is getting packed",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 5),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, idx) {
                  final Order order = widget.activeOrders[idx];

                  return Container(
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      // color: AppColors.containerColor,
                      border: Border.all(color: AppColors.containerBorderColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "OrderID: ",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              order.orderId,
                              style: TextStyle(
                                color: AppColors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Name: ",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              order.customer.name,
                              style: TextStyle(
                                color: AppColors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Phone No.: ",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              order.customer.phoneNumber.toString(),
                              style: TextStyle(
                                color: AppColors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Address: ",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              order.customer.address
                                  .toString()
                                  .replaceAll(', ', '\n'),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: AppColors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bin Number: ",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              order.binNumber.toString(),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: AppColors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bin Color: ",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              order.binColor,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: AppColors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Status: ",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              order.status,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: AppColors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          // padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            // border: Border.all(
                            //     color: AppColors.containerBorderColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Product Details",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.green)),
                              const SizedBox(height: 3),
                              Column(
                                children:
                                    order.items.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final item = entry.value;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Product row
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.productName,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                          Text(
                                            "₹${item.amount}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),

                                      // Quantity row
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Quantity:"),
                                          Text(
                                            item.quantity.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.green,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Divider except after last item
                                      if (index != order.items.length - 1) ...[
                                        const SizedBox(height: 10),
                                        Container(
                                          height: 1,
                                          color: AppColors.containerBorderColor,
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ],
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total: ",
                              style: TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              "₹${order.amount}",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: AppColors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                childCount: widget.activeOrders.length,
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 15)),

            // if (!widget.controller.packedLoading
            //     // &&
            //     // order.status != "Packed"
            //     )
            //   SliverToBoxAdapter(child: SizedBox(height: 15)),
            // if (!widget.controller.packedLoading
            //     // &&
            //     // order.status != "Packed"
            //     )
            //   SliverToBoxAdapter(
            //     child: CustomBtn(
            //       onTap: (distance <= 100)
            //           ? (() async {
            //               widget.controller
            //                   .togglePackedLoading(); // explicitly set to true
            //
            //               List<String> ids = [];
            //
            //               for (final order in widget.activeOrders) {
            //                 final success = await widget.controller
            //                     .markOrderAsPacked(order.orderId);
            //                 if (success != null) {
            //                   if (success.statusCode == 200) {
            //                     ids.add(order.orderId);
            //                     ScaffoldMessenger.of(context).clearSnackBars();
            //                     ScaffoldMessenger.of(context).showSnackBar(
            //                         AppSnackBar().customizedAppSnackBar(
            //                             message:
            //                                 "${order.orderId} is successful",
            //                             context: context));
            //                   } else {
            //                     Map<String, dynamic> resJson =
            //                         jsonDecode(success.body);
            //                     ScaffoldMessenger.of(context).clearSnackBars();
            //                     ScaffoldMessenger.of(context).showSnackBar(
            //                         AppSnackBar().customizedAppSnackBar(
            //                             message: resJson["message"],
            //                             context: context));
            //                   }
            //                 }
            //               }
            //
            //               await StorageServices.setLastOrderIDs(ids);
            //               if (mounted) {
            //                 widget.controller.togglePackedLoading();
            //               }
            //             })
            //           : (() {
            //               ScaffoldMessenger.of(context).clearSnackBars();
            //               ScaffoldMessenger.of(context).showSnackBar(
            //                   AppSnackBar().customizedAppSnackBar(
            //                       message: "Go nearer to the warehouse",
            //                       context: context));
            //             }),
            //       horizontalMargin: 0,
            //       text: "Go to bin",
            //     ),
            //   ),
            // if (widget.controller.packedLoading) CustomLoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
