import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mdw/core/services/storage_services.dart';
import 'package:mdw/shared/utils/snack_bar_utils.dart';

import '../../../core/constants/app_keys.dart';
import '../../../core/services/app_function_services.dart';
import '../../auth/models/login_user_model.dart';
import '../models/orders_model.dart';

class HomeController extends ChangeNotifier {
  LoginUserModel? rider;
  OrdersListModel? ordersList;
  bool ordersListEmpty = false;
  bool tokenInvalid = false;
  String message = "";
  bool isLoading = false;
  int timer = 5;
  Timer? _countdownTimer;

  final BuildContext context;

  HomeController(this.context) {
    initialize();
  }

  /// Initializes rider data and fetches orders
  Future<void> initialize() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = await StorageServices.getLoginUserDetails();
      if (user != null) {
        rider = LoginUserModel.fromRawJson(user);
        await getOrders();
      }
    } catch (e) {
      log(e.toString());
      message = "Failed to load rider info.";
      showMessage();
    }

    isLoading = false;
    notifyListeners();
  }

  /// Fetches rider orders
  Future<void> getOrders() async {
    final url = AppKeys.apiUrlKey +
        AppKeys.ridersKey +
        "/${rider?.rider.riderId}" +
        AppKeys.allottedOrdersKey;

    try {
      final res = await http.get(
        Uri.parse(url),
        headers: {"authorization": "Bearer ${rider?.token}"},
      );

      final resJson = jsonDecode(res.body);

      if (res.statusCode == 200) {
        if (resJson["orders"].isEmpty) {
          ordersListEmpty = true;
          message = resJson["message"] ?? "No orders found";
        } else {
          ordersListEmpty = false;
          ordersList = OrdersListModel.fromJson(resJson);
          message = "";
        }
      } else {
        ordersListEmpty = true;
        tokenInvalid = true;
        message = resJson["message"] ?? "Token invalid or expired.";
        startTimer();
      }
    } catch (_) {
      ordersListEmpty = true;
      message = "Error fetching orders.";
    }

    notifyListeners();
    if (message.isNotEmpty) showMessage();
  }

  /// Starts logout countdown when token is invalid
  void startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (this.timer > 0) {
        this.timer--;
        notifyListeners();
      } else {
        timer.cancel();
        logout();
      }
    });
  }

  /// Logs out user and clears data
  Future<void> logout() async => await AppFunctions.logout();

  /// Displays snackbar message
  void showMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBar().customizedAppSnackBar(
        message: message,
        context: context,
      ),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}
