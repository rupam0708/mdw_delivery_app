import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mdw/screens/documents_screen.dart';
import 'package:mdw/screens/onboarding_screen.dart';
import 'package:mdw/services/app_function_services.dart';
import 'package:mdw/styles.dart';

import '../models/salary_profile_model.dart';
import 'orders_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.onChangeIndex});

  final Function(int) onChangeIndex;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<SalaryProfileModel> salaryList = [];

  getSalaryData() async {
    // Create a random number generator
    Random random = Random();

    // Add 10 random elements to the salaryList
    for (int i = 0; i < 10; i++) {
      int randomMonth = random.nextInt(12) + 1; // Random month between 1 and 12
      int randomYear =
          random.nextInt(10) + 2015; // Random year between 2015 and 2024
      double randomSalary = random.nextInt(50000) +
          50000; // Random salary between 50000 and 99999

      salaryList.add(SalaryProfileModel(
        month: randomMonth,
        year: randomYear,
        salary: randomSalary,
      ));

      salaryList.sort((a, b) {
        if (a.year != b.year) {
          return a.year.compareTo(b.year);
        } else {
          return a.month.compareTo(b.month);
        }
      });
    }

    setState(() {});
  }

  @override
  void initState() {
    getSalaryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          child: RefreshIndicator(
            onRefresh: (() async {
              setState(() {
                salaryList.clear();
              });
              await getSalaryData();
              setState(() {});
            }),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              "https://images.pexels.com/photos/3785077/pexels-photo-3785077.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Zakariya Yoder",
                              style: TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "Ph. No. : +91 00000 00000",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 15,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      decoration: AppColors.customDecoration,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Scooty",
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "WB 00A 0000",
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 15,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ProfileTodayContainer(
                            head: "Today's\nTrip",
                            data: "10",
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ProfileTodayContainer(
                            head: "Order\nAmount",
                            data: "₹3000",
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 15,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: CustomDivider(),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 15,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: GestureDetector(
                      onTap: (() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DocumentsScreen(),
                          ),
                        );
                      }),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: AppColors.customDecoration,
                        child: Center(
                          child: Text(
                            "Documents",
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 15,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: CustomDivider(),
                  ),
                  if (salaryList.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Container(
                        child: Column(
                          children: salaryList
                              .map(
                                (salary) => Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Salary 1",
                                                style: TextStyle(
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "Reference ID: C079DB3D",
                                                style: TextStyle(
                                                  color: AppColors.black,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "+ ₹873.01",
                                            style: TextStyle(
                                              color: AppColors.green,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    CustomDivider(),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 15,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: GestureDetector(
                      onTap: (() async {
                        widget.onChangeIndex(0);
                      }),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: AppColors.customDecoration,
                        child: Center(
                          child: Text(
                            "Orders",
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileTodayContainer extends StatelessWidget {
  const ProfileTodayContainer({
    super.key,
    required this.data,
    required this.head,
  });

  final String data, head;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: AppColors.customDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            head,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 5),
          Text(
            data,
            style: TextStyle(
              color: AppColors.green,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ],
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

class RotatingIcon extends StatefulWidget {
  @override
  _RotatingIconState createState() => _RotatingIconState();
}

class _RotatingIconState extends State<RotatingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isRotated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _toggleRotation() {
    setState(() {
      if (_isRotated) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      _isRotated = !_isRotated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleRotation,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _animation.value * 3.14, // Rotate 180 degrees (π radians)
            child: Icon(
              Icons.arrow_downward,
              size: 100,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
