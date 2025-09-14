import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mdw/core/services/app_function_services.dart';
import 'package:mdw/core/services/storage_services.dart';
import 'package:mdw/features/auth/screens/profile_screen.dart';
import 'package:mdw/features/delivery/screens/home_screen.dart';
import 'package:mdw/features/delivery/screens/orders_screen.dart';
import 'package:mdw/features/feedback/screens/feedback_screen.dart';

import '../../auth/models/login_user_model.dart';

enum MainTab { home, orders, profile, feedback }

extension MainTabTitle on MainTab {
  String get title {
    switch (this) {
      case MainTab.home:
        return 'Home';
      case MainTab.orders:
        return 'Orders';
      case MainTab.profile:
        return 'Profile';
      case MainTab.feedback:
        return 'Feedback';
    }
  }
}

class MainController extends ChangeNotifier {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  MainTab currentTab = MainTab.home;

  LoginUserModel? rider;
  bool isShiftActive = false;

  int timer = 5;
  Timer? _countdownTimer;

  MainController() {
    init();
  }

  /// Initialize rider and fetch shift status
  void init() async {
    log("init");
    final user = await StorageServices.getLoginUserDetails();
    // log(user.toString());
    if (user != null) {
      rider = LoginUserModel.fromRawJson(user);
      // if (rider != null) {
      //   await getShiftStatus();
      // }
    }
    notifyListeners();
  }

  /// Fetch shift status from API

  /// Start logout countdown
  void startTimer() {
    _countdownTimer?.cancel();
    timer = 5;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timer > 0) {
        timer--;
        notifyListeners();
      } else {
        t.cancel();
        logout();
      }
    });
  }

  /// Logs out user and clears data
  Future<void> logout() async {
    await AppFunctions.logout();
    // navigation should be handled in UI layer (e.g., with context + Navigator)
  }

  /// Change current tab
  void changeTab(MainTab tab) {
    currentTab = tab;
    notifyListeners();
  }

  /// Return the screen for current tab
  Widget get currentScreen {
    switch (currentTab) {
      case MainTab.orders:
        return const OrdersScreen();
      case MainTab.profile:
        return ProfileScreen(onChangeIndex: (_) => changeTab(MainTab.home));
      case MainTab.feedback:
        return const FeedbackScreen();
      case MainTab.home:
        return HomeScreen(onChangeIndex: (_) => changeTab(MainTab.orders));
    }
  }

  /// Toggle shift (start or end)

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}
