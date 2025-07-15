// 📁 lib/features/delivery/controllers/orders_controller.dart

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mdw/core/constants/app_keys.dart';
import 'package:mdw/core/services/storage_services.dart';
import 'package:mdw/features/auth/models/login_user_model.dart';
import 'package:mdw/features/delivery/models/orders_model.dart';
import 'package:mdw/features/delivery/models/prev_orders_model.dart';

import '../../../core/services/app_function_services.dart';
import '../../../shared/utils/snack_bar_utils.dart';

class OrdersController extends ChangeNotifier {
  final int? type;

  final BuildContext context;

  OrdersController(this.context, {this.type}) {
    init();
  }

  OrdersListModel? ordersList;
  PrevOrdersListModel? prevOrdersList;
  LoginUserModel? rider;

  bool ordersListEmpty = false;
  bool prevOrdersListEmpty = false;
  bool tokenInvalid = false;
  String message = "";

  int timer = 5;
  Timer? _countdownTimer;

  bool get isPrevious => type != null && type == 1;

  bool get isCurrent => type == null;

  Future<void> init() async {
    final userStr = await StorageServices.getLoginUserDetails();
    if (userStr != null) {
      rider = LoginUserModel.fromRawJson(userStr);
      await getOrders();
    }
  }

  Future<void> getOrders() async {
    String url = "";
    if (isPrevious) {
      url = AppKeys.apiUrlKey + AppKeys.ordersKey + AppKeys.prevKey;
    } else if (isCurrent && rider != null) {
      url = AppKeys.apiUrlKey +
          AppKeys.ridersKey +
          "/${rider!.rider.riderId}" +
          AppKeys.allottedOrdersKey;
    }

    final res = await http.get(Uri.parse(url),
        headers: {"authorization": "Bearer ${rider!.token}"});

    final resJson = jsonDecode(res.body);
    log(resJson.toString());

    if (res.statusCode == 200) {
      try {
        if (isPrevious) {
          prevOrdersList = PrevOrdersListModel.fromRawJson(res.body);
          prevOrdersListEmpty = prevOrdersList!.data.isEmpty;
        } else {
          ordersList = OrdersListModel.fromJson(resJson);
          ordersListEmpty = ordersList!.orders.isEmpty;
        }
      } catch (e) {
        log(e.toString());
        _handleError(resJson);
      }
    } else {
      _handleError(resJson);
      tokenInvalid = true;
      startTimer();
    }

    notifyListeners();
  }

  void _handleError(Map<String, dynamic> resJson) {
    message = resJson["message"] ?? "Something went wrong";
    if (isPrevious) {
      prevOrdersListEmpty = true;
    } else {
      ordersListEmpty = true;
    }
  }

  void startTimer() {
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

// ✅ CONTROLLER DONE
