import 'package:flutter/material.dart';
import 'package:mdw/core/services/app_function_services.dart';
import 'package:mdw/core/themes/styles.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constant.dart';
import '../../../../shared/widgets/custom_btn.dart';
import '../../../../shared/widgets/custom_loading_indicator.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/login_controller.dart';
import '../../models/login_user_model.dart';
import '../../widgets/custom_text_field.dart';
import '../regisration/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameTextController, _passwordTextController;
  late FocusNode _userNameFocusNode, _passwordFocusNode;

  // bool obscure = true, loading = false;

  // FileTypeModel? aadharFront, aadharBack, pan;
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

  Future<void> handleLogin(LoginController controller) async {
    if (!_formKey.currentState!.validate()) return;

    await AuthController.handleLogin(
      context: context,
      username: _usernameTextController.text.trim(),
      password: _passwordTextController.text.trim(),
      onStart: controller.startLoading,
      onComplete: controller.stopLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginController = Provider.of<LoginController>(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AppConstant.physics,
          padding: EdgeInsets.only(top: 15, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  'assets/1.png',
                  height: 280,
                ),
              ),
              SizedBox(height: 50),
              Center(
                child: Text(
                  "Good to see you again, enter your details below to continue.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      head: "Username",
                      hint: "Enter Username",
                      keyboard: TextInputType.text,
                      textEditingController: _usernameTextController,
                      validator: (val) => val == null || val.isEmpty
                          ? "Please enter your username"
                          : null,
                    ),
                    SizedBox(height: 15),
                    CustomTextField(
                      head: "Password",
                      hint: "Enter password",
                      keyboard: TextInputType.visiblePassword,
                      obscure: loginController.obscurePassword,
                      suffix: GestureDetector(
                        onTap: loginController.togglePasswordVisibility,
                        child: Icon(
                          loginController.obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.black.withOpacity(0.5),
                        ),
                      ),
                      textEditingController: _passwordTextController,
                      validator: (val) => AppFunctions.passwordValidator(val),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              if (!loginController.isLoading)
                CustomBtn(
                  onTap: (() => handleLogin(loginController)),
                  text: "Login to my account",
                ),
              if (loginController.isLoading) CustomLoadingIndicator(),
              SizedBox(height: 10),
              if (!loginController.isLoading)
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
