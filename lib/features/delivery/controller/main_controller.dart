import 'package:flutter/material.dart';
import 'package:mdw/core/services/app_function_services.dart';
import 'package:mdw/core/services/storage_services.dart';
import 'package:mdw/features/auth/screens/code_verification_screen.dart';
import 'package:mdw/features/auth/screens/profile_screen.dart';
import 'package:mdw/features/delivery/screens/home_screen.dart';
import 'package:mdw/features/delivery/screens/orders_screen.dart';
import 'package:mdw/features/feedback/screens/feedback_screen.dart';

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
  bool attendanceStatus = false;

  void init() async {
    attendanceStatus = await StorageServices.getAttendanceStatus();
    notifyListeners();
  }

  void changeTab(MainTab tab) {
    currentTab = tab;
    notifyListeners();
  }

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

  Future<void> toggleAttendance(BuildContext context) async {
    if (attendanceStatus) {
      await StorageServices.setAttendanceStatus(false);
      attendanceStatus = false;
      notifyListeners();
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CodeVerificationScreen(
            head: "Attendance",
            upperText:
                "Ask your admin to enter his code to confirm your attendance.",
            type: 2,
            btnText: "Confirm Attendance",
          ),
        ),
      );
      attendanceStatus = await StorageServices.getAttendanceStatus();
      notifyListeners();
    }
  }

  Future<void> logout() async => await AppFunctions.logout();
}
