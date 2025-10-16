import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mdw/core/services/app_function_services.dart';

import '../../../core/services/storage_services.dart';
import '../../../core/themes/styles.dart';
import '../../../shared/utils/snack_bar_utils.dart';
import '../../../shared/widgets/custom_btn.dart';
import '../../../shared/widgets/custom_loading_indicator.dart';
import '../controller/home_controller.dart';
import '../models/orders_model.dart';

class GoToBinScreen extends StatefulWidget {
  const GoToBinScreen({
    super.key,
    required this.orders,
    required this.controller,
    required this.isScheduledOrders,
  });

  final List<Order> orders;
  final HomeController controller;
  final bool isScheduledOrders;

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

    // 🧩 Group orders by delivery date & time range if scheduled
    Map<String, List<Order>> groupedOrders = {};
    if (widget.isScheduledOrders) {
      for (final order in widget.orders) {
        final deliveryDate =
            order.scheduledDeliveryDate ?? "Unknown Date"; // e.g. "2025-10-16"
        final deliveryTime = order.scheduledDeliveryTimeRange ??
            "Unknown Time"; // e.g. "10AM - 12PM"
        final key = "$deliveryDate | $deliveryTime";
        groupedOrders.putIfAbsent(key, () => []).add(order);
      }
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
        padding: const EdgeInsets.only(bottom: 20),
        child: !widget.controller.packedLoading
            ? CustomBtn(
                onTap: (distance <= 100)
                    ? (() async {
                        widget.controller.togglePackedLoading();

                        List<String> ids = [];

                        for (final order in widget.orders) {
                          final success = await widget.controller
                              .markOrderAsPacked(order.orderId);
                          if (success != null) {
                            if (success.statusCode == 200) {
                              ids.add(order.orderId);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                AppSnackBar().customizedAppSnackBar(
                                  message: "${order.orderId} is successful",
                                  context: context,
                                ),
                              );
                            } else {
                              Map<String, dynamic> resJson =
                                  jsonDecode(success.body);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                AppSnackBar().customizedAppSnackBar(
                                  message: resJson["message"],
                                  context: context,
                                ),
                              );
                            }
                          }
                        }

                        await StorageServices.setLastOrderIDs(ids);
                        if (mounted) widget.controller.togglePackedLoading();
                        Navigator.pop(context);
                      })
                    : (() {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          AppSnackBar().customizedAppSnackBar(
                            message: "Go nearer to the warehouse",
                            context: context,
                          ),
                        );
                      }),
                horizontalMargin: 20,
                text: "Start Delivery",
              )
            : const CustomLoadingIndicator(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  widget.isScheduledOrders
                      ? "Scheduled Orders grouped by delivery slot"
                      : "${widget.orders.length <= 1 ? "Order" : "Orders"} is getting packed",
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 5)),

            // 🧩 Show grouped or normal orders
            if (widget.isScheduledOrders)
              ...groupedOrders.entries.map((entry) {
                final key = entry.key; // e.g., "2025-10-16 | 10AM - 12PM"
                final parts = key.split('|');
                final dateStr = parts[0].trim(); // "2025-10-16"
                final timeRange = parts.length > 1 ? parts[1].trim() : "";

                DateTime parsedDate;
                try {
                  parsedDate = DateTime.parse(dateStr);
                } catch (_) {
                  parsedDate = DateTime.now(); // fallback
                }

                final formattedDate =
                    DateFormat('EEEE, dd MMMM, yyyy').format(parsedDate);
                final headerText = timeRange.isNotEmpty
                    ? "$formattedDate | $timeRange"
                    : formattedDate;

                final orders = entry.value;

                return SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        headerText,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.green,
                          fontSize: 14,
                        ),
                      ),
                      ...orders.map((order) => _buildOrderCard(order)).toList(),
                    ],
                  ),
                );
              }).toList()
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, idx) {
                    final order = widget.orders[idx];
                    return _buildOrderCard(order);
                  },
                  childCount: widget.orders.length,
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 15)),
          ],
        ),
      ),
    );
  }

  /// 🧩 Reusable widget for order details
  Widget _buildOrderCard(Order order) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.containerBorderColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _infoRow("OrderID:", order.orderId),
          _infoRow("Name:", order.customer.name),
          _infoRow("Phone No.:", order.customer.phoneNumber.toString()),
          _infoRow("Address:",
              order.customer.address.toString().replaceAll(', ', '\n')),
          _infoRow("Bin Number:", order.binNumber.toString()),
          _infoRow("Bin Color:", order.binColor),
          _infoRow("Status:", order.status),
          _infoRow("Payment Mode:", order.paymentMode ?? ""),
          const SizedBox(height: 15),
          _buildProductDetails(order),
          const SizedBox(height: 25),
          _infoRow("Total:", "₹${order.amount}", isBold: true, fontSize: 17),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value,
      {bool isBold = false, double fontSize = 15}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.black,
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppFunctions.getColorFromString(value),
                fontSize: fontSize,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails(Order order) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Product Details",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 3),
          Column(
            children: order.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(item.productName)),
                      Text(
                        "₹${item.amount}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.green,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  if (index != order.items.length - 1) ...[
                    const SizedBox(height: 10),
                    Container(height: 1, color: AppColors.containerBorderColor),
                    const SizedBox(height: 10),
                  ],
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
