import 'package:flutter/cupertino.dart';
import 'package:mdw/features/delivery/models/orders_model.dart';

import '../../../core/themes/styles.dart';
import '../controller/order_details_controller.dart';

Widget buildProductDetails(OrderDetailsController controller) {
  return SliverToBoxAdapter(
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.containerBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Product Details",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.green)),
          const SizedBox(height: 10),
          Column(
            children: (controller.items as List<Item>)
                .asMap()
                .entries
                .map<Widget>((entry) {
              final index = entry.key;
              final item = entry.value;

              return Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 30,
                          child: Center(child: Text(item.productName)),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          height: 30,
                          child: Center(
                            child: Text(
                              "₹${item.amount}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.green,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 30,
                          child: const Center(child: Text("Quantity: ")),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          height: 30,
                          child: Center(
                            child: Text(
                              item.quantity.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.green,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (index <
                        controller.items.length -
                            1) // ✅ divider only between items
                      Container(
                        height: 1,
                        decoration: const BoxDecoration(
                          color: AppColors.containerColor,
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ),
  );
}
