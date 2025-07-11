import 'dart:convert';
import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mdw/models/login_user_model.dart';
import 'package:mdw/screens/documents_screen.dart';
import 'package:mdw/screens/onboarding_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant.dart';
import '../models/file_type_model.dart';
import '../services/app_function_services.dart';
import '../services/app_keys.dart';
import '../services/storage_services.dart';
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
  bool loading = false, obscure = true, confirmObscure = true, agree = false;
  FileTypeModel? aadharFront, aadharBack, pan;
  String? user;
  late LoginUserModel u;

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
  void dispose() {
    nameTextController.dispose();
    desTextController.dispose();
    idProofTextController.dispose();
    vTypeTextController.dispose();
    vNumberTextController.dispose();
    emailTextController.dispose();
    passTextController.dispose();
    confirmPassTextController.dispose();
    phoneTextController.dispose();
    addressTextController.dispose();
    riderIdProofTextController.dispose();
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
                    head: "Rider Id Proof Type",
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
                    textCapitalization: TextCapitalization.characters,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    textEditingController: emailTextController,
                    head: "Email",
                    hint: "johndoe@example.com",
                    keyboard: TextInputType.emailAddress,
                    validator: ((val) {
                      if (!EmailValidator.validate(
                          emailTextController.text.trim())) {
                        return "Please check the email";
                      }
                      return null;
                    }),
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
                    validator: AppFunctions.phoneNumberValidator,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: agree,
                        checkColor: AppColors.white,
                        activeColor: AppColors.green,
                        side: BorderSide(
                          color: AppColors.green,
                          width: 1.5,
                        ),
                        onChanged: ((val) {
                          setState(() {
                            agree = val ?? false;
                          });
                        }),
                      ),
                      SizedBox(width: 5),
                      Text("Agree to the"),
                      SizedBox(width: 3),
                      GestureDetector(
                        onTap: (() async {
                          String url =
                              "https://3vra7mgrlh.ufs.sh/f/b8iVQa6UTCDiDZh0htaHs1edfE6n4JLPrBvlqxtkybQipAX9";
                          if (await canLaunchUrl(Uri.parse(url))) {
                            launchUrl(
                              Uri.parse(url),
                              mode: LaunchMode.inAppBrowserView,
                            );
                          }
                        }),
                        child: Text(
                          "T&C",
                          style: TextStyle(
                            color: AppColors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 3),
                      Text("and"),
                      SizedBox(width: 3),
                      GestureDetector(
                        onTap: (() async {
                          String url =
                              "https://3vra7mgrlh.ufs.sh/f/b8iVQa6UTCDinfEtogAsJ2h95gpP4froiO6IYxwBQSM3qduW";
                          if (await canLaunchUrl(Uri.parse(url))) {
                            launchUrl(
                              Uri.parse(url),
                              mode: LaunchMode.inAppBrowserView,
                            );
                          }
                        }),
                        child: Text(
                          "Privacy Policy",
                          style: TextStyle(
                            color: AppColors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text("."),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
              if (!loading)
                CustomBtn(
                  onTap: () async {
                    // Start loading
                    setState(() {
                      loading = true;
                    });

                    // Basic validation: all required fields must be filled
                    final fieldsFilled = nameTextController.text.isNotEmpty &&
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
                            confirmPassTextController.text.trim();

                    if (!fieldsFilled) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Please fill all the fields correctly",
                          context: context,
                        ),
                      );
                      setState(() {
                        loading = false;
                      });
                      return;
                    }

                    // Password strength check
                    final passwordError = AppFunctions.passwordValidator(
                        passTextController.text.trim());

                    if (passwordError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: passwordError,
                          context: context,
                        ),
                      );
                      setState(() {
                        loading = false;
                      });
                      return;
                    }

                    // T&C agreement check
                    if (!agree) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Please agree to the T&C and Privacy Policy",
                          context: context,
                        ),
                      );
                      setState(() {
                        loading = false;
                      });
                      return;
                    }

                    // Proceed to register
                    try {
                      final http.Response res = await http.post(
                        Uri.parse(AppKeys.apiUrlKey + AppKeys.ridersKey + "/"),
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
                          "riderLoginPassword": passTextController.text.trim(),
                          "idProofUrl": idProofTextController.text.trim(),
                          "riderIdProof":
                              riderIdProofTextController.text.trim(),
                          "paymentReceived": 0,
                        }),
                      );

                      final Map<String, dynamic> resJson = jsonDecode(res.body);
                      log(res.body);
                      log(res.statusCode.toString());

                      if (resJson["success"] == 1) {
                        final rider = Rider.fromJson(resJson["rider"]);

                        ScaffoldMessenger.of(context).showSnackBar(
                          AppSnackBar().customizedAppSnackBar(
                            message:
                                "Rider: ${rider.name}\nRider ID: ${rider.riderId}\n${resJson["message"]}",
                            context: context,
                          ),
                        );

                        await getDocs(); // Fetch docs from storage

                        // If no docs, open DocumentsScreen and wait for result
                        if (aadharFront == null &&
                            aadharBack == null &&
                            pan == null) {
                          final bool? result = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const DocumentsScreen(type: 1),
                            ),
                          );

                          if (result != true) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              AppSnackBar().customizedAppSnackBar(
                                message:
                                    "Please complete your document verification.",
                                context: context,
                              ),
                            );
                            setState(() {
                              loading = false;
                            });
                            return;
                          }
                        }

                        // All good → Navigate to LoginScreen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => const LoginScreen(),
                          ),
                        );
                      } else {
                        if (res.statusCode == 500) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            AppSnackBar().customizedAppSnackBar(
                              message:
                                  resJson["message"] + "\n" + resJson["error"],
                              context: context,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            AppSnackBar().customizedAppSnackBar(
                              message: resJson["message"],
                              context: context,
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message:
                              "Registration failed. Please try again later.",
                          context: context,
                        ),
                      );
                    }

                    // Stop loading at the end
                    setState(() {
                      loading = false;
                    });
                  },
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
