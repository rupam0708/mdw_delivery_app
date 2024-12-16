import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:mdw/constant.dart';
import 'package:mdw/screens/code_verification_screen.dart';
import 'package:mdw/services/app_function_services.dart';
import 'package:mdw/styles.dart';
import 'package:permission_handler/permission_handler.dart';

import 'onboarding_screen.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.green,
          onRefresh: (() async {}),
          child: CustomScrollView(
            physics: AppConstant.physics,
            slivers: [
              SliverToBoxAdapter(
                child: CustomUpperPortion(
                    head: "View the order that you need\nto deliver."),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 15,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return OpenContainer(
                        transitionDuration: const Duration(
                          milliseconds: 400,
                        ),
                        tappable: false,
                        closedElevation: 0,
                        openElevation: 0,
                        closedColor: AppColors.transparent,
                        middleColor: AppColors.transparent,
                        openColor: AppColors.transparent,
                        transitionType: ContainerTransitionType.fade,
                        closedBuilder: ((closedCtx, openContainer) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 17),
                            child: CustomOrderContainer(
                              id: "#0CAC6C64",
                              index: index,
                              onTapContainer: openContainer,
                              // onTapContainer: (() {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: ((ctx) =>
                              //           OrderDetailsScreen(orderID: "2568")),
                              //     ),
                              //   );
                              // }),
                              // onTapDetails: (() {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: ((ctx) =>
                              //           OrderDetailsScreen(orderID: "2568")),
                              //     ),
                              //   );
                              // }),
                              name: "Sample Name",
                              phone: "Phone Number",
                              address: "Address",
                              maxLines: 2,
                              buttons: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomBtn(
                                    onTap: openContainer,
                                    text: "View Details",
                                    horizontalMargin: 0,
                                    verticalPadding: 5,
                                    fontSize: 12,
                                    horizontalPadding: 15,
                                    width:
                                        MediaQuery.of(context).size.width / 3.5,
                                  ),
                                  CustomBtn(
                                    onTap: (() async {
                                      if (await Permission
                                          .phone.serviceStatus.isEnabled) {
                                        await AppFunctions.callNumber(
                                            "+919230976362");
                                      } else {
                                        Permission.phone.request();
                                      }
                                    }),
                                    text: "Call",
                                    horizontalMargin: 0,
                                    verticalPadding: 5,
                                    fontSize: 12,
                                    horizontalPadding: 15,
                                    width:
                                        MediaQuery.of(context).size.width / 3.5,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        openBuilder: ((openCtx, _) {
                          return OrderDetailsScreen(
                            orderID: "2568",
                            name: "Sample Name",
                            phone: "Phone Number",
                            address: "Address",
                          );
                        }));
                  },
                  childCount: 5,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomOrderContainer extends StatelessWidget {
  const CustomOrderContainer({
    super.key,
    this.index,
    this.middleWidget,
    required this.onTapContainer,
    required this.name,
    required this.phone,
    required this.address,
    this.maxLines,
    this.buttons,
    this.height,
    required this.id,
  });

  final VoidCallback onTapContainer;
  final int? index, maxLines;
  final Widget? middleWidget, buttons;
  final String name, phone, address, id;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapContainer,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.only(
          top: 15,
        ),
        decoration: AppColors.customDecoration,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "ID: $id",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: AppColors.iconColor,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "01/01/2025",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.green.withOpacity(0.6),
                          // Shadow color
                          spreadRadius: 2,
                          // Spread radius
                          blurRadius: 5,
                          // Blur radius
                          offset: Offset(0, 0), // Offset in X and Y direction
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    address,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            CustomDivider(),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "15.36km",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_filled_rounded,
                        color: AppColors.iconColor,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "17 mins",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.rupeesContainerColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.payments_rounded,
                    color: AppColors.green,
                    size: 25,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "\$1500",
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
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
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 1,
      decoration: BoxDecoration(
        color: AppColors.containerBorderColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
