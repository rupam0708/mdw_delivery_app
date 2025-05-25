import 'package:flutter/material.dart';
import 'package:mdw/styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashColor,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/IMG_6834.JPG"),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.transparent,
                  AppColors.green.withValues(alpha: 0.1),
                  AppColors.green.withValues(alpha: 0.3),
                  AppColors.green.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100, bottom: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: ClipRRect(
                      child: Image.asset(
                        "assets/app_icon.png",
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "My Dawai Wala".toUpperCase(),
                      style: TextStyle(
                        fontSize: 17,
                        color: AppColors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "Delivery Partner",
                      style: TextStyle(
                        fontSize: 35,
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
