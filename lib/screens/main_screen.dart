import 'package:flutter/material.dart';
import 'package:mdw/screens/feedback_screen.dart';
import 'package:mdw/screens/login_screen.dart';
import 'package:mdw/screens/onboarding_screen.dart';
import 'package:mdw/screens/orders_screen.dart';
import 'package:mdw/screens/profile_screen.dart';
import 'package:mdw/services/storage_services.dart';
import 'package:mdw/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import 'code_verification_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int index = 0;
  bool attendanceStatus = false;

  void _changeIndex(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  getData() async {
    attendanceStatus = await StorageServices.getAttendanceStatus();
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.white,
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
        actions: index == 1
            ? [
                CustomBtn(
                  horizontalPadding: 15,
                  horizontalMargin: 10,
                  verticalPadding: 10,
                  height: 40,
                  onTap: (() async {
                    if (attendanceStatus) {
                      await StorageServices.setAttendanceStatus(false);
                      attendanceStatus = false;
                      setState(() {});
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((ctx) => CodeVerificationScreen(
                                head: "Attendance",
                                upperText:
                                    "Ask your admin to enter his code to confirm your attendance.",
                                type: 2,
                                btnText: "Confirm Attendance",
                              )),
                        ),
                      ).whenComplete(() async {
                        await getData();
                      });
                    }
                  }),
                  text: "${attendanceStatus ? "End" : "Start"} Shift",
                ),
                SizedBox(width: 10),
              ]
            : null,
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width / 1.6,
        child: SafeArea(
          child: ListView(
            physics: AppConstant.physics,
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
              ListTile(
                selected: index == 3,
                selectedTileColor: AppColors.green.withOpacity(0.3),
                onTap: (() async {
                  setState(() {
                    index = 3;
                  });
                  _scaffoldKey.currentState?.closeDrawer();
                  final pref = await SharedPreferences.getInstance();
                  await pref.clear();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoginScreen(),
                    ),
                  );
                }),
                leading: Icon(
                  Icons.logout,
                  color: AppColors.grey,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    color: AppColors.red.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: PopScope(
        canPop: index == 0 ? true : false,
        onPopInvokedWithResult: ((popped, val) {
          if (index != 0) {
            _changeIndex(0);
          } else {
            return;
          }
        }),
        child: Builder(builder: ((ctx) {
          switch (index) {
            case 0:
              return OrdersScreen();
            case 1:
              return ProfileScreen(onChangeIndex: _changeIndex);
            case 2:
              return FeedbackScreen();
          }
          return Container();
        })),
      ),
    );
  }
}
