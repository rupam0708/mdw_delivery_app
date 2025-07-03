import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mdw/services/app_function_services.dart';
import 'package:mdw/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_user_model.dart';
import '../models/orders_model.dart';
import '../services/app_keys.dart';
import '../services/storage_services.dart';
import '../utils/snack_bar_utils.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onChangeIndex});

  final Function(int) onChangeIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LoginUserModel? rider;
  OrdersListModel? ordersList;
  bool ordersListEmpty = false, tokenInvalid = false;
  String message = "";

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  getData() async {
    String? user = await StorageServices.getLoginUserDetails();
    if (user != null) {
      rider = await LoginUserModel.fromRawJson(user);
      await getOrders();
      // if (widget.type != null && widget.type == 1) {
      //   await getOrders(AppKeys.prevKey);
      // } else if (widget.type == null) {
      //   await getOrders(AppKeys.todayKey);
      // }
    }
  }

  Future<void> getOrders() async {
    String url = AppKeys.apiUrlKey +
        AppKeys.ridersKey +
        "/${rider!.rider.riderId}" +
        AppKeys.allottedOrdersKey;

    // log(url);
    http.Response res = await http.get(Uri.parse(url),
        headers: {"authorization": "Bearer ${rider!.token}"});
    if (res.statusCode == 200) {
      // log(res.body);
      dynamic resJson = jsonDecode(res.body);
      // log(resJson.toString());
      // log(resJson["orders"].length.toString());
      ordersList = await OrdersListModel.fromJson(resJson);

      try {
        if (resJson["orders"].length == 0) {
          setState(() {
            ordersListEmpty = true;
            message = resJson["message"] ?? "Something went wrong";
          });
          ScaffoldMessenger.of(context).showSnackBar(AppSnackBar()
              .customizedAppSnackBar(message: message, context: context));
        } else {
          ordersListEmpty = false;
          ordersList = await OrdersListModel.fromJson(resJson);
          // log(ordersList!.orders.length.toString());
          setState(() {});
        }
      } catch (e) {
        log(e.toString());
        setState(() {
          ordersListEmpty = true;
          message = resJson["message"] ?? "Something went wrong";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          AppSnackBar().customizedAppSnackBar(
              message: resJson["message"] ?? "Something went wrong",
              context: context),
        );
      }
    } else {
      ordersListEmpty = true;
      Map<String, dynamic> resJson = jsonDecode(res.body);
      ScaffoldMessenger.of(context).showSnackBar(
        AppSnackBar().customizedAppSnackBar(
          message: resJson["message"],
          context: context,
        ),
      );
      setState(() {
        tokenInvalid = true;
      });

      startTimer();
    }
    setState(() {});
  }

  int timer = 5;
  Timer? _countdownTimer;

  void startTimer() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.timer > 0) {
        setState(() {
          this.timer--;
        });
      } else {
        timer.cancel();
        logout(); // Call logout function when timer reaches 0
      }
    });
  }

  void logout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
        child: RefreshIndicator(
          onRefresh: (() async {
            await getData();
          }),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.black),
                  ),
                  child: Row(
                    children: [
                      /// Left SVG image
                      Expanded(
                        child: Image.asset(
                          "assets/man.png",
                          fit: BoxFit.contain,
                        ),
                      ),

                      /// Right side column
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// Top small SVG icon (optional; remove if not needed)
                            Image.asset(
                              "assets/mdw_logo_2.png",
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 10),

                            /// Welcome Text
                            Text(
                              "Welcome\nOur\nDawai Dost",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Progress",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Column(
                  children: [
                    if (!ordersListEmpty && ordersList != null)
                      CustomContainer(
                        head: "Earnings",
                        value: "₹" +
                            AppFunctions.sumTodayDeliveredAmounts(
                                    ordersList!.orders)
                                .toString(),
                        onTap: (() {}),
                      ),
                    if (!ordersListEmpty && ordersList != null)
                      SizedBox(height: 15),
                    if (!ordersListEmpty && ordersList != null)
                      CustomContainer(
                        head: "Orders",
                        value: AppFunctions.countTodayPackedOrders(
                                ordersList!.orders)
                            .toString(),
                        showArrow: true,
                        onTap: (() {
                          widget.onChangeIndex(1);
                        }),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.head,
    required this.value,
    required this.onTap,
    this.showArrow,
  });

  final String head, value;
  final VoidCallback onTap;
  final bool? showArrow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        padding: EdgeInsets.only(left: 30, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColors.black,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              head,
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (showArrow ?? false) SizedBox(width: 10),
                if (showArrow ?? false)
                  IconButton(
                    onPressed: onTap,
                    icon: Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.black,
                      size: 40,
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
