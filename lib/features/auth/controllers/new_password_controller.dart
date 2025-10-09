import 'package:flutter/cupertino.dart';

class NewPasswordController extends ChangeNotifier {
  bool _obscureNewPassword = true;

  bool get obscureNewPassword => _obscureNewPassword;

  void togglePasswordVisibility() {
    _obscureNewPassword = !_obscureNewPassword;
    notifyListeners();
  }

  bool _obscureConfirmPassword = true;

  bool get obscureConfirmPassword => _obscureConfirmPassword;

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void toggleIsLoadingVisibility() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}
