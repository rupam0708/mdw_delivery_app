import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mdw/screens/code_verification_screen.dart';
import 'package:mdw/screens/main_screen.dart';
import 'package:mdw/screens/onboarding_screen.dart';
import 'package:mdw/screens/splash_screen.dart';
import 'package:mdw/services/app_function_services.dart';
import 'package:mdw/services/storage_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool signInStatus = false,
      attendStatus = false,
      showAttendance = false,
      splashShow = true;

  Future<void> getData() async {
    signInStatus = await StorageServices.getSignInStatus();
    attendStatus = await StorageServices.getAttendanceStatus();
    showAttendance = AppFunctions.shouldShowAttendanceScreen();
    setState(() {});
    Future.delayed(Duration(seconds: 4), (() {
      setState(() {
        splashShow = false;
      });
    }));
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MDW Delivery App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // textTheme: GoogleFonts.montserratTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: splashShow
          ? SplashScreen()
          : Builder(
              builder: ((ctx) {
                if (signInStatus == true) {
                  if (attendStatus || !showAttendance) {
                    return MainScreen();
                  } else {
                    return CodeVerificationScreen(
                      head: "Attendance",
                      upperText:
                          "Ask your admin to enter his code to confirm your attendance.",
                      type: 0,
                      btnText: "Confirm Attendance",
                    );
                  }
                } else {
                  return OnboardingScreen();
                }
              }),
            ),
    );
  }
}
