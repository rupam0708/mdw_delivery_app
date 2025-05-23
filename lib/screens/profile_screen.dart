import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mdw/models/login_user_model.dart';
import 'package:mdw/models/rider_model.dart';
import 'package:mdw/screens/documents_screen.dart';
import 'package:mdw/screens/onboarding_screen.dart';
import 'package:mdw/services/app_function_services.dart';
import 'package:mdw/services/storage_services.dart';
import 'package:mdw/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/file_type_model.dart';
import '../models/salary_profile_model.dart';
import '../services/app_keys.dart';
import 'login_screen.dart';
import 'orders_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.onChangeIndex});

  final Function(int) onChangeIndex;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<SalaryProfileModel> salaryList = [];
  LoginUserModel? rider;
  RiderModel? newRider;
  String? message;
  bool tokenInvalid = false;
  late http.Response salaryRes;
  FileTypeModel? profilePic;
  ImagePicker imagePicker = ImagePicker();

  // getSalaryData(String riderId, String token) async {
  //   // log(token);
  //   http.Response res = await http.get(
  //     Uri.parse(
  //         "${AppKeys.apiUrlKey}${AppKeys.ridersKey}/$riderId${AppKeys.salaryHistoryKey}"),
  //     headers: {
  //       'Content-type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );
  //   // log(token);
  //   // log(res.body.toString());
  //   // log(res.statusCode.toString());
  //   salaryRes = res;
  //   Map<String, dynamic> resJson = jsonDecode(res.body);
  //   if (res.statusCode == 404 && res.statusCode == 200) {
  //     if (resJson["success"] == 1) {
  //     } else if (resJson["success"] == 0) {
  //       message = resJson["message"];
  //     }
  //   } else if (res.statusCode == 401) {
  //     message = resJson["message"];
  //     startTimer();
  //   } else {
  //     message = resJson["message"] ?? "Something wrong happened";
  //   }
  //   setState(() {});
  // }

  void logout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(),
      ),
    );
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  int timer = 5;

  // Timer? _countdownTimer;

  void startTimer() {
    // _countdownTimer =
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.timer > 0) {
        setState(() {
          this.timer--;
        });
      } else {
        timer.cancel();
        logout(); // Call logout function when timer reaches 0
      }
    });
  }

  getData() async {
    await getProfile();
    // if (newRider != null && rider != null) {
    //   await getSalaryData(newRider!.rider.riderId, rider!.token);
    // }
  }

  Future<void> getProfile() async {
    String? riderJson = await StorageServices.getLoginUserDetails();
    profilePic = await StorageServices.getProfilePic();
    if (riderJson != null) {
      rider = LoginUserModel.fromRawJson(riderJson);
      setState(() {});
    }
    if (rider != null) {
      http.Response res = await http.get(Uri.parse(
          AppKeys.apiUrlKey + AppKeys.ridersKey + "/${rider!.rider.riderId}"));
      if (res.statusCode == 200) {
        Map<String, dynamic> resJson = jsonDecode(res.body);
        if (resJson["success"] == 1) {
          newRider = RiderModel.fromJson(resJson);
          setState(() {});
        }
      }
    }
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
              getData();
            }),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: newRider != null
                  ? CustomScrollView(
                      // physics: AppConstant.physics,
                      slivers: [
                        SliverToBoxAdapter(
                          child: Row(
                            children: [
                              if (profilePic == null)
                                GestureDetector(
                                  onTap: (() async {
                                    XFile? pic = await imagePicker.pickImage(
                                        source: ImageSource.camera);
                                    if (pic != null) {
                                      await StorageServices.setProfilePic(
                                          FileTypeModel(path: pic.path));
                                      await getProfile();
                                    }
                                  }),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        AssetImage("assets/person.png"),
                                  ),
                                ),
                              if (profilePic != null)
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      FileImage(File(profilePic!.path)),
                                ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    newRider!.rider.riderName,
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    "Ph. No. : +91 ${newRider!.rider.phoneNumber.toString().substring(0, 5)} ${newRider!.rider.phoneNumber.toString().substring(5)}",
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            decoration: AppColors.customDecoration,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  newRider!.rider.vehicleType,
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  newRider!.rider.vehicleNumber,
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // if (salaryList.isNotEmpty)
                        //   SliverToBoxAdapter(
                        //     child: SizedBox(
                        //       height: 15,
                        //     ),
                        //   ),
                        // if (salaryList.isNotEmpty)
                        //   SliverToBoxAdapter(
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Expanded(
                        //           child: ProfileTodayContainer(
                        //             head: "Today's\nTrip",
                        //             data: "10",
                        //           ),
                        //         ),
                        //         SizedBox(width: 10),
                        //         Expanded(
                        //           child: ProfileTodayContainer(
                        //             head: "Order\nAmount",
                        //             data: "₹3000",
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
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
                        // if (salaryList.isEmpty && message != null)
                        //   SliverToBoxAdapter(
                        //     child: CustomDivider(),
                        //   ),
                        // if (salaryList.isEmpty &&
                        //     message != null &&
                        //     salaryRes.statusCode == 401)
                        //   SliverToBoxAdapter(
                        //     child: Center(
                        //       child: Text(
                        //         message! + "Logging Out in ${timer} seconds",
                        //         style: TextStyle(
                        //           color: AppColors.black,
                        //           fontSize: 12,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // if (salaryList.isEmpty &&
                        //     message != null &&
                        //     salaryRes.statusCode != 401)
                        //   SliverToBoxAdapter(
                        //     child: Center(
                        //       child: Text(
                        //         message!,
                        //         style: TextStyle(
                        //           color: AppColors.black,
                        //           fontSize: 12,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // if (salaryList.isEmpty && message == null)
                        //   SliverToBoxAdapter(
                        //     child: Center(
                        //       child: Container(
                        //         padding: EdgeInsets.symmetric(
                        //             horizontal: 10, vertical: 15),
                        //         child: CircularProgressIndicator(
                        //           color: AppColors.green,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // if (salaryList.isEmpty)
                        //   SliverToBoxAdapter(
                        //     child: CustomDivider(),
                        //   ),
                        // if (salaryList.isNotEmpty)
                        //   SliverToBoxAdapter(
                        //     child: Container(
                        //       child: Column(
                        //         children: salaryList
                        //             .map(
                        //               (salary) => Column(
                        //                 children: [
                        //                   Padding(
                        //                     padding: EdgeInsets.only(top: 15),
                        //                     child: Row(
                        //                       mainAxisAlignment:
                        //                           MainAxisAlignment
                        //                               .spaceBetween,
                        //                       children: [
                        //                         Column(
                        //                           crossAxisAlignment:
                        //                               CrossAxisAlignment.start,
                        //                           children: [
                        //                             Text(
                        //                               "Salary 1",
                        //                               style: TextStyle(
                        //                                 color: AppColors.black,
                        //                                 fontWeight:
                        //                                     FontWeight.bold,
                        //                                 fontSize: 15,
                        //                               ),
                        //                             ),
                        //                             SizedBox(height: 5),
                        //                             Text(
                        //                               "Reference ID: C079DB3D",
                        //                               style: TextStyle(
                        //                                 color: AppColors.black,
                        //                                 fontSize: 12,
                        //                               ),
                        //                             ),
                        //                           ],
                        //                         ),
                        //                         Text(
                        //                           "+ ₹873.01",
                        //                           style: TextStyle(
                        //                             color: AppColors.green,
                        //                             fontSize: 17,
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                   SizedBox(height: 15),
                        //                   CustomDivider(),
                        //                 ],
                        //               ),
                        //             )
                        //             .toList(),
                        //       ),
                        //     ),
                        //   ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 15,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: GestureDetector(
                            onTap: (() async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrdersScreen(
                                    type: 1,
                                    message:
                                        "View the orders that you delivered.",
                                  ),
                                ),
                              );
                            }),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              decoration: AppColors.customDecoration,
                              child: Center(
                                child: Text(
                                  "Previous Orders",
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
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: AppColors.green,
                      ),
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
            color: Colors.grey.withValues(alpha: 0.5),
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
            color: Colors.grey.withValues(alpha: 0.5),
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
              color: AppColors.black.withValues(alpha: 0.5),
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
