import 'dart:async';
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
  bool isPinVerified = false, loading = false, isSendingOTP = false;
  late TextEditingController otpController;
  late LoginUserModel? rider;
  String otp = "";
  Timer? _resendTimer;
  int _resendSeconds = 30; // cooldown duration

  Future<void> getRider() async {
    final String? temp = await StorageServices.getLoginUserDetails();
    if (temp != null) {
      rider = LoginUserModel.fromRawJson(temp);
      log(rider!.token);
      setState(() {});
    }
  }

  Future<void> sendStartShiftOTP() async {
    setState(() {
      isSendingOTP = true;
    });
    http.Response res = await http.post(
      Uri.parse(AppKeys.apiUrlKey +
          AppKeys.apiKey +
          AppKeys.shiftsKey +
          AppKeys.startOTPKey),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "authorization": "Bearer ${rider!.token}",
      },
      body: jsonEncode(<String, dynamic>{
        "riderId": rider!.rider.riderId,
      }),
    );

    Map<String, dynamic> resJson = jsonDecode(res.body);

    if (res.statusCode == 200) {
      otp = resJson["otp"];
      log("OTP " + otp);
      ScaffoldMessenger.of(context).showSnackBar(
        AppSnackBar().customizedAppSnackBar(
          message: resJson["message"],
          context: context,
        ),
      );
      startResendCooldown();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        AppSnackBar().customizedAppSnackBar(
          message: res.statusCode.toString(),
          context: context,
        ),
      );
    }
    setState(() {
      isSendingOTP = false;
    });
  }

  Future<void> sendEndShiftOTP() async {
    setState(() {
      isSendingOTP = true;
    });
    http.Response res = await http.post(
      Uri.parse(AppKeys.apiUrlKey +
          AppKeys.apiKey +
          AppKeys.shiftsKey +
          AppKeys.endOTPKey),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "authorization": "Bearer ${rider!.token}",
      },
      body: jsonEncode(<String, dynamic>{
        "riderId": rider!.rider.riderId,
      }),
    );

    Map<String, dynamic> resJson = jsonDecode(res.body);

    if (res.statusCode == 200) {
      otp = resJson["otp"];
      log("OTP " + otp);

      ScaffoldMessenger.of(context).showSnackBar(
        AppSnackBar().customizedAppSnackBar(
          message: resJson["message"],
          context: context,
        ),
      );
      startResendCooldown();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        AppSnackBar().customizedAppSnackBar(
          message: res.statusCode.toString(),
          context: context,
        ),
      );
    }
    setState(() {
      isSendingOTP = false;
    });
  }

  Future<void> sendAttendanceOTP() async {
    setState(() {
      isSendingOTP = true;
    });
    http.Response res = await http.post(
      Uri.parse(AppKeys.apiUrlKey + AppKeys.attendanceKey + AppKeys.otpKey),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "authorization": "Bearer ${rider!.token}",
      },
      body: jsonEncode(<String, dynamic>{
        "riderId": rider!.rider.riderId,
      }),
    );

    Map<String, dynamic> resJson = jsonDecode(res.body);

    if (res.statusCode == 200) {
      otp = resJson["otp"];
      log("OTP " + otp);

      ScaffoldMessenger.of(context).showSnackBar(
        AppSnackBar().customizedAppSnackBar(
          message: resJson["message"] + "\nExpires in ${resJson["expiresIn"]}",
          context: context,
        ),
      );
      startResendCooldown();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        AppSnackBar().customizedAppSnackBar(
          message: res.statusCode.toString(),
          context: context,
        ),
      );
    }
    setState(() {
      isSendingOTP = false;
    });
  }

  Future<void> toggleShift(String pin) async {
    Uri uri = Uri.parse(
      '${AppKeys.apiUrlKey}${AppKeys.apiKey}${AppKeys.shiftsKey}${widget.type == 2 ? AppKeys.startShiftKey : AppKeys.endShiftKey}',
    );
    log(uri.toString());
    http.Response res = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "authorization": "Bearer ${rider!.token}",
      },
      body: jsonEncode(<String, dynamic>{
        "riderId": rider!.rider.riderId,
        "otp": pin,
      }),
    );
    Map<String, dynamic> resJson = jsonDecode(res.body);
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        AppSnackBar().customizedAppSnackBar(
            message:
                "Shift ${widget.type == 2 ? "started" : "ended"} successfully",
            context: context),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        AppSnackBar()
            .customizedAppSnackBar(message: resJson["error"], context: context),
      );
    }
  }

  getData() async {
    //0 = Attendance
    //1 = Confirm Delivery
    //2 = Start Shift
    //3= End Shift
    await getRider();
    if (widget.type == 0) {
      await sendAttendanceOTP();
    } else if (widget.type == 2) {
      await sendStartShiftOTP();
    } else if (widget.type == 3) {
      await sendEndShiftOTP();
    }
  }

  // 🔹 Start cooldown timer
  void startResendCooldown() {
    setState(() {
      _resendSeconds = 30;
    });
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() {
          _resendSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    otpController = TextEditingController();
    getData();
    super.initState();
  }

  @override
  void dispose() {
    otpController.dispose();
    _resendTimer?.cancel();
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
              SizedBox(height: 15),
              if (isSendingOTP)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                      width: 10,
                      child: CustomLoadingIndicator(
                        strokeWidth: 1.5,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Sending OTP to your phone number",
                    ),
                  ],
                ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 7,
              ),
              CustomPinputField(
                otpController: otpController,
                pin: otp,
                length:
                    (widget.type == 0 || widget.type == 2 || widget.type == 3)
                        ? 6
                        : 4,
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
                    if (otpController.text.trim().length !=
                        ((widget.type == 0 ||
                                widget.type == 2 ||
                                widget.type == 3)
                            ? 6
                            : 4)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Please enter the valid pin.",
                          context: context,
                        ),
                      );
                    } else {
                      if (widget.type == 0) {
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

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (ctx) => MainScreen()),
                        );
                      } else if (widget.type == 1 &&
                          widget.orderId != null &&
                          rider != null) {
                        http.Response res = await http.put(
                          Uri.parse(AppKeys.apiUrlKey +
                              AppKeys.ridersKey +
                              AppKeys.markDAKey),
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
                          List<String> lastOrderIds =
                              await StorageServices.getLastOrderIDs() ?? [];
                          lastOrderIds.add(widget.orderId ?? "");
                          await StorageServices.setLastOrderIDs(lastOrderIds);
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
                      } else if (widget.type == 2 && rider != null) {
                        await toggleShift(otpController.text.trim());
                      } else if (widget.type == 3 && rider != null) {
                        await toggleShift(otpController.text.trim());
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
              SizedBox(height: 20),
              if (_resendSeconds > 0)
                Text(
                  "Resend available in $_resendSeconds sec",
                  style: TextStyle(color: Colors.grey),
                )
              else
                TextButton(
                  onPressed: () async {
                    if (widget.type == 0) {
                      await sendAttendanceOTP();
                    } else if (widget.type == 1) {
                    } else if (widget.type == 2) {
                      await sendStartShiftOTP();
                    } else if (widget.type == 3) {
                      await sendEndShiftOTP();
                    }
                  },
                  child: Text(
                    "Resend OTP",
                    style: TextStyle(
                      color: AppColors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
    required this.length,
    required this.pin,
    // required this.onCompleted,
  });

  final String pin;

  // final void Function(bool) onCompleted;
  final TextEditingController otpController;
  final int length;

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
      length: length,
      controller: otpController,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      errorPinTheme: errorPinTheme,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      validator: (enteredPin) {
        if (pin.isNotEmpty) {
          final isValid = enteredPin == pin;
          // onCompleted(isValid);
          return isValid ? null : 'Pin is incorrect';
        }
        return null;
      },
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
