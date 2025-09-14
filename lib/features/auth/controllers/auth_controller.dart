import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mdw/core/constants/app_keys.dart';
import 'package:mdw/core/services/app_function_services.dart';
import 'package:mdw/core/services/storage_services.dart';
import 'package:mdw/features/auth/screens/code_verification_screen.dart';
import 'package:mdw/features/delivery/screens/main_screen.dart';
import 'package:mdw/features/documents/screens/documents_screen.dart';
import 'package:mdw/shared/utils/snack_bar_utils.dart';

class AuthController {
  /// ✅ Login Function
  static Future<void> handleLogin({
    required BuildContext context,
    required String username,
    required String password,
    required VoidCallback onStart,
    required VoidCallback onComplete,
  }) async {
    onStart();

    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        _showError(context, "No internet connection.");
        onComplete();
        return;
      }

      final response = await http.post(
        Uri.parse(AppKeys.apiUrlKey + AppKeys.loginKey),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'riderId': username,
          'riderLoginPassword': password,
        }),
      );

      final resJson = jsonDecode(response.body);

      if (resJson["success"] == 1) {
        await StorageServices.setLoginUserDetails(resJson);
        await StorageServices.setSignInStatus(true);

        final docs =
            await AppFunctions.getDocs(resJson["rider"]["phoneNumber"]);

        final allDocsSubmitted = docs.aadharFront != null &&
            docs.aadharBack != null &&
            docs.pan != null &&
            docs.dlFront != null &&
            docs.dlBack != null &&
            docs.rcFront != null &&
            docs.rcBack != null;

        if (allDocsSubmitted) {
          await _navigateBasedOnAttendance(context);
        } else {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => const DocumentsScreen(type: 1),
            ),
          );

          if (result != true) {
            _showError(
                context, "Please complete your document verification first.");
            onComplete();
            return;
          }

          await _navigateBasedOnAttendance(context);
        }
      } else {
        _showError(context, resJson["message"]);
      }
    } catch (_) {
      _showError(context, "Something went wrong. Please try again.");
    }

    onComplete();
  }

  /// ✅ Register Function
  static Future<Map<String, dynamic>> registerRider(
      Map<String, dynamic> data) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      return {
        "success": 0,
        "message": "No internet connection",
      };
    }

    final response = await http.post(
      Uri.parse(AppKeys.apiUrlKey + AppKeys.ridersKey + "/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    log(response.body);

    return jsonDecode(response.body);
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBar().customizedAppSnackBar(message: message, context: context),
    );
  }

  static Future<void> _navigateBasedOnAttendance(BuildContext context) async {
    final status = await StorageServices.getAttendanceStatus();
    final Widget nextScreen = status
        ? const MainScreen()
        : const CodeVerificationScreen(
            head: "Attendance",
            upperText:
                "Ask your admin to enter his code to confirm your attendance.",
            type: 0,
            btnText: "Confirm Attendance",
          );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextScreen),
    );
  }
}
