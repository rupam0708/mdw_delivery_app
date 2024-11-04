import 'package:flutter/material.dart';
import 'package:mdw/screens/code_verification_screen.dart';
import 'package:mdw/screens/main_screen.dart';
import 'package:mdw/screens/onboarding_screen.dart';
import 'package:mdw/services/app_function_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool signInStatus = false, attendStatus = false;

  getData() async {
    signInStatus = await AppFunctions.getSignInStatus();
    attendStatus = await AppFunctions.getAttendanceStatus();
    setState(() {});
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // textTheme: GoogleFonts.montserratTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: getData(),
        builder: ((ctx, snapshot) {
          if (signInStatus == true) {
            if (attendStatus) {
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
