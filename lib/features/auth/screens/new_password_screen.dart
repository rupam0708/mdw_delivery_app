import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mdw/features/auth/controllers/new_password_controller.dart';
import 'package:mdw/features/auth/screens/code_verification_screen.dart';
import 'package:mdw/shared/widgets/custom_btn.dart';
import 'package:mdw/shared/widgets/custom_loading_indicator.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_keys.dart';
import '../../../core/constants/constant.dart';
import '../../../core/services/app_function_services.dart';
import '../../../core/themes/styles.dart';
import '../../../shared/utils/snack_bar_utils.dart';
import '../widgets/custom_text_field.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen(
      {super.key, required this.otp, required this.riderId});

  final String otp, riderId;

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _newPassTextController, _confirmPassTextController;

  @override
  void initState() {
    _newPassTextController = TextEditingController();
    _confirmPassTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _newPassTextController.clear();
    _confirmPassTextController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newPasswordController = Provider.of<NewPasswordController>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: CustomAppBarTitle(
          title: "Enter new password",
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AppConstant.physics,
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              CustomUpperPortion(
                head: "Please enter your new password",
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      head: "New Password",
                      hint: "Enter new password",
                      keyboard: TextInputType.visiblePassword,
                      obscure: newPasswordController.obscureNewPassword,
                      suffix: GestureDetector(
                        onTap: newPasswordController.togglePasswordVisibility,
                        child: Icon(
                          newPasswordController.obscureNewPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.black.withAlpha(128),
                        ),
                      ),
                      textEditingController: _newPassTextController,
                      validator: (val) => AppFunctions.passwordValidator(val),
                    ),
                    SizedBox(height: 15),
                    CustomTextField(
                      head: "Confirm Password",
                      hint: "Re-enter password",
                      keyboard: TextInputType.visiblePassword,
                      obscure: newPasswordController.obscureConfirmPassword,
                      suffix: GestureDetector(
                        onTap: newPasswordController
                            .toggleConfirmPasswordVisibility,
                        child: Icon(
                          newPasswordController.obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.black.withAlpha(128),
                        ),
                      ),
                      textEditingController: _confirmPassTextController,
                      validator: (val) => AppFunctions.passwordValidator(val),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              if (!newPasswordController.isLoading)
                CustomBtn(
                  onTap: (() async {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    if (!_formKey.currentState!.validate())
                      return;
                    else if (_newPassTextController.text.trim() !=
                        _confirmPassTextController.text.trim()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Passwords doesn't match",
                          context: context,
                        ),
                      );
                    } else {
                      newPasswordController.toggleIsLoadingVisibility();
                      http.Response res = await http.post(
                        Uri.parse(AppKeys.apiUrlKey +
                            AppKeys.ridersKey +
                            AppKeys.resetPassKey),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(<String, dynamic>{
                          "riderId": widget.riderId,
                          "otp": widget.otp,
                          "newPassword": _newPassTextController.text.trim(),
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
                        newPasswordController.toggleIsLoadingVisibility();
                        Navigator.pop(context);
                      } else {
                        newPasswordController.toggleIsLoadingVisibility();
                        ScaffoldMessenger.of(context).showSnackBar(
                          AppSnackBar().customizedAppSnackBar(
                            message: resJson["message"],
                            context: context,
                          ),
                        );
                      }
                    }
                  }),
                  text: "Update",
                )
              else
                CustomLoadingIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
