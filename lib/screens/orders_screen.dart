import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
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
                                            "8583006460");
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
  });

  final VoidCallback onTapContainer;
  final int? index, maxLines;
  final Widget? middleWidget, buttons;
  final String name, phone, address;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapContainer,
      child: Container(
        margin: EdgeInsets.only(top: index == 0 ? 0 : 20, left: 20, right: 20),
        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 25),
        width: MediaQuery.of(context).size.width,
        height: height ?? 200,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    phone,
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      address,
                      overflow: TextOverflow.ellipsis,
                      maxLines: maxLines,
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                  if (middleWidget == null)
                    SizedBox(
                      height: 15,
                    ),
                  if (middleWidget != null)
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: middleWidget!,
                      ),
                    ),
                  SizedBox(
                    child: buttons,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
