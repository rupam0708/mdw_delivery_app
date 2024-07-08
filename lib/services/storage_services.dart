import 'package:mdw/services/app_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageServices {
  static Future<void> setSignInStatus(bool status) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(AppKeys.signInStatusKey, status);
  }

  static Future<void> setAttendanceStatus(bool status) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(AppKeys.attendanceStatusKey, status);
  }

  static Future<bool> getSignInStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(AppKeys.signInStatusKey) ?? false;
  }

  static Future<bool> getAttendanceStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(AppKeys.attendanceStatusKey) ?? false;
  }
}
