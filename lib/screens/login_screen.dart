import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mdw/screens/onboarding_screen.dart';
import 'package:mdw/screens/registration_screen.dart';
import 'package:mdw/services/app_function_services.dart';
import 'package:mdw/services/app_keys.dart';
import 'package:mdw/services/storage_services.dart';
import 'package:mdw/styles.dart';
import 'package:mdw/utils/snack_bar_utils.dart';

import '../constant.dart';
import '../models/file_type_model.dart';
import '../models/login_user_model.dart';
import 'code_verification_screen.dart';
import 'documents_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _usernameTextController, _passwordTextController;
  late FocusNode _userNameFocusNode, _passwordFocusNode;
  bool obscure = true, loading = false;
  FileTypeModel? aadharFront, aadharBack, pan;
  String? user;
  late LoginUserModel u;

  @override
  void initState() {
    _userNameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _usernameTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _userNameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _usernameTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  Future<void> getDocs() async {
    user = await StorageServices.getLoginUserDetails();
    if (user != null) {
      u = LoginUserModel.fromRawJson(user!);
      aadharFront = await StorageServices.getAadharFront(u.rider.riderId);
      aadharBack = await StorageServices.getAadharBack(u.rider.riderId);
      pan = await StorageServices.getPan(u.rider.riderId);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Login to your account",
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AppConstant.physics,
          padding: EdgeInsets.only(top: 15, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  "Good to see you again, enter your details\nbelow to continue.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.black,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 7,
              ),
              Column(
                children: [
                  CustomTextField(
                    focusNode: _userNameFocusNode,
                    // textCapitalization: TextCapitalization.characters,
                    textEditingController: _usernameTextController,
                    head: "Username",
                    hint: "Enter Username",
                    keyboard: TextInputType.emailAddress,
                    // validator: (value) => EmailValidator.validate(value!)
                    //     ? null
                    //     : "Please enter a valid email",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    focusNode: _passwordFocusNode,
                    textEditingController: _passwordTextController,
                    head: "Password",
                    hint: "Enter password",
                    keyboard: TextInputType.visiblePassword,
                    obscure: obscure,
                    suffix: GestureDetector(
                      onTap: (() {
                        setState(() {
                          obscure = !obscure;
                        });
                      }),
                      child: Icon(
                        obscure
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: AppColors.black.withValues(alpha: 0.4),
                      ),
                    ),
                    validator: ((value) =>
                        AppFunctions.passwordValidator(value)),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
              ),
              if (!loading)
                CustomBtn(
                  onTap: (() async {
                    setState(() {
                      loading = true;
                    });
                    if (_usernameTextController.text.isNotEmpty &&
                        _passwordTextController.text.isNotEmpty) {
                      if (AppFunctions.passwordValidator(
                              _passwordTextController.text.trim()) !=
                          null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          AppSnackBar().customizedAppSnackBar(
                              message: AppFunctions.passwordValidator(
                                      _passwordTextController.text.trim()) ??
                                  "",
                              context: context),
                        );
                      } else {
                        final http.Response res = await http.post(
                            Uri.parse(AppKeys.apiUrlKey + AppKeys.loginKey),
                            headers: {
                              "content-type": "application/json",
                            },
                            body: jsonEncode({
                              'riderId': _usernameTextController.text.trim(),
                              'riderLoginPassword':
                                  _passwordTextController.text.trim(),
                            }));
                        final Map<String, dynamic> resJson =
                            jsonDecode(res.body);
                        // log(resJson.toString());

                        if (resJson["success"] == 1) {
                          await StorageServices.setLoginUserDetails(resJson);
                          await StorageServices.setSignInStatus(true);

                          bool attendanceStatus =
                              await StorageServices.getAttendanceStatus();
                          await getDocs();

                          if (aadharFront != null &&
                              aadharBack != null &&
                              pan != null) {
                            // Directly check attendance and navigate
                            if (attendanceStatus) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => MainScreen()),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      const CodeVerificationScreen(
                                    head: "Attendance",
                                    upperText:
                                        "Ask your admin to enter his code to confirm your attendance.",
                                    type: 0,
                                    btnText: "Confirm Attendance",
                                  ),
                                ),
                              );
                            }
                          } else {
                            // Navigate to document screen and wait for it to complete
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => DocumentsScreen(type: 0)),
                            );

                            // Re-check attendance status (if it might change)
                            attendanceStatus =
                                await StorageServices.getAttendanceStatus();

                            // After returning from DocumentsScreen
                            if (attendanceStatus) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => MainScreen()),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      const CodeVerificationScreen(
                                    head: "Attendance",
                                    upperText:
                                        "Ask your admin to enter his code to confirm your attendance.",
                                    type: 0,
                                    btnText: "Confirm Attendance",
                                  ),
                                ),
                              );
                            }
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            AppSnackBar().customizedAppSnackBar(
                              message: resJson["message"],
                              context: context,
                            ),
                          );
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Please fill the Username and Password",
                          context: context,
                        ),
                      );
                    }
                    // if (!EmailValidator.validate(
                    //     _emailTextController.text.trim())) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     AppSnackBar().customizedAppSnackBar(
                    //         message: "Please enter a valid email.",
                    //         context: context),
                    //   );
                    // } else if (AppFunctions.passwordValidator(
                    //         _passwordTextController.text.trim()) !=
                    //     null) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     AppSnackBar().customizedAppSnackBar(
                    //         message: AppFunctions.passwordValidator(
                    //                 _passwordTextController.text.trim()) ??
                    //             "",
                    //         context: context),
                    //   );
                    // } else {
                    //   await StorageServices.setSignInStatus(true)
                    //       .whenComplete(() async {
                    //     bool attendanceStatus =
                    //         await AppFunctions.getAttendanceStatus();
                    //     if (attendanceStatus) {
                    //       Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: ((ctx) => MainScreen()),
                    //         ),
                    //       );
                    //     } else {
                    //       Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: ((ctx) => const CodeVerificationScreen(
                    //                 head: "Attendance",
                    //                 upperText:
                    //                     "Ask your admin to enter his code to confirm your attendance.",
                    //                 type: 0,
                    //                 btnText: "Confirm Attendance",
                    //               )),
                    //         ),
                    //       );
                    //     }
                    //   });
                    // }
                    setState(() {
                      loading = false;
                    });
                  }),
                  text: "Login to my account",
                ),
              if (loading) CustomLoadingIndicator(),
              SizedBox(height: 10),
              if (!loading)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: (() {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: ((ctx) => RegistrationScreen()),
                          ),
                        );
                      }),
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.green,
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.head,
    required this.hint,
    required this.keyboard,
    this.validator,
    required this.textEditingController,
    this.obscure,
    this.suffix,
    this.textCapitalization,
    this.focusNode,
    this.inputFormatters,
    this.isMultiline,
  });

  final String head, hint;
  final TextInputType keyboard;
  final String? Function(String?)? validator;
  final TextEditingController textEditingController;
  final bool? obscure;
  final Widget? suffix;
  final TextCapitalization? textCapitalization;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final bool? isMultiline;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final GlobalKey<FormFieldState> formFieldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bool multiline = widget.isMultiline ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Text(
            widget.head,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          focusNode: widget.focusNode,
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.none,
          obscureText: widget.obscure ?? false,
          key: formFieldKey,
          onChanged: (value) {
            formFieldKey.currentState?.validate();
          },
          controller: widget.textEditingController,
          style: const TextStyle(color: AppColors.black, fontSize: 15),
          validator: widget.validator,
          keyboardType: multiline ? TextInputType.multiline : widget.keyboard,
          inputFormatters: widget.inputFormatters,
          cursorColor: AppColors.green,
          maxLines: multiline ? null : 1,
          minLines: multiline ? 5 : 1,
          decoration: InputDecoration(
            suffixIcon: widget.suffix,
            contentPadding: const EdgeInsets.all(15),
            hintText: widget.hint,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.black.withOpacity(0.1),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.black.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.green.withOpacity(0.7),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.red),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}
