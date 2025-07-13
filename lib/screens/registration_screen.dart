import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mdw/models/login_user_model.dart';
import 'package:mdw/models/rider_docs_model.dart';
import 'package:mdw/screens/documents_screen.dart';
import 'package:mdw/screens/onboarding_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
      // desTextController,
      idProofTextController,
      vTypeTextController,
      vNumberTextController,
      emailTextController,
      passTextController,
      confirmPassTextController,
      phoneTextController,
      addressTextController,
      riderIdProofTextController;
  bool loading = false,
      obscure = true,
      confirmObscure = true,
      agree = false,
      docRes = false,
      stepperFinished = false;

  // FileTypeModel? aadharFront, aadharBack, pan, dlFront, dlBack, rcFront, rcBack;
  String? user;
  late LoginUserModel u;
  int currentStep = 0, changed = 0;
  List<int> completedSteps = [];
  List<int> startedSteps = [];
  String? previousPhone;

  @override
  void initState() {
    nameTextController = TextEditingController();
    // desTextController = TextEditingController();
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
    // desTextController.dispose();
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

  // Future<void> getDocs() async {
  //   user = await StorageServices.getLoginUserDetails();
  //   if (user != null) {
  //     u = LoginUserModel.fromRawJson(user!);
  //     aadharFront = await StorageServices.getAadharFront(u.rider.riderId);
  //     aadharBack = await StorageServices.getAadharBack(u.rider.riderId);
  //     pan = await StorageServices.getPan(u.rider.riderId);
  //   }
  //   setState(() {});
  // }

  String TC_LINK =
      "https://3vra7mgrlh.ufs.sh/f/b8iVQa6UTCDiDZh0htaHs1edfE6n4JLPrBvlqxtkybQipAX9";
  String PRIVACY_POLICY_LINK =
      "https://3vra7mgrlh.ufs.sh/f/b8iVQa6UTCDinfEtogAsJ2h95gpP4froiO6IYxwBQSM3qduW";

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView);
    }
  }

  void _trimAllFields() {
    nameTextController.text = nameTextController.text.trim();
    emailTextController.text = emailTextController.text.trim();
    phoneTextController.text = phoneTextController.text.trim();
    addressTextController.text = addressTextController.text.trim();
    vTypeTextController.text = vTypeTextController.text.trim();
    vNumberTextController.text = vNumberTextController.text.trim();
    idProofTextController.text = idProofTextController.text.trim();
    riderIdProofTextController.text = riderIdProofTextController.text.trim();
    passTextController.text = passTextController.text.trim();
    confirmPassTextController.text = confirmPassTextController.text.trim();
  }

  Future<void> _handleRegister() async {
    setState(() => loading = true);
    if (loading) return;

    _trimAllFields();
// Check if all fields are filled
    final fieldsFilled = nameTextController.text.isNotEmpty &&
        emailTextController.text.isNotEmpty &&
        phoneTextController.text.isNotEmpty &&
        addressTextController.text.isNotEmpty &&
        vTypeTextController.text.isNotEmpty &&
        vNumberTextController.text.isNotEmpty &&
        idProofTextController.text.isNotEmpty &&
        riderIdProofTextController.text.isNotEmpty &&
        passTextController.text.trim().isNotEmpty &&
        confirmPassTextController.text.trim().isNotEmpty &&
        passTextController.text.trim() == confirmPassTextController.text.trim();

    if (!fieldsFilled) {
      _showError("Please fill all the fields correctly");
      return;
    }

    // Validate password strength
    final passwordError =
        AppFunctions.passwordValidator(passTextController.text.trim());
    if (passwordError != null) {
      _showError(passwordError);
      return;
    }

    // Check T&C agreement
    if (!agree) {
      _showError("Please agree to the T&C and Privacy Policy");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(AppKeys.apiUrlKey + AppKeys.ridersKey + "/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": nameTextController.text.trim(),
          "email": emailTextController.text.trim(),
          "address": addressTextController.text.trim(),
          "vehicleNumber": vNumberTextController.text.trim(),
          "vehicleType": vTypeTextController.text.trim(),
          "phoneNumber": phoneTextController.text.trim(),
          "riderLoginPassword": passTextController.text.trim(),
          "idProofUrl": idProofTextController.text.trim(),
          "riderIdProof": riderIdProofTextController.text.trim(),
          "paymentReceived": 0,
        }),
      );

      final Map<String, dynamic> resJson = jsonDecode(response.body);
      log(response.body);

      if (resJson["success"] == 1) {
        final rider = Rider.fromJson(resJson["rider"]);

        ScaffoldMessenger.of(context).showSnackBar(
          AppSnackBar().customizedAppSnackBar(
            message:
                "Rider: ${rider.name}\nRider ID: ${rider.riderId}\n${resJson["message"]}",
            context: context,
          ),
        );

        // await getDocs();
        RiderDocsModel rd = await AppFunctions.getDocs(rider.phoneNumber);

        // If documents missing → open DocumentsScreen
        if (rd.aadharFront == null &&
            rd.aadharBack == null &&
            rd.pan == null &&
            rd.dlFront == null &&
            rd.dlBack == null &&
            rd.rcFront == null &&
            rd.rcBack == null) {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => const DocumentsScreen(type: 1),
            ),
          );

          if (result != true) {
            _showError("Please complete your document verification.");
            return;
          }
        }

        // All good → go to Login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        _showError(resJson["message"] +
            (resJson["error"] != null ? "\n${resJson["error"]}" : ""));
      }
    } catch (e) {
      String errorMsg = "Registration failed. Please try again.";
      if (e is SocketException) {
        errorMsg = "No internet connection. Please check your network.";
      }
      _showError(errorMsg);
      log("Register error: $e");
    }

    setState(() => loading = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBar().customizedAppSnackBar(
        message: message,
        context: context,
      ),
    );
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white,
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
          padding: const EdgeInsets.all(15),
          physics: AppConstant.physics,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stepper(
                physics: NeverScrollableScrollPhysics(),
                type: StepperType.vertical,
                currentStep: currentStep,
                onStepContinue: (() async {
                  if (!startedSteps.contains(currentStep)) {
                    startedSteps.add(currentStep);
                  }

                  // STEP 0: Rider Details Validation
                  if (currentStep == 0) {
                    final currentPhone = phoneTextController.text.trim();

                    // Validate Rider Details
                    if (nameTextController.text.trim().isEmpty ||
                        AppFunctions.nameValidator(
                                nameTextController.text.trim()) !=
                            null ||
                        !EmailValidator.validate(
                            emailTextController.text.trim()) ||
                        AppFunctions.phoneNumberValidator(currentPhone) !=
                            null ||
                        AppFunctions.addressValidator(
                                addressTextController.text.trim()) !=
                            null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Please fill all Rider Details correctly.",
                          context: context,
                        ),
                      );
                      return;
                    }

                    /// 🌟 Detect if phone number has changed
                    if (previousPhone != null &&
                        previousPhone != currentPhone) {
                      // Delete old documents
                      await AppFunctions.removeAllDocsForPhone(previousPhone!);

                      docRes = false;
                      changed = 0;
                      // Optionally clear local copies
                    }

                    // Update the previousPhone to current
                    previousPhone = currentPhone;

                    // Check for documents
                    RiderDocsModel rd =
                        await AppFunctions.getDocs(currentPhone);

                    final allDocsUploaded = rd.pan != null &&
                        rd.aadharFront != null &&
                        rd.aadharBack != null &&
                        rd.dlFront != null &&
                        rd.dlBack != null &&
                        rd.rcFront != null &&
                        rd.rcBack != null;

                    if (allDocsUploaded) {
                      setState(() {
                        if (!completedSteps.contains(0)) completedSteps.add(0);
                        if (!completedSteps.contains(1)) completedSteps.add(1);
                        docRes = true;
                        currentStep = 2;
                      });
                    } else {
                      // Open DocumentsScreen
                      final bool? docResult = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DocumentsScreen(
                            type: 1,
                            phone: currentPhone,
                          ),
                        ),
                      );

                      if (docResult == true) {
                        setState(() {
                          if (!completedSteps.contains(0))
                            completedSteps.add(0);
                          if (!completedSteps.contains(1))
                            completedSteps.add(1);
                          docRes = true;
                          currentStep = 2;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Please complete your document verification."),
                          ),
                        );
                      }
                    }

                    return;
                  }

                  // STEP 2: Vehicle Details Validation
                  if (currentStep == 2) {
                    if (AppFunctions.riderVehicleTypeValidator(
                                vTypeTextController.text.trim()) !=
                            null ||
                        AppFunctions.indianVehicleNumberValidator(
                                vNumberTextController.text.trim()) !=
                            null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Please enter valid Vehicle Details.",
                          context: context,
                        ),
                      );
                      return;
                    }

                    setState(() {
                      if (!completedSteps.contains(2)) completedSteps.add(2);
                      currentStep = 3;
                    });
                    return;
                  }

                  // STEP 3: ID Proof Details
                  if (currentStep == 3) {
                    if (AppFunctions.riderIdProofTypeValidator(
                                riderIdProofTextController.text.trim()) !=
                            null ||
                        AppFunctions.urlValidator(
                                idProofTextController.text.trim()) !=
                            null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Please enter valid ID Proof details.",
                          context: context,
                        ),
                      );
                      return;
                    }

                    setState(() {
                      if (!completedSteps.contains(3)) completedSteps.add(3);
                      currentStep = 4;
                    });
                    return;
                  }

                  // STEP 4: Password + Confirmation
                  // STEP 4: Password + Confirmation
                  if (currentStep == 4) {
                    if (AppFunctions.passwordValidator(
                                passTextController.text.trim()) !=
                            null ||
                        passTextController.text.trim() !=
                            confirmPassTextController.text.trim()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Please enter valid and matching passwords.",
                          context: context,
                        ),
                      );
                      return;
                    }

                    setState(() {
                      if (!completedSteps.contains(4)) completedSteps.add(4);
                      if (!completedSteps.contains(5)) completedSteps.add(5);
                      stepperFinished = true;
                      currentStep = 5; // Move to "Completed" step
                    });

                    return;
                  }

                  // Any other step
                  setState(() {
                    if (!completedSteps.contains(currentStep)) {
                      completedSteps.add(currentStep);
                    }
                    currentStep++;
                  });
                }),
                onStepCancel: () {
                  setState(() {
                    if (currentStep > 0) currentStep--;
                  });
                },
                controlsBuilder: (context, details) {
                  if (currentStep == 5) {
                    // Hide Continue and Cancel on final "Completed" step
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

                  // Default controls for other steps
                  return Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        CustomBtn(
                          onTap: details.onStepContinue ?? (() {}),
                          text: "Continue",
                          horizontalPadding: 20,
                          horizontalMargin: 15,
                          verticalPadding: 10,
                        ),
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
                },
                steps: [
                  //0
                  Step(
                    title: const Text("Rider Details"),
                    isActive: true,
                    state: completedSteps.contains(0)
                        ? StepState.complete
                        : startedSteps.contains(0)
                            ? StepState.editing
                            : StepState.indexed,
                    // You can change based on validation
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        CustomTextField(
                          textEditingController: nameTextController,
                          head: "Name",
                          hint: "Enter Your Name",
                          keyboard: TextInputType.name,
                          validator: AppFunctions.nameValidator,
                        ),
                        const SizedBox(height: 15),

                        // Email
                        CustomTextField(
                          textEditingController: emailTextController,
                          head: "Email",
                          hint: "johndoe@example.com",
                          keyboard: TextInputType.emailAddress,
                          validator: (val) {
                            if (!EmailValidator.validate(val?.trim() ?? '')) {
                              return "Please check the email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        // Phone Number
                        CustomTextField(
                          textEditingController: phoneTextController,
                          head: "Phone Number",
                          hint: "XXXXX-XXXXX",
                          keyboard: TextInputType.phone,
                          validator: AppFunctions.phoneNumberValidator,
                        ),
                        const SizedBox(height: 15),

                        // Address
                        CustomTextField(
                          textEditingController: addressTextController,
                          head: "Address",
                          hint: "Enter Your Address",
                          keyboard: TextInputType.streetAddress,
                          isMultiline: true,
                          validator: AppFunctions.addressValidator,
                        ),
                      ],
                    ),
                  ),
                  //1
                  Step(
                    isActive: true,
                    state: completedSteps.contains(1)
                        ? StepState.complete
                        : startedSteps.contains(1)
                            ? StepState.editing
                            : StepState.indexed,
                    title: Text("Documents Upload"),
                    content: docRes
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text("Documents uploaded successfully."),
                              if (changed != 0) SizedBox(height: 10),
                              if (changed != 0)
                                Text("Documents updated: $changed"),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("Want to update?"),
                                  SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: (() async {
                                      final bool? docResult =
                                          await Navigator.push<bool>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => DocumentsScreen(
                                            type: 1,
                                            phone:
                                                emailTextController.text.trim(),
                                          ),
                                        ),
                                      );
                                      if (docResult ?? false) {
                                        setState(() {
                                          changed++;
                                        });
                                      }
                                    }),
                                    child: Text(
                                      "change",
                                      style: TextStyle(
                                        color: AppColors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        : SizedBox(),
                  ),
                  //2
                  Step(
                    isActive: true,
                    state: completedSteps.contains(2)
                        ? StepState.complete
                        : startedSteps.contains(2)
                            ? StepState.editing
                            : StepState.indexed,
                    title: Text("Vehicle Details"),
                    content: Column(
                      children: [
                        CustomTextField(
                          textEditingController: vTypeTextController,
                          head: "Rider Vehicle Type",
                          hint: "Bike",
                          keyboard: TextInputType.name,
                          validator: AppFunctions.riderVehicleTypeValidator,
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
                          validator: AppFunctions.indianVehicleNumberValidator,
                        ),
                      ],
                    ),
                  ),
                  //3
                  Step(
                    isActive: true,
                    state: completedSteps.contains(3)
                        ? StepState.complete
                        : startedSteps.contains(3)
                            ? StepState.editing
                            : StepState.indexed,
                    title: Text("ID Proof Details"),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          textEditingController: riderIdProofTextController,
                          head: "Rider Id Proof Type",
                          hint: "Proof Document Type",
                          keyboard: TextInputType.text,
                          validator: AppFunctions.riderIdProofTypeValidator,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          textEditingController: idProofTextController,
                          head: "Rider Id Proof",
                          hint: "Proof URL",
                          keyboard: TextInputType.url,
                          validator: AppFunctions.urlValidator,
                        ),
                      ],
                    ),
                  ),
                  //4
                  Step(
                    isActive: true,
                    state: completedSteps.contains(4)
                        ? StepState.complete
                        : startedSteps.contains(4)
                            ? StepState.editing
                            : StepState.indexed,
                    title: Text("Set Password"),
                    content: Column(
                      children: [
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
                      ],
                    ),
                  ),
                  //5
                  Step(
                    title: Text("Completed"),
                    isActive: true,
                    state: completedSteps.contains(5)
                        ? StepState.complete
                        : StepState.indexed,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "🎉 Complete!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Congratulations! You’ve successfully filled out all the required details.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Please tap the register button below to finalize your onboarding.",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Checkbox with terms and policy
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

              const SizedBox(height: 15),

              if (!loading)
                CustomBtn(
                  onTap: _handleRegister,
                  text: "Register",
                ),
              if (loading) const CustomLoadingIndicator(),
              const SizedBox(height: 15),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
