import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mdw/styles.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../constant.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.initialPage;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        physics: AppConstant.physics,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    child: Lottie.asset("assets/delivery-animation.json"),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: PageView(
                    controller: _pageController,
                    children: [
                      Text(
                        "Delivering Medicines in\n20 mins!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "Join our team!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 45,
                ),
                SmoothPageIndicator(
                  effect: ExpandingDotsEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotColor: AppColors.green,
                    dotColor: AppColors.inactiveDotColor,
                  ),
                  controller: _pageController,
                  count: 2,
                ),
                SizedBox(
                  height: 25,
                ),
                CustomBtn(
                  onTap: (() {
                    if (_pageController.page == 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: ((ctx) => LoginScreen()),
                        ),
                      );
                    }
                    if (_pageController.page == 0) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.linear,
                      );
                    }
                    currentPage = _pageController.page?.toInt() ?? 0;
                    setState(() {});
                  }),
                  text: 'NEXT',
                  fontSize: 17,
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: (() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: ((ctx) => LoginScreen())),
                    );
                  }),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 45),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "SKIP",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.green,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomBtn extends StatelessWidget {
  const CustomBtn({
    super.key,
    required this.onTap,
    required this.text,
    this.fontSize,
    this.horizontalMargin,
    this.verticalPadding,
    this.horizontalPadding,
    this.width,
    this.height,
    this.child,
    this.color,
  });

  final VoidCallback onTap;
  final String text;
  final double? fontSize,
      horizontalMargin,
      verticalPadding,
      horizontalPadding,
      width,
      height;
  final Widget? child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin ?? 45),
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(
            vertical: verticalPadding ?? 15,
            horizontal: horizontalPadding ?? 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color ?? AppColors.btnColor,
        ),
        child: child ??
            Center(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                  fontSize: fontSize,
                ),
              ),
            ),
      ),
    );
  }
}
