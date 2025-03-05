import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mdw/models/orders_model.dart';
import 'package:mdw/screens/code_verification_screen.dart';
import 'package:mdw/services/app_keys.dart';
import 'package:mdw/styles.dart';
import 'package:mdw/utils/snack_bar_utils.dart';

import '../models/prev_orders_model.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    super.key,
    this.type,
    this.message,
  });

  final String? message;

  final int? type;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  OrdersListModel? ordersList;
  PrevOrdersListModel? prevOrdersList;
  bool empty = false, ordersListEmpty = false, prevOrdersListEmpty = false;
  String message = "";

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    if (widget.type != null && widget.type == 1) {
      await getOrders(AppKeys.prevKey);
    } else if (widget.type == null) {
      await getOrders(AppKeys.todayKey);
    }
  }

  Future<void> getOrders(String whichOrders) async {
    http.Response res = await http
        .get(Uri.parse(AppKeys.apiUrlKey + AppKeys.ordersKey + whichOrders));
    if (res.statusCode == 200) {
      if (widget.type == null) {
        // log(res.body);
        dynamic resJson = jsonDecode(res.body);
        // log(resJson.toString());
        try{
          ordersList = await OrdersListModel.fromRawJson(res.body);
        }catch(e){
          if (resJson["message"] != null) {
            setState(() {
              ordersListEmpty = true;
              message = resJson["message"];
            });
            ScaffoldMessenger.of(context).showSnackBar(
              AppSnackBar().customizedAppSnackBar(
                  message: resJson["message"], context: context),
            );
          }else{
            setState(() {
              ordersListEmpty = true;
              message = "Something wrong happened";
            });
            ScaffoldMessenger.of(context).showSnackBar(
              AppSnackBar().customizedAppSnackBar(
                  message: message, context: context),
            );
          }
        }

      } else if (widget.type != null && widget.type == 1) {
        dynamic resJson = jsonDecode(res.body);
try{
  prevOrdersList = await PrevOrdersListModel.fromRawJson(res.body);

}catch(e){
  if (resJson["message"] != null) {
    setState(() {
      prevOrdersListEmpty = true;
      message = resJson["message"];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBar().customizedAppSnackBar(
          message: resJson["message"], context: context),
    );
  }else{
    setState(() {
      ordersListEmpty = true;
      message = "Something wrong happened";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBar().customizedAppSnackBar(
          message: message, context: context),
    );
  }

}
      }
    } else {
      empty = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.green,
          onRefresh: (() async {
            if (widget.type != null && widget.type == 1) {
              await getOrders(AppKeys.prevKey);
            } else if (widget.type == null) {
              await getOrders(AppKeys.todayKey);
            }
          }),
          child: CustomScrollView(
            slivers: [
              if (widget.type == 1)
                SliverAppBar(
                  backgroundColor: AppColors.white,
                  leading: IconButton(
                    onPressed: (() {
                      Navigator.pop(context);
                    }),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.green,
                    ),
                  ),
                  title: CustomAppBarTitle(
                    title: "Previous Orders",
                  ),
                ),
              SliverToBoxAdapter(
                child: CustomUpperPortion(
                    head: widget.type == 1
                        ? prevOrdersListEmpty
                            ? message
                            : "View the orders those you\nalready delivered."
                        : ordersListEmpty
                            ? message
                            : "View the order that you need\nto deliver."),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 15,
                ),
              ),
              if ((widget.type == null || widget.type == 0) &&
                  ordersList == null &&
                  !ordersListEmpty)
                SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.green),
                  ),
                ),
              if (widget.type == 1 &&
                  prevOrdersList == null &&
                  !prevOrdersListEmpty)
                SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.green),
                  ),
                ),
              if (ordersList != null)
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
                          // onClosed: ((result) async {
                          //   if (widget.type != null && widget.type == 1) {
                          //     await getOrders(AppKeys.prevKey);
                          //   } else if (widget.type == null) {
                          //     await getOrders(AppKeys.todayKey);
                          //   }
                          // }),
                          closedBuilder: ((closedCtx, openContainer) {
                            DateTime date = DateFormat("dd-MM-yyyy").parse(ordersList!.data[index].orderDate);
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 17),
                              child: CustomOrderContainer(
                                id: ordersList!.data[index].orderId
                                    .toUpperCase(),
                                index: index,
                                onTapContainer: openContainer,
                                amount: ordersList!.data[index].amount.toString(),
                                name: ordersList!.data[index].customer.name,
                                phone: ordersList!
                                    .data[index].customer.phoneNumber
                                    .toString(),
                                address:
                                    "${ordersList!.data[index].customer.address.toString()}",
                                maxLines: 2,
                                date:
                                    "${date.day}/${date.month}/${date.year}",
                                distance: ordersList!.data[index].status,
                                time: ordersList!.data[index].turnaroundTime,
                              ),
                            );
                          }),
                          openBuilder: ((openCtx, _) {
                            return OrderDetailsScreen(
                              order: ordersList!.data[index],
                            );
                          }));
                    },
                    childCount: ordersList!.data.length,
                  ),
                ),
              if (prevOrdersList != null)
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
                          // onClosed: ((result) async {
                          //   if (widget.type != null && widget.type == 1) {
                          //     await getOrders(AppKeys.prevKey);
                          //   } else if (widget.type == null) {
                          //     await getOrders(AppKeys.todayKey);
                          //   }
                          // }),
                          closedBuilder: ((closedCtx, openContainer) {
                            DateTime date = DateFormat("dd-MM-yyyy").parse(prevOrdersList!.data[index].orderDate);

                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 17),
                              child: CustomOrderContainer(
                                id: prevOrdersList!.data[index].orderId
                                    .toUpperCase(),
                                index: index,
                                onTapContainer: openContainer,
                                amount: prevOrdersList!.data[index].amount.toString(),
                                name:
                                    prevOrdersList!.data[index].customer.name,
                                phone: prevOrdersList!
                                    .data[index].customer.phoneNumber
                                    .toString(),
                                address:
                                    "${prevOrdersList!.data[index].customer.address.toString()}",
                                maxLines: 2,
                                date:
                                    "${date.day}/${date.month}/${date.year}",
                                distance: prevOrdersList!.data[index].status.name,
                                time: prevOrdersList!
                                    .data[index].turnaroundTime.name,
                              ),
                            );
                          }),
                          openBuilder: ((openCtx, _) {
                            return OrderDetailsScreen(
                              prevOrder: prevOrdersList!.data[index],
                            );
                          }));
                    },
                    childCount: prevOrdersList!.data.length,
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
    required this.date,
    required this.time,
    required this.distance,
    required this.amount,
  });

  final VoidCallback onTapContainer;
  final int? index, maxLines;
  final Widget? middleWidget, buttons;
  final String name, phone, address, id, date, time, distance, amount;
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
                        date,
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
                  Flexible(
                    child: Text(
                      address,
                      style: TextStyle(
                        color: AppColors.black,
                        overflow: TextOverflow.clip,
                        fontSize: 12,
                      ),
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
                    distance.replaceAll("_", " "),
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
                        time,
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
                    "\₹$amount",
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
