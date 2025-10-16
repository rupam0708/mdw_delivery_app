import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mdw/core/services/app_function_services.dart';
import 'package:mdw/core/themes/styles.dart';
import 'package:mdw/features/delivery/models/orders_model.dart';
import 'package:mdw/shared/widgets/custom_btn.dart';
import 'package:mdw/shared/widgets/custom_loading_indicator.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/constants/app_keys.dart';
import '../../../core/services/storage_services.dart';
import '../../../shared/utils/snack_bar_utils.dart';
import '../../auth/models/login_user_model.dart';
import '../../auth/screens/code_verification_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.order});

  final Order order;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String paymentType = "CASH", qrLink = "";
  LoginUserModel? rider;
  bool isLoading = false;
  int currentStep = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    await getRiderDetails();
  }

  Future<void> getRiderDetails() async {
    final user = await StorageServices.getLoginUserDetails();
    if (user != null) {
      rider = LoginUserModel.fromRawJson(user);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: CustomAppBarTitle(
          title: "Payment",
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stepper(
              type: StepperType.vertical,
              margin: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              currentStep: currentStep,
              onStepContinue: (() async {
                if (currentStep == 0) {
                  setState(() {
                    isLoading = true;
                  });
                  http.Response res = await http.post(
                    Uri.parse(AppKeys.apiUrlKey +
                        AppKeys.apiKey +
                        AppKeys.cashCollectionKey +
                        AppKeys.selectPaymentMethodKey),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                      "authorization": "Bearer ${rider!.token}",
                    },
                    body: jsonEncode(<String, dynamic>{
                      "orderId": widget.order.orderId,
                      "paymentMethod": paymentType,
                      "riderId": rider!.rider.riderId,
                    }),
                  );

                  log(res.statusCode.toString() + " " + res.body);
                  Map<String, dynamic> resJson = jsonDecode(res.body);

                  ScaffoldMessenger.of(context).clearSnackBars();

                  if (res.statusCode == 200 || res.statusCode == 400) {
                    currentStep++;
                    if (paymentType == "UPI") {
                      qrLink = widget.order.paymentCollection?.upiQrUrl ?? "";
                    }
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    AppSnackBar().customizedAppSnackBar(
                      message: resJson["message"],
                      context: context,
                    ),
                  );

                  setState(() {
                    isLoading = false;
                  });
                } else if (currentStep == 1) {
                  setState(() {
                    isLoading = true;
                  });

                  if (paymentType == "CASH") {
                    http.Response res = await http.post(
                      Uri.parse(AppKeys.apiUrlKey +
                          AppKeys.apiKey +
                          AppKeys.cashCollectionKey +
                          AppKeys.markCashCollectedKey),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        "authorization": "Bearer ${rider!.token}",
                      },
                      body: jsonEncode(<String, dynamic>{
                        "orderId": widget.order.orderId,
                        "collectedAmount": widget.order.amount,
                        "riderId": rider!.rider.riderId,
                      }),
                    );

                    log(res.statusCode.toString() + " " + res.body);
                    Map<String, dynamic> resJson = jsonDecode(res.body);

                    if (res.statusCode == 200 || res.statusCode == 400) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: resJson["message"],
                          context: context,
                        ),
                      );
                      if (paymentType == "CASH") {
                        await StorageServices.setToSubmitCashOrderIDs(
                            widget.order.orderId);
                      }
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CodeVerificationScreen(
                            head: "Code Verification",
                            upperText:
                                "Enter the code to confirm the delivery\nof the order.",
                            type: 1,
                            btnText: "Confirm Order",
                            orderId: widget.order.orderId,
                            order: widget.order,
                          ),
                        ),
                      );
                    }
                  } else if (paymentType == "UPI") {
                    http.Response res = await http.post(
                      Uri.parse(AppKeys.apiUrlKey +
                          AppKeys.apiKey +
                          AppKeys.cashCollectionKey +
                          AppKeys.markCashSubmittedKey),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        "authorization": "Bearer ${rider!.token}",
                      },
                      body: jsonEncode(<String, dynamic>{
                        "orderId": widget.order.orderId,
                        "submittedAmount": widget.order.amount,
                        "riderId": rider!.rider.riderId,
                      }),
                    );

                    log(res.statusCode.toString() + " " + res.body);
                    Map<String, dynamic> resJson = jsonDecode(res.body);

                    if (res.statusCode == 200 || res.statusCode == 400) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: resJson["message"],
                          context: context,
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CodeVerificationScreen(
                            head: "Code Verification",
                            upperText:
                                "Enter the code to confirm the delivery\nof the order.",
                            type: 1,
                            btnText: "Confirm Order",
                            orderId: widget.order.orderId,
                            order: widget.order,
                          ),
                        ),
                      );
                    }
                  }

                  setState(() {
                    isLoading = false;
                  });
                }
              }),
              onStepCancel: (() {
                if (currentStep != 0) {
                  setState(() {
                    currentStep--;
                  });
                }
              }),
              controlsBuilder: ((ctx, details) {
                if (currentStep == 2) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: TextButton(
                      onPressed: details.onStepCancel,
                      child: Text(
                        'Back',
                        style: TextStyle(
                          color: AppColors.green,
                        ),
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      if (!isLoading)
                        CustomBtn(
                          onTap: details.onStepContinue ?? (() {}),
                          text: currentStep == 0
                              ? "Confirm"
                              : currentStep == 1
                                  ? "Collected"
                                  : "Continue",
                          horizontalPadding: 20,
                          horizontalMargin: 1,
                          verticalPadding: 10,
                        )
                      else
                        CustomLoadingIndicator(),
                      if (currentStep != 0) const SizedBox(width: 10),
                      if (currentStep != 0)
                        TextButton(
                          onPressed: details.onStepCancel,
                          child: Text(
                            'Back',
                            style: TextStyle(
                              color: AppColors.green,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
              steps: [
                Step(
                  title: Text("Select Payment Type"),
                  content: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: AppColors.customDecoration,
                    child: DropdownButton<String>(
                      value: paymentType,
                      isExpanded: true,
                      underline: Container(),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      items: const [
                        DropdownMenuItem(
                          value: "CASH",
                          child: Text("CASH"),
                        ),
                        DropdownMenuItem(
                          value: "UPI",
                          child: Text("UPI"),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() {
                          paymentType = val ?? "NULL";
                        });
                      },
                    ),
                  ),
                ),
                Step(
                  title: Text(
                      "${AppFunctions.capitalizeFirstLetter(paymentType.toLowerCase())} Collected"),
                  content: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: AppColors.customDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "OrderID: ",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 15,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                widget.order.orderId,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: AppColors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Name: ",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 15,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                widget.order.customer.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: AppColors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total: ",
                              style: TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              "₹${widget.order.amount}",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: AppColors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (qrLink.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "QR Code",
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          if (qrLink.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
          if (qrLink.isNotEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: QrImageView(
                  data: qrLink,
                  version: QrVersions.auto,
                  size: MediaQuery.of(context).size.width - 100,
                ),
              ),
            )
        ],
      ),
    );
  }
}
