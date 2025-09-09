import 'dart:convert';
import 'dart:developer';

import 'package:mdw/core/constants/app_keys.dart';
import 'package:mdw/features/documents/models/file_type_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageServices {
  static Future<void> clearStorage() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove(AppKeys.signInStatusKey);
    await pref.remove(AppKeys.attendanceStatusKey);
    await pref.remove(AppKeys.loginKey);
    await pref.remove(AppKeys.profilePicKey);
  }

  static Future<void> removeRCFront(String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(AppKeys.rcFrontKey + "/" + uname);
  }

  static Future<void> removeRCBack(String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(AppKeys.rcBackKey + "/" + uname);
  }

  static Future<void> removeDLFront(String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(AppKeys.dlFrontKey + "/" + uname);
  }

  static Future<void> removeDLBack(String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(AppKeys.dlBackKey + "/" + uname);
  }

  static Future<void> removeAadharFront(String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove(AppKeys.aadharFrontKey + "/" + uname);
  }

  static Future<void> removeAadharBack(String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove(AppKeys.aadharBackKey + "/" + uname);
  }

  static Future<void> removePan(String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove(AppKeys.panKey + "/" + uname);
  }

  static Future<void> setSignInStatus(bool status) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(AppKeys.signInStatusKey, status);
  }

  static Future<void> setAttendanceStatus(bool status) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(AppKeys.attendanceStatusKey, status);
  }

  static Future<void> setLoginUserDetails(Map<String, dynamic> user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(AppKeys.loginKey, jsonEncode(user));
  }

  static Future<void> setRCFront(FileTypeModel file, String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(AppKeys.rcFrontKey + "/" + uname, file.toJsonString());
  }

  static Future<void> setRCBack(FileTypeModel file, String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(AppKeys.rcBackKey + "/" + uname, file.toJsonString());
  }

  static Future<void> setDLFront(FileTypeModel file, String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(AppKeys.dlFrontKey + "/" + uname, file.toJsonString());
  }

  static Future<void> setDLBack(FileTypeModel file, String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(AppKeys.dlBackKey + "/" + uname, file.toJsonString());
  }

  static Future<void> setAadharFront(FileTypeModel file, String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(AppKeys.aadharFrontKey + "/" + uname, file.toJsonString());
  }

  static Future<void> setAadharBack(FileTypeModel file, String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(AppKeys.aadharBackKey + "/" + uname, file.toJsonString());
  }

  static Future<void> setPan(FileTypeModel file, String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(AppKeys.panKey + "/" + uname, file.toJsonString());
  }

  static Future<void> setProfilePic(FileTypeModel file) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(AppKeys.profilePicKey, file.toJsonString());
  }

  static Future<void> setLastOrderIDs(List<String> orderIDs) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList(AppKeys.lastOrderIdKey, orderIDs);
  }

  static Future<void> clearLastOrderIDs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(AppKeys.lastOrderIdKey);
  }

  static Future<bool> hasLastOrderIDs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.containsKey(AppKeys.lastOrderIdKey);
  }

  static Future<List<String>?> getLastOrderIDs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // log(pref.getKeys().toString());
    return pref.getStringList(AppKeys.lastOrderIdKey);
  }

  static Future<FileTypeModel?> getProfilePic() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final data = pref.getString(AppKeys.profilePicKey);
    if (data != null) {
      return FileTypeModel.fromJson(jsonDecode(data));
    } else {
      return null;
    }
  }

  static Future<FileTypeModel?> getPan(String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final data = pref.getString(AppKeys.panKey + "/" + uname);
    if (data != null) {
      return FileTypeModel.fromJson(jsonDecode(data));
    } else {
      return null;
    }
  }

  static Future<FileTypeModel?> getAadharBack(String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final data = pref.getString(AppKeys.aadharBackKey + "/" + uname);
    if (data != null) {
      return FileTypeModel.fromJson(jsonDecode(data));
    } else {
      return null;
    }
  }

  static Future<FileTypeModel?> getAadharFront(String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final data = pref.getString(AppKeys.aadharFrontKey + "/" + uname);
    if (data != null) {
      print(jsonDecode(data).runtimeType);

      return FileTypeModel.fromJson(jsonDecode(data));
    } else {
      return null;
    }
  }

  static Future<FileTypeModel?> getRCFront(String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final data = pref.getString(AppKeys.rcFrontKey + "/" + uname);
    if (data != null) {
      return FileTypeModel.fromJson(jsonDecode(data));
    } else {
      return null;
    }
  }

  static Future<FileTypeModel?> getRCBack(String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final data = pref.getString(AppKeys.rcBackKey + "/" + uname);
    if (data != null) {
      return FileTypeModel.fromJson(jsonDecode(data));
    } else {
      return null;
    }
  }

  static Future<FileTypeModel?> getDLFront(String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final data = pref.getString(AppKeys.dlFrontKey + "/" + uname);
    if (data != null) {
      return FileTypeModel.fromJson(jsonDecode(data));
    } else {
      return null;
    }
  }

  static Future<FileTypeModel?> getDLBack(String uname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final data = pref.getString(AppKeys.dlBackKey + "/" + uname);
    if (data != null) {
      return FileTypeModel.fromJson(jsonDecode(data));
    } else {
      return null;
    }
  }

  static Future<String?> getLoginUserDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    log(pref.getKeys().toString());
    return pref.getString(AppKeys.loginKey);
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
