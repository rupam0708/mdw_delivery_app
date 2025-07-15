import 'package:flutter/material.dart';

import '../../../core/services/app_function_services.dart';

class LoginController extends ChangeNotifier {
  // Loading state
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Login fields
  String _username = '';
  String _password = '';
  bool _obscurePassword = true;

  String get username => _username;

  String get password => _password;

  bool get obscurePassword => _obscurePassword;

  // Setters
  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void startLoading() {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }
  }

  void stopLoading() {
    if (_isLoading) {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Form validation
  String? validateUsername(String? val) {
    if (val == null || val.trim().isEmpty) return "Please enter your username";
    return null;
  }

  String? validatePassword(String? val) {
    return AppFunctions.passwordValidator(val);
  }

  bool get isFormValid =>
      validateUsername(_username) == null &&
      validatePassword(_password) == null;
}
