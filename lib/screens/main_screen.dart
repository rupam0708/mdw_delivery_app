import 'package:flutter/material.dart';
import 'package:mdw/screens/feedback_screen.dart';
import 'package:mdw/screens/orders_screen.dart';
import 'package:mdw/screens/profile_screen.dart';
import 'package:mdw/styles.dart';

import 'code_verification_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (() {
            _scaffoldKey.currentState?.openDrawer();
          }),
          icon: Icon(
            Icons.menu,
            color: AppColors.green,
          ),
        ),
        title: CustomAppBarTitle(
          title: index == 0
              ? "Orders"
              : index == 1
                  ? "Profile"
                  : "Feedback",
        ),
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width / 1.6,
        child: SafeArea(
          child: ListView(
            children: [
              ListTile(
                selected: index == 0,
                selectedTileColor: AppColors.green.withOpacity(0.3),
                onTap: (() {
                  setState(() {
                    index = 0;
                  });
                  _scaffoldKey.currentState?.closeDrawer();
                }),
                leading: Icon(
                  Icons.inventory_rounded,
                  color: AppColors.grey,
                ),
                title: Text(
                  "Orders",
                  style: TextStyle(
                    color: AppColors.black.withOpacity(0.7),
                  ),
                ),
              ),
              ListTile(
                selected: index == 1,
                selectedTileColor: AppColors.green.withOpacity(0.3),
                onTap: (() {
                  setState(() {
                    index = 1;
                  });
                  _scaffoldKey.currentState?.closeDrawer();
                }),
                leading: Icon(
                  Icons.person_rounded,
                  color: AppColors.grey,
                ),
                title: Text(
                  "Profile",
                  style: TextStyle(
                    color: AppColors.black.withOpacity(0.7),
                  ),
                ),
              ),
              ListTile(
                selected: index == 2,
                selectedTileColor: AppColors.green.withOpacity(0.3),
                onTap: (() {
                  setState(() {
                    index = 2;
                  });
                  _scaffoldKey.currentState?.closeDrawer();
                }),
                leading: Icon(
                  Icons.feedback_rounded,
                  color: AppColors.grey,
                ),
                title: Text(
                  "Feedback",
                  style: TextStyle(
                    color: AppColors.black.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Builder(builder: ((ctx) {
        switch (index) {
          case 0:
            return OrdersScreen();
          case 1:
            return ProfileScreen();
          case 2:
            return FeedbackScreen();
        }
        return Container();
      })),
    );
  }
}
