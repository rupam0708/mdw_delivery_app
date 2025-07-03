import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mdw/models/login_user_model.dart';
import 'package:mdw/screens/onboarding_screen.dart';

import '../constant.dart';
import '../services/app_function_services.dart';
import '../services/app_keys.dart';
import '../styles.dart';
import '../utils/snack_bar_utils.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late TextEditingController nameTextController,
      desTextController,
      idProofTextController,
      vTypeTextController,
      vNumberTextController,
      emailTextController,
      passTextController,
      confirmPassTextController,
      phoneTextController,
      addressTextController,
      riderIdProofTextController;
  bool loading = false, obscure = true, confirmObscure = true;

  @override
  void initState() {
    nameTextController = TextEditingController();
    desTextController = TextEditingController();
    idProofTextController = TextEditingController();
    vTypeTextController = TextEditingController();
    vNumberTextController = TextEditingController();
    emailTextController = TextEditingController();
    passTextController = TextEditingController();
    confirmPassTextController = TextEditingController();
    phoneTextController = TextEditingController();
    addressTextController = TextEditingController();
    riderIdProofTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Register your account",
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
              Column(
                children: [
                  CustomTextField(
                    // textCapitalization: TextCapitalization.characters,
                    textEditingController: nameTextController,
                    head: "Name",
                    hint: "Enter Your Name",
                    keyboard: TextInputType.name,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    textEditingController: desTextController,
                    head: "Description",
                    hint: "Enter Your Description",
                    keyboard: TextInputType.multiline,
                    isMultiline: true,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    // textCapitalization: TextCapitalization.characters,
                    textEditingController: riderIdProofTextController,
                    head: "Rider Id Proof",
                    hint: "Proof Document Type",
                    keyboard: TextInputType.text,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    // textCapitalization: TextCapitalization.characters,
                    textEditingController: idProofTextController,
                    head: "Rider Id Proof",
                    hint: "Proof URL",
                    keyboard: TextInputType.url,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    textEditingController: vTypeTextController,
                    head: "Rider Vehicle Type",
                    hint: "Bike",
                    keyboard: TextInputType.name,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    textEditingController: vNumberTextController,
                    head: "Rider Vehicle Number",
                    hint: "xx-xx-xxx-xxxx",
                    keyboard: TextInputType.text,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    textEditingController: emailTextController,
                    head: "Email",
                    hint: "johndoe@example.com",
                    keyboard: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    textEditingController: passTextController,
                    head: "Rider Login Password",
                    hint: "********",
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
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    textEditingController: confirmPassTextController,
                    head: "Confirm Rider Login Password",
                    hint: "********",
                    keyboard: TextInputType.visiblePassword,
                    obscure: confirmObscure,
                    suffix: GestureDetector(
                      onTap: (() {
                        setState(() {
                          confirmObscure = !confirmObscure;
                        });
                      }),
                      child: Icon(
                        confirmObscure
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: AppColors.black.withValues(alpha: 0.4),
                      ),
                    ),
                    validator: ((value) {
                      if (passTextController.text.trim() !=
                          confirmPassTextController.text.trim()) {
                        return "Password is not matching";
                      }
                      return null;
                    }),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    textEditingController: phoneTextController,
                    head: "Phone Number",
                    hint: "xxxxx-xxxxx",
                    keyboard: TextInputType.phone,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    textEditingController: addressTextController,
                    head: "Address",
                    hint: "Enter Your Address",
                    keyboard: TextInputType.streetAddress,
                    isMultiline: true,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
              if (!loading)
                CustomBtn(
                  onTap: (() async {
                    setState(() {
                      loading = true;
                    });
                    if (nameTextController.text.isNotEmpty &&
                        desTextController.text.isNotEmpty &&
                        idProofTextController.text.isNotEmpty &&
                        vTypeTextController.text.isNotEmpty &&
                        vNumberTextController.text.isNotEmpty &&
                        emailTextController.text.isNotEmpty &&
                        passTextController.text.isNotEmpty &&
                        phoneTextController.text.isNotEmpty &&
                        addressTextController.text.isNotEmpty &&
                        riderIdProofTextController.text.isNotEmpty &&
                        passTextController.text.trim() ==
                            confirmPassTextController.text.trim()) {
                      if (AppFunctions.passwordValidator(
                              passTextController.text.trim()) !=
                          null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          AppSnackBar().customizedAppSnackBar(
                              message: AppFunctions.passwordValidator(
                                      passTextController.text.trim()) ??
                                  "",
                              context: context),
                        );
                      } else {
                        final http.Response res = await http.post(
                          Uri.parse(
                              AppKeys.apiUrlKey + AppKeys.ridersKey + "/"),
                          headers: {
                            "content-type": "application/json",
                          },
                          body: jsonEncode({
                            'name': nameTextController.text.trim(),
                            'email': emailTextController.text.trim(),
                            'address': addressTextController.text.trim(),
                            "vehicleNumber": vNumberTextController.text.trim(),
                            "vehicleType": vTypeTextController.text.trim(),
                            "phoneNumber": phoneTextController.text.trim(),
                            "riderLoginPassword":
                                passTextController.text.trim(),
                            "idProofUrl": idProofTextController.text.trim(),
                            "riderIdProof":
                                riderIdProofTextController.text.trim(),
                            "paymentReceived": 0,
                          }),
                        );
                        log(res.body);
                        final Map<String, dynamic> resJson =
                            jsonDecode(res.body);
                        // log(resJson.toString());
                        Rider rider = Rider.fromJson(resJson["rider"]);

                        if (resJson["success"] == 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            AppSnackBar().customizedAppSnackBar(
                              message: "Rider: ${rider.name}" +
                                  "\n" +
                                  "Rider ID: ${rider.riderId}" +
                                  "\n" +
                                  resJson["message"],
                              context: context,
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: ((ctx) => LoginScreen()),
                            ),
                          );
                        } else {
                          setState(() {
                            loading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            AppSnackBar().customizedAppSnackBar(
                              message: resJson["message"],
                              context: context,
                            ),
                          );
                        }
                      }
                    } else {
                      setState(() {
                        loading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Please fill all the fields correctly",
                          context: context,
                        ),
                      );
                    }
                    setState(() {
                      loading = false;
                    });
                  }),
                  text: "Register",
                ),
              if (loading) CustomLoadingIndicator(),
              SizedBox(height: 10),
              if (!loading)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: (() {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: ((ctx) => LoginScreen()),
                          ),
                        );
                      }),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
