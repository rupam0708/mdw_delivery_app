import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mdw/screens/onboarding_screen.dart';
import 'package:mdw/services/app_function_services.dart';
import 'package:mdw/styles.dart';

import 'code_verification_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15),
          child: Column(
            children: [
              CustomProfileEarnContainer(
                amount: 1200000000.10000,
                head: "Monthly",
              ),
              SizedBox(
                height: 25,
              ),
              CustomProfileEarnContainer(
                amount: 1200000000.10000,
                head: "Daily",
              ),
              SizedBox(
                height: 25,
              ),
              ProfileContainer(
                head: "Submit Cash",
                amount: 1200000000.10000,
                btnText: "Submit",
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((ctx) => CodeVerificationScreen(
                            head: "Code Verification",
                            upperText:
                                "Enter the code to confirm to accept the\ncash.",
                            type: 1,
                            btnText: "Confirm",
                          )),
                    ),
                  ).whenComplete(() {
                    log("Refreshed");
                  });
                }),
              ),
              SizedBox(
                height: 25,
              ),
              ProfileContainer(
                head: "Draw Cash",
                amount: 1200000000.10000,
                btnText: "Draw",
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((ctx) => CodeVerificationScreen(
                            head: "Code Verification",
                            upperText:
                                "Enter the code to confirm the reception\nof your payment.",
                            type: 1,
                            btnText: "Confirm",
                          )),
                    ),
                  ).whenComplete(() {
                    log("Refreshed");
                  });
                }),
              ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomProfileEarnContainer extends StatelessWidget {
  const CustomProfileEarnContainer(
      {super.key, required this.head, required this.amount});

  final String head;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.containerColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 10,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomContainerHeading(
            head: head,
          ),
          CustomCurrencyText(
            amount: amount,
          ),
        ],
      ),
    );
  }
}

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({
    super.key,
    required this.head,
    required this.amount,
    required this.btnText,
    required this.onTap,
  });

  final String head, btnText;
  final double amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.containerColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 10,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomContainerHeading(head: head),
          CustomCurrencyText(amount: amount),
          CustomBtn(
            onTap: onTap,
            text: btnText,
            horizontalMargin: 0,
            verticalPadding: 7,
            fontSize: 12,
            horizontalPadding: 15,
            width: MediaQuery.of(context).size.width / 2.5,
          ),
        ],
      ),
    );
  }
}

class CustomCurrencyText extends StatelessWidget {
  const CustomCurrencyText({
    super.key,
    required this.amount,
  });

  final double amount;

  @override
  Widget build(BuildContext context) {
    return Text(
      AppFunctions.formatCurrency(amount),
      style: TextStyle(
        color: AppColors.green,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class CustomContainerHeading extends StatelessWidget {
  const CustomContainerHeading({
    super.key,
    required this.head,
  });

  final String head;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            head,
            style: TextStyle(
              color: AppColors.black.withOpacity(0.5),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}
