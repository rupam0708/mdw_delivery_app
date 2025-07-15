import 'package:flutter/cupertino.dart';

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
            children: controller.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        height: 30,
                        child: Center(child: Text(item.productName))),
                    const SizedBox(width: 5),
                    SizedBox(
                      height: 30,
                      child: Center(
                        child: Text("₹${item.amount}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.green,
                            )),
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
