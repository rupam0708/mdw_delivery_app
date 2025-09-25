import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:mdw/features/auth/models/login_user_model.dart';
import 'package:mdw/features/auth/screens/regisration/steps/step_city_store.dart';
import 'package:mdw/features/auth/screens/regisration/steps/step_completed.dart';
import 'package:mdw/features/auth/screens/regisration/steps/step_documents.dart';
import 'package:mdw/features/auth/screens/regisration/steps/step_id_proof.dart';
import 'package:mdw/features/auth/screens/regisration/steps/step_job_type.dart';
import 'package:mdw/features/auth/screens/regisration/steps/step_password.dart';
import 'package:mdw/features/auth/screens/regisration/steps/step_rider_details.dart';
import 'package:mdw/features/auth/screens/regisration/steps/step_tshirt_bag.dart';
import 'package:mdw/features/auth/screens/regisration/steps/step_vehicle_details.dart';
import 'package:mdw/features/documents/models/rider_docs_model.dart';
import 'package:mdw/features/documents/screens/documents_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/constant.dart';
import '../../../../core/services/app_function_services.dart';
import '../../../../core/themes/styles.dart';
import '../../../../shared/utils/snack_bar_utils.dart';
import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/custom_btn.dart';
import '../../../../shared/widgets/custom_loading_indicator.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/registration_controller.dart';
import '../../widgets/build_stepper_indicator.dart';
import '../login/login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // late TextEditingController nameTextController,
  //     // desTextController,
  //     idProofTextController,
  //     vTypeTextController,
  //     vNumberTextController,
  //     emailTextController,
  //     passTextController,
  //     confirmPassTextController,
  //     phoneTextController,
  //     addressTextController,
  //     riderIdProofTextController;

  // bool loading = false,
  //     obscure = true,
  //     confirmObscure = true,
  //     agree = false,
  //     docRes = false,
  //     stepperFinished = false;

  // FileTypeModel? aadharFront, aadharBack, pan, dlFront, dlBack, rcFront, rcBack;
  String? user;
  late LoginUserModel u;

  // int currentStep = 0, changed = 0;
  // List<int> completedSteps = [];
  // List<int> startedSteps = [];
  // String? previousPhone;

  @override
  void initState() {
    // nameTextController = TextEditingController();
    // // desTextController = TextEditingController();
    // idProofTextController = TextEditingController();
    // vTypeTextController = TextEditingController();
    // vNumberTextController = TextEditingController();
    // emailTextController = TextEditingController();
    // passTextController = TextEditingController();
    // confirmPassTextController = TextEditingController();
    // phoneTextController = TextEditingController();
    // addressTextController = TextEditingController();
    // riderIdProofTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // nameTextController.dispose();
    // // desTextController.dispose();
    // idProofTextController.dispose();
    // vTypeTextController.dispose();
    // vNumberTextController.dispose();
    // emailTextController.dispose();
    // passTextController.dispose();
    // confirmPassTextController.dispose();
    // phoneTextController.dispose();
    // addressTextController.dispose();
    // riderIdProofTextController.dispose();
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

  // void _launchURL(String url) async {
  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView);
  //   }
  // }

  // void _trimAllFields() {
  //   nameTextController.text = nameTextController.text.trim();
  //   emailTextController.text = emailTextController.text.trim();
  //   phoneTextController.text = phoneTextController.text.trim();
  //   addressTextController.text = addressTextController.text.trim();
  //   vTypeTextController.text = vTypeTextController.text.trim();
  //   vNumberTextController.text = vNumberTextController.text.trim();
  //   idProofTextController.text = idProofTextController.text.trim();
  //   riderIdProofTextController.text = riderIdProofTextController.text.trim();
  //   passTextController.text = passTextController.text.trim();
  //   confirmPassTextController.text = confirmPassTextController.text.trim();
  // }

  Future<void> _handleRegister(
      BuildContext context, RegistrationController controller) async {
    controller.setLoading(true);

    final fieldsFilled = controller.nameController.text.isNotEmpty &&
        controller.emailController.text.isNotEmpty &&
        controller.phoneController.text.isNotEmpty &&
        controller.addressController.text.isNotEmpty &&
        controller.vNumberController.text.isNotEmpty &&
        controller.idProofUrlController.text.isNotEmpty &&
        controller.passController.text == controller.confirmPassController.text;

    if (!fieldsFilled) {
      SnackBarUtils.showError(
          context, "Please fill all the fields correctly", controller);
      return;
    }

    final passwordError =
        AppFunctions.passwordValidator(controller.passController.text);
    if (passwordError != null) {
      SnackBarUtils.showError(context, passwordError, controller);
      return;
    }

    if (!controller.agree) {
      SnackBarUtils.showError(
          context, "Please agree to the T&C and Privacy Policy", controller);

      return;
    }

    try {
      final result = await AuthController.registerRider({
        "name": controller.nameController.text,
        "email": controller.emailController.text,
        "address": controller.addressController.text,
        "vehicleNumber": controller.vNumberController.text,
        "vehicleType": controller.selectedVehicleType,
        "phoneNumber": controller.phoneController.text,
        "riderLoginPassword": controller.passController.text,
        "idProofUrl": controller.idProofUrlController.text,
        "riderIdProof": controller.selectedIdProofType,
        "paymentReceived": 0,
      });

      if (result["success"] == 1) {
        final rider = Rider.fromJson(result["rider"]);

        ScaffoldMessenger.of(context).showSnackBar(
          AppSnackBar().customizedAppSnackBar(
            message:
                "Rider: ${rider.name}\nRider ID: ${rider.riderId}\n${result["message"]}",
            context: context,
            duration: 10000,
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
            SnackBarUtils.showError(context,
                "Please complete your document verification.", controller);
            return;
          }
        }

        // All good → go to Login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        SnackBarUtils.showError(context, result["message"], controller);
      }
    } catch (e) {
      SnackBarUtils.showError(
          context, "Registration failed. Please try again.", controller);
    }

    controller.setLoading(false);
  }

//   Future<void> _handleRegister() async {
//     if (loading) return;
//
//     setState(() => loading = true);
//
//     _trimAllFields();
// // Check if all fields are filled
//     final fieldsFilled = nameTextController.text.isNotEmpty &&
//         emailTextController.text.isNotEmpty &&
//         phoneTextController.text.isNotEmpty &&
//         addressTextController.text.isNotEmpty &&
//         vTypeTextController.text.isNotEmpty &&
//         vNumberTextController.text.isNotEmpty &&
//         idProofTextController.text.isNotEmpty &&
//         riderIdProofTextController.text.isNotEmpty &&
//         passTextController.text.trim().isNotEmpty &&
//         confirmPassTextController.text.trim().isNotEmpty &&
//         passTextController.text.trim() == confirmPassTextController.text.trim();
//
//     if (!fieldsFilled) {
//       _showError("Please fill all the fields correctly");
//       return;
//     }
//
//     // Validate password strength
//     final passwordError =
//         AppFunctions.passwordValidator(passTextController.text.trim());
//     if (passwordError != null) {
//       _showError(passwordError);
//       return;
//     }
//
//     // Check T&C agreement
//     if (!agree) {
//       _showError("Please agree to the T&C and Privacy Policy");
//       return;
//     }
//
//     try {
//       final response = await http.post(
//         Uri.parse(AppKeys.apiUrlKey + AppKeys.ridersKey + "/"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "name": nameTextController.text.trim(),
//           "email": emailTextController.text.trim(),
//           "address": addressTextController.text.trim(),
//           "vehicleNumber": vNumberTextController.text.trim(),
//           "vehicleType": vTypeTextController.text.trim(),
//           "phoneNumber": phoneTextController.text.trim(),
//           "riderLoginPassword": passTextController.text.trim(),
//           "idProofUrl": idProofTextController.text.trim(),
//           "riderIdProof": riderIdProofTextController.text.trim(),
//           "paymentReceived": 0,
//         }),
//       );
//
//       final Map<String, dynamic> resJson = jsonDecode(response.body);
//       log(response.body);
//
//       if (resJson["success"] == 1) {
//         final rider = Rider.fromJson(resJson["rider"]);
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           AppSnackBar().customizedAppSnackBar(
//             message:
//                 "Rider: ${rider.name}\nRider ID: ${rider.riderId}\n${resJson["message"]}",
//             context: context,
//           ),
//         );
//
//         // await getDocs();
//         RiderDocsModel rd = await AppFunctions.getDocs(rider.phoneNumber);
//
//         // If documents missing → open DocumentsScreen
//         if (rd.aadharFront == null &&
//             rd.aadharBack == null &&
//             rd.pan == null &&
//             rd.dlFront == null &&
//             rd.dlBack == null &&
//             rd.rcFront == null &&
//             rd.rcBack == null) {
//           final result = await Navigator.push<bool>(
//             context,
//             MaterialPageRoute(
//               builder: (_) => const DocumentsScreen(type: 1),
//             ),
//           );
//
//           if (result != true) {
//             _showError("Please complete your document verification.");
//             return;
//           }
//         }
//
//         // All good → go to Login
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const LoginScreen()),
//         );
//       } else {
//         _showError(resJson["message"] +
//             (resJson["error"] != null ? "\n${resJson["error"]}" : ""));
//       }
//     } catch (e) {
//       String errorMsg = "Registration failed. Please try again.";
//       if (e is SocketException) {
//         errorMsg = "No internet connection. Please check your network.";
//       }
//       _showError(errorMsg);
//       log("Register error: $e");
//     }
//
//     setState(() => loading = false);
//   }

  // void _showError(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     AppSnackBar().customizedAppSnackBar(
  //       message: message,
  //       context: context,
  //     ),
  //   );
  //   setState(() => loading = false);
  // }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RegistrationController>(context);
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
              Center(
                child: Image.asset(
                  'assets/2.png',
                  height: 250,
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: Text(
                  "Start your delivery journey with\nMy Dawai Wala",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Stepper(
                physics: NeverScrollableScrollPhysics(),
                type: StepperType.vertical,
                currentStep: controller.currentStep,
                margin: EdgeInsets.zero,
                stepIconBuilder: (step, state) {
                  if (state == StepState.complete) {
                    return build_stepper_indicator(
                      step: step,
                      child: Icon(
                        Icons.check_circle,
                        color: AppColors.white,
                        size: 15,
                      ),
                    );
                  } else if (state == StepState.editing) {
                    return build_stepper_indicator(
                      step: step,
                      child: Icon(
                        Icons.edit,
                        color: AppColors.white,
                        size: 15,
                      ),
                    );
                  } else if (state == StepState.error) {
                    return build_stepper_indicator(
                      step: step,
                      child: Icon(
                        Icons.error,
                        color: AppColors.red,
                        size: 15,
                      ),
                    );
                  } else {
                    return build_stepper_indicator(
                      step: step,
                      child: Text(
                        '${step + 1}',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                },
                onStepContinue: () async {
                  controller.startCurrentStep();
                  final step = controller.currentStep;

                  // STEP 0: Rider Details
                  if (step == 0) {
                    final phone = controller.phoneController.text.trim();
                    final name = controller.nameController.text.trim();
                    final email = controller.emailController.text.trim();
                    final address = controller.addressController.text.trim();

                    final isValid = name.isNotEmpty &&
                        AppFunctions.nameValidator(name) == null &&
                        EmailValidator.validate(email) &&
                        AppFunctions.phoneNumberValidator(phone) == null &&
                        AppFunctions.addressValidator(address) == null;

                    if (!isValid) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Please fill all Rider Details correctly.",
                          context: context,
                        ),
                      );
                      return;
                    }

                    // Handle phone change
                    if (controller.previousPhone != null &&
                        controller.previousPhone != phone) {
                      await AppFunctions.removeAllDocsForPhone(
                          controller.previousPhone!);
                      controller.setDocRes(false);
                      controller.changed = 0;
                    }
                    controller.previousPhone = phone;

                    // Check if documents are uploaded
                    final docs = await controller.fetchDocs(phone);
                    final allDocsUploaded = docs.pan != null &&
                        docs.aadharFront != null &&
                        docs.aadharBack != null &&
                        docs.dlFront != null &&
                        docs.dlBack != null &&
                        docs.rcFront != null &&
                        docs.rcBack != null;

                    if (allDocsUploaded) {
                      controller.markCompleted(0);
                      controller.markCompleted(1);
                      controller.setDocRes(true);
                      controller.setStep(2);
                    } else {
                      final bool? docResult = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DocumentsScreen(type: 1, phone: phone),
                        ),
                      );

                      if (docResult == true) {
                        controller.markCompleted(0);
                        controller.markCompleted(1);
                        controller.setDocRes(true);
                        controller.setStep(2);
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

                  // STEP 2: Vehicle Details
                  if (step == 2) {
                    final vehicleNumber =
                        controller.vNumberController.text.trim();
                    final isValid = AppFunctions.indianVehicleNumberValidator(
                            vehicleNumber) ==
                        null;

                    if (!isValid) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Please enter valid Vehicle Details.",
                          context: context,
                        ),
                      );
                      return;
                    }

                    controller.markCompleted(2);
                    controller.setStep(3);
                    return;
                  }

                  // STEP 3: ID Proof
                  if (step == 3) {
                    final idProofUrl =
                        controller.idProofUrlController.text.trim();
                    final isValid =
                        AppFunctions.urlValidator(idProofUrl) == null;

                    if (!isValid) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Please enter valid ID Proof details.",
                          context: context,
                        ),
                      );
                      return;
                    }

                    controller.markCompleted(3);
                    controller.setStep(4);
                    return;
                  }

                  // STEP 4: City & Store (no validation)
                  if (step == 4) {
                    controller.markCompleted(4);
                    controller.setStep(5);
                    return;
                  }

                  // STEP 5: Job Type (no validation)
                  if (step == 5) {
                    controller.markCompleted(5);
                    controller.setStep(6);
                    return;
                  }

                  // STEP 6: T-shirt & Bag (optional)
                  if (step == 6) {
                    controller.markCompleted(6);
                    controller.setStep(7);
                    return;
                  }

                  // STEP 7: Password
                  if (step == 7) {
                    final pass = controller.passController.text.trim();
                    final confirmPass =
                        controller.confirmPassController.text.trim();

                    final isValid =
                        AppFunctions.passwordValidator(pass) == null &&
                            pass == confirmPass;

                    if (!isValid) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Please enter valid and matching passwords.",
                          context: context,
                        ),
                      );
                      return;
                    }

                    controller.markCompleted(7);
                    controller.markCompleted(8);
                    controller.setStepperFinished(true);
                    controller.setStep(8);
                    return;
                  }

                  // FINAL STEP: Completed
                  controller.nextStep(); // step 8 → no-op or stay
                },
                onStepCancel: () {
                  // setState(() {
                  //   if (currentStep > 0) currentStep--;
                  // });
                  controller.backStep();
                },
                controlsBuilder: (context, details) {
                  if (controller.currentStep == 8) {
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
                        if (controller.currentStep != 0)
                          const SizedBox(width: 10),
                        if (controller.currentStep != 0)
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
                    state: AppFunctions.getStepState(controller, 0),
                    content: StepRiderDetails(
                      nameController: controller.nameController,
                      emailController: controller.emailController,
                      phoneController: controller.phoneController,
                      addressController: controller.addressController,
                    ),
                  ),
                  //1
                  Step(
                    isActive: true,
                    state: AppFunctions.getStepState(controller, 1),
                    title: Text("Documents Upload"),
                    content: StepDocuments(
                      docRes: controller.docRes,
                      changed: controller.changed,
                      phone: controller.phoneController.text.trim(),
                      onDocChanged: () {
                        // setState(() {
                        //   changed++;
                        // });
                        controller.updateChangedCount();
                      },
                    ),
                  ),
                  //2
                  Step(
                    isActive: true,
                    state: AppFunctions.getStepState(controller, 2),
                    title: Text("Vehicle Details"),
                    content: StepVehicleDetails(
                      controller: controller,
                    ),
                  ),
                  //3
                  Step(
                    isActive: true,
                    state: AppFunctions.getStepState(controller, 3),
                    title: Text("ID Proof Details"),
                    content: StepIdProof(
                      controller: controller,
                    ),
                  ),
                  //4
                  Step(
                    isActive: true,
                    state: AppFunctions.getStepState(controller, 4),
                    title: Text("City and Store"),
                    content: StepCityAndStore(
                      controller: controller,
                    ),
                  ),
                  //5
                  Step(
                    isActive: true,
                    state: AppFunctions.getStepState(controller, 5),
                    title: Text("Job Type"),
                    content: StepJobType(controller: controller),
                  ),
                  //6
                  Step(
                    isActive: true,
                    state: AppFunctions.getStepState(controller, 6),
                    title: Text("Get T-Shirt and Bag"),
                    content: StepTshirtAndBag(controller: controller),
                  ),
                  //7
                  Step(
                    isActive: true,
                    state: AppFunctions.getStepState(controller, 7),
                    title: Text("Set Password"),
                    content: StepPassword(
                      passwordController: controller.passController,
                      confirmPasswordController:
                          controller.confirmPassController,
                      obscure: controller.obscure,
                      confirmObscure: controller.confirmObscure,
                      // onToggleObscure: () => setState(() => obscure = !obscure),
                      // onToggleConfirmObscure: () =>
                      //     setState(() => confirmObscure = !confirmObscure),
                      onToggleObscure: controller.toggleObscure,
                      onToggleConfirmObscure: controller.toggleConfirmObscure,
                    ),
                  ),
                  //8
                  Step(
                    title: Text("Completed"),
                    isActive: true,
                    state: AppFunctions.getStepState(controller, 8),
                    content: const StepCompleted(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Checkbox with terms and policy
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: controller.agree,
                    checkColor: AppColors.white,
                    activeColor: AppColors.green,
                    side: BorderSide(
                      color: AppColors.green,
                      width: 1.5,
                    ),
                    onChanged: ((val) {
                      // setState(() {
                      //   agree = val ?? false;
                      // });
                      controller.toggleAgree(val);
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

              if (!controller.loading)
                CustomBtn(
                  onTap: (() => _handleRegister(context, controller)),
                  text: "Register",
                ),
              if (controller.loading) const CustomLoadingIndicator(),
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
