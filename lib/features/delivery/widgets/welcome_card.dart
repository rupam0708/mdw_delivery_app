import 'package:flutter/material.dart';
import 'package:mdw/core/themes/styles.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.containerBorderColor),
      ),
      child: Column(
        children: [
          Image.asset(
            "assets/man.png",
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              "Welcome Our Dawai Dost",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
