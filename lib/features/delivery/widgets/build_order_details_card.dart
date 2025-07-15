import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/services/app_function_services.dart';
import '../../../core/themes/styles.dart';
import '../controller/order_details_controller.dart';

Widget buildOrderDetailsCard(OrderDetailsController controller) {
  return SliverToBoxAdapter(
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.containerBorderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7),
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: AppColors.green,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.green.withOpacity(0.6),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat("dd MMM yyyy, hh:mm a")
                      .format(controller.orderDate),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text("Name: ${controller.customerName}",
                    style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 5),
                Text("Phone No: ${controller.formattedPhoneNumber}",
                    style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 5),
                Text("Address: ${controller.customerAddress}",
                    style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 5),
                Text(
                  "Bin: ${controller.bin}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppFunctions.getColorFromString(controller.binColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
