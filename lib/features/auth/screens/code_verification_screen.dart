import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mdw/core/constants/app_keys.dart';
import 'package:mdw/core/services/storage_services.dart';
import 'package:mdw/core/themes/styles.dart';
import 'package:mdw/features/delivery/screens/main_screen.dart';
import 'package:mdw/shared/utils/snack_bar_utils.dart';
import 'package:pinput/pinput.dart';

import '../../../core/constants/constant.dart';
import '../../../shared/widgets/custom_btn.dart';
import '../../../shared/widgets/custom_loading_indicator.dart';
import '../models/login_user_model.dart';

class CodeVerificationScreen extends StatefulWidget {
  const CodeVerificationScreen({
    super.key,
    required this.head,
    required this.upperText,
    required this.type,
    required this.btnText,
    this.orderId,
    // this.rider,
  });

  final String head, upperText, btnText;
  final int type;
  final String? orderId;

  // final LoginUserModel? rider;

  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  bool isPinVerified = false, loading = false;
  late TextEditingController otpController;
  late LoginUserModel? rider;

  getRider() async {
    final String? temp = await StorageServices.getLoginUserDetails();
    if (temp != null) {
      rider = LoginUserModel.fromRawJson(temp);
      log(rider!.token);
      setState(() {});
    }
  }

  @override
  void initState() {
    otpController = TextEditingController();
    getRider();
    super.initState();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: CustomAppBarTitle(
          title: widget.head,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AppConstant.physics,
          padding: EdgeInsets.only(top: 15, left: 20, right: 20),
          child: Column(
            children: [
              CustomUpperPortion(
                head: widget.upperText,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 7,
              ),
              CustomPinputField(
                otpController: otpController,
              ),
              SizedBox(
                height: 30,
              ),
              if (!loading)
                CustomBtn(
                  onTap: (() async {
                    setState(() {
                      loading = true;
                    });
                    // log(otpController.text.trim().length.toString());
                    if (otpController.text.trim().length != 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Please enter the valid pin.",
                          context: context,
                        ),
                      );
                    } else {
                      if (widget.type == 0 || widget.type == 2) {
                        // http.Response res = await http.put(
                        //   Uri.parse(AppKeys.apiUrlKey +
                        //       AppKeys.ridersKey +
                        //       AppKeys.verifyOTPKey),
                        //   headers: <String, String>{
                        //     'Content-Type': 'application/json; charset=UTF-8',
                        //     "authorization": "Bearer ${rider!.token}",
                        //   },
                        //   body: jsonEncode(<String, dynamic>{
                        //     "orderId": widget.orderId,
                        //     "deliveryCode":
                        //         int.parse(otpController.text.trim()),
                        //   }),
                        // );
                        await StorageServices.setAttendanceStatus(true)
                            .whenComplete(() {
                          if (widget.type == 0) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: ((ctx) => MainScreen()),
                              ),
                            );
                          } else {
                            Navigator.pop(context);
                          }
                        });
                      } else if (widget.type == 1 &&
                          widget.orderId != null &&
                          rider != null) {
                        http.Response res = await http.put(
                          Uri.parse(AppKeys.apiUrlKey +
                              AppKeys.ridersKey +
                              AppKeys.verifyOTPKey),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                            "authorization": "Bearer ${rider!.token}",
                          },
                          body: jsonEncode(<String, dynamic>{
                            "orderId": widget.orderId,
                            "deliveryCode":
                                int.parse(otpController.text.trim()),
                          }),
                        );
                        log(res.body.toString());
                        Map<String, dynamic> resJson = jsonDecode(res.body);

                        if (res.statusCode == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            AppSnackBar().customizedAppSnackBar(
                              message: resJson["message"],
                              context: context,
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            AppSnackBar().customizedAppSnackBar(
                              message: resJson["message"],
                              context: context,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          AppSnackBar().customizedAppSnackBar(
                            message: "Something went wrong. Please try again!",
                            context: context,
                          ),
                        );
                      }
                    }
                    setState(() {
                      loading = false;
                    });
                  }),
                  text: widget.btnText,
                ),
              if (loading) CustomLoadingIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBarTitle extends StatelessWidget {
  const CustomAppBarTitle({
    super.key,
    required this.title,
    this.textColor,
  });

  final String title;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: textColor ?? AppColors.black,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }
}

class CustomPinputField extends StatelessWidget {
  const CustomPinputField({
    super.key,
    required this.otpController,
    // required this.pin,
    // required this.onCompleted,
  });

  // final int pin;
  // final void Function(bool) onCompleted;
  final TextEditingController otpController;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(fontSize: 20, color: Colors.black),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.green),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.green),
      ),
    );
    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.red),
      ),
    );

    return Pinput(
      length: 4,
      controller: otpController,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      errorPinTheme: errorPinTheme,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      // validator: (enteredPin) {
      //   final isValid = enteredPin == pin.toString();
      //   onCompleted(isValid);
      //   return isValid ? null : 'Pin is incorrect';
      // },
    );
  }
}

class CustomUpperPortion extends StatelessWidget {
  const CustomUpperPortion({
    super.key,
    required this.head,
  });

  final String head;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        head,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.black,
        ),
      ),
    );
  }
}
