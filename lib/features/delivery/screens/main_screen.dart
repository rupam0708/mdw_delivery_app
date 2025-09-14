import 'package:flutter/material.dart';
import 'package:mdw/core/themes/styles.dart';
import 'package:mdw/features/auth/screens/login/login_screen.dart';
import 'package:mdw/features/delivery/controller/main_controller.dart';
import 'package:provider/provider.dart';

import '../widgets/main_appbar.dart';
import '../widgets/main_drawer.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainController = Provider.of<MainController>(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      key: mainController.scaffoldKey,
      appBar: MainAppBar(
        onMenuTap: () => mainController.scaffoldKey.currentState?.openDrawer(),
        title: mainController.currentTab == MainTab.home
            ? Image.asset(
                "assets/mdw_logo_2.png",
                height: 70,
                fit: BoxFit.contain,
              )
            : Text(mainController.currentTab.title),
        centerTitle: mainController.currentTab == MainTab.home,
        // showShiftButton: false,
        // showShiftButton: mainController.currentTab == MainTab.home,
        attendanceStatus: mainController.isShiftActive,
        // onShiftTap: () => mainController.init(),
        // onShiftTap: () => mainController.toggleShift(context),
        onShiftTap: () => {},
      ),
      drawer: MainDrawer(
        currentTab: mainController.currentTab,
        onTabSelected: mainController.changeTab,
        onLogout: () async {
          await mainController.logout();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (mainController.currentTab != MainTab.home) {
            mainController.changeTab(MainTab.home);
            return false;
          }
          return true;
        },
        child: mainController.currentScreen,
      ),
    );
  }
}
