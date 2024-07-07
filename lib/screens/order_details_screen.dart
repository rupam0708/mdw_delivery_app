import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mdw/screens/code_verification_screen.dart';
import 'package:mdw/styles.dart';

import 'onboarding_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({
    super.key,
    required this.orderID,
    required this.name,
    required this.phone,
    required this.address,
  });

  final String orderID, name, phone, address;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool isPinVerified = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: CustomAppBarTitle(
          title: "Order Details",
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            CustomUpperPortion(
              head: "View details of the order\nOrder #${widget.orderID}",
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20),
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 25),
              decoration: BoxDecoration(
                color: AppColors.containerColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Order #2568",
                      style: TextStyle(
                        color: AppColors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        widget.phone,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        widget.address,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children:
                        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
                            .map(
                              (e) => Padding(
                                padding: EdgeInsets.only(top: e == 1 ? 0 : 5),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: Center(child: Text(e.toString())),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: Center(child: Text("Product $e")),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  CustomBtn(
                    onTap: (() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((ctx) => CodeVerificationScreen(
                                head: "Code Verification",
                                upperText:
                                    "Enter the code to confirm the delivery\nof the order.",
                                type: 1,
                                btnText: "Confirm Order",
                              )),
                        ),
                      ).whenComplete(() {
                        log("Refreshed");
                      });
                    }),
                    text: "Enter Code",
                    horizontalMargin: 0,
                    verticalPadding: 7,
                    fontSize: 12,
                    horizontalPadding: 15,
                    width: MediaQuery.of(context).size.width / 2.5,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      )),
    );
  }
}
