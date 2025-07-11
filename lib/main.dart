import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mdw/models/login_user_model.dart';
import 'package:mdw/screens/code_verification_screen.dart';
import 'package:mdw/screens/documents_screen.dart';
import 'package:mdw/screens/main_screen.dart';
import 'package:mdw/screens/onboarding_screen.dart';
import 'package:mdw/screens/splash_screen.dart';
import 'package:mdw/services/app_function_services.dart';
import 'package:mdw/services/storage_services.dart';
import 'package:mdw/utils/snack_bar_utils.dart';

import 'models/file_type_model.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool splashShow = true;
  bool signInStatus = false;
  bool attendStatus = false;
  bool showAttendance = false;

  FileTypeModel? aadharFront, aadharBack, pan;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    signInStatus = await StorageServices.getSignInStatus();
    attendStatus = await StorageServices.getAttendanceStatus();
    showAttendance = AppFunctions.shouldShowAttendanceScreen();
    if (signInStatus) {
      String? user = await StorageServices.getLoginUserDetails();

      if (user != null) {
        LoginUserModel u = LoginUserModel.fromRawJson(user);
        aadharFront = await StorageServices.getAadharFront(u.rider.riderId);
        aadharBack = await StorageServices.getAadharBack(u.rider.riderId);
        pan = await StorageServices.getPan(u.rider.riderId);
      }
    }

    setState(() {
      splashShow = true;
    });

    await Future.delayed(const Duration(seconds: 4)); // Simulate splash screen

    setState(() {
      splashShow = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigateNext();
    });
  }

  void navigateNext() {
    final nav = navigatorKey.currentState!;

    if (!signInStatus) {
      nav.pushReplacement(
        MaterialPageRoute(builder: (_) => OnboardingScreen()),
      );
      return;
    }

    if (aadharFront == null || aadharBack == null || pan == null) {
      nav
          .push<bool>(
        MaterialPageRoute(builder: (_) => DocumentsScreen(type: 1)),
      )
          .then((result) async {
        if (result == true) {
          // Re-check attendance in case it was changed
          attendStatus = await StorageServices.getAttendanceStatus();
          navigateBasedOnAttendance();
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(nav.context).showSnackBar(
            AppSnackBar().customizedAppSnackBar(
              message: "Please complete your document verification.",
              context: context,
            ),
          );
        }
      });
    } else {
      navigateBasedOnAttendance();
    }
  }

  void navigateBasedOnAttendance() {
    final nav = navigatorKey.currentState!;
    if (attendStatus || !showAttendance) {
      nav.pushReplacement(
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } else {
      nav.pushReplacement(
        MaterialPageRoute(
          builder: (_) => CodeVerificationScreen(
            head: "Attendance",
            upperText:
                "Ask your admin to enter his code to confirm your attendance.",
            type: 0,
            btnText: "Confirm Attendance",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'MDW Delivery App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Always show splash while preparing
    );
  }
}
