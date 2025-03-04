import 'dart:io';

import 'package:flutter/cupertino.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mdw/services/storage_services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/feedback_model.dart';

class AppFunctions {
  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = value.contains(RegExp(r'[a-z]'));
    bool hasDigit = value.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacter =
        value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUppercase) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!hasLowercase) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!hasDigit) {
      return 'Password must contain at least one digit';
    }
    if (!hasSpecialCharacter) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  static String formatCurrency(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}B';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      final NumberFormat currencyFormatter =
          NumberFormat.currency(symbol: '\$');
      return currencyFormatter.format(amount);
    }
  }

  static // Function to convert FeedbackType enum to string
      String feedbackTypeToString(FeedbackType type) {
    switch (type) {
      case FeedbackType.excellent:
        return 'Excellent';
      case FeedbackType.good:
        return 'Good';
      case FeedbackType.fair:
        return 'Fair';
      case FeedbackType.bad:
        return 'Bad';
      case FeedbackType.worst:
        return 'Worst';
      }
  }

// Function to convert string to FeedbackType enum
  static FeedbackType stringToFeedbackType(String type) {
    switch (type) {
      case 'Excellent':
        return FeedbackType.excellent;
      case 'Good':
        return FeedbackType.good;
      case 'Fair':
        return FeedbackType.fair;
      case 'Bad':
        return FeedbackType.bad;
      case 'Worst':
        return FeedbackType.worst;
      default:
        throw ArgumentError('Invalid feedback type');
    }
  }

  // static Future<bool?> callNumber(String number) async {
  //   return await FlutterPhoneDirectCaller.callNumber(number);
  // }

  static bool shouldShowAttendanceScreen() {
    DateTime now = DateTime.now();
    DateTime nineAM = DateTime(now.year, now.month, now.day, 9);
    DateTime twoPM = DateTime(now.year, now.month, now.day, 14);
    DateTime threePM = DateTime(now.year, now.month, now.day, 15);
    DateTime eightPM = DateTime(now.year, now.month, now.day, 20);

    if (now.isAfter(nineAM) && now.isBefore(twoPM)) {
      return false;
    } else if (now.isAfter(threePM) && now.isBefore(eightPM)) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> getSignInStatus() async {
    return await StorageServices.getSignInStatus();
  }

  static Future<bool> getAttendanceStatus() async {
    bool attendanceStatus = await StorageServices.getSignInStatus();
    if (!attendanceStatus) {
      attendanceStatus = AppFunctions.shouldShowAttendanceScreen();
    }
    return attendanceStatus;
  }

  static Future<void> launchMap(BuildContext context, String place) async {
    var url = '';
    var urlAppleMaps = '';
    // List<Placemark> placemarks1 = await placemarkFromCoordinates(lat, lng);
    // log(placemarks1.toString());
    String origin = place;
    // "${placemarks1[0].name},+${placemarks1[0].street},+${placemarks1[0].subAdministrativeArea},+${placemarks1[0].locality},+${placemarks1[0].thoroughfare}+${placemarks1[0].postalCode},+${placemarks1[0].country}";
    origin = origin.replaceAll(" ", "+");
    Uri uri;
    if (Platform.isAndroid) {
      // url = "https://www.google.com/maps/search/?api=1&query=${lat},${lng}";
      url = "https://www.google.com/maps/search/?api=1&query=$origin";
      uri = Uri.parse(url);
    } else {
      // urlAppleMaps = 'https://maps.apple.com/?q=$lat,$lng';
      urlAppleMaps = 'https://maps.apple.com/?q=$origin';
      url = "comgooglemaps://?saddr=&daddr=$origin&directionsmode=driving";
      uri = Uri.parse(urlAppleMaps);
      // if (await canLaunchUrl(uri)) {
      //   await launchUrl(uri);
      // } else {
      //   throw 'Could not launch $url';
      // }
    }

    //https://www.google.com/maps/dir/Kutul+Sahi+Rd,+Ramkrishna+Pally,+Barasat,+Kolkata,+West+Bengal+700127,+India/TECHNO+INTERNATIONAL+NEW+TOWN,+TECHNO+INDIA+COLLEGE+OF+TECHNOLOGY,+DG+Block(Newtown),+Action+Area+1D,+Newtown,+New+Town,+West+Bengal/@22.6411377,88.4219832,13z/data=!3m1!4b1!4m14!4m13!1m5!1m1!1s0x39f8a1ff00ac4627:0x8f29211ae5f443b2!2m2!1d88.4920747!2d22.7042965!1m5!1m1!1s0x3a0275325006855b:0x6f82539ddd62a603!2m2!1d88.4757711!2d22.5783614!3e0?entry=ttu

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (await canLaunchUrl(Uri.parse(urlAppleMaps))) {
      await launchUrl(Uri.parse(urlAppleMaps));
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<List<XFile>> captureImages() async {
    ImagePicker imagePicker = ImagePicker();
    return await imagePicker.pickMultiImage(imageQuality: 60);
  }

  static String getMonthAbbreviation(int month) {
    const List<String> monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    if (month < 1 || month > 12) {
      throw ArgumentError('Invalid month: $month. Must be between 1 and 12.');
    }

    return monthNames[month - 1];
  }

  static String getTwoDigitYear(int year) {
    if (year < 1000 || year > 9999) {
      throw ArgumentError('Invalid year: $year. Must be a 4-digit number.');
    }

    // Convert the year to a string and take the last two characters
    String yearStr = year.toString();
    return yearStr.substring(yearStr.length - 2);
  }

  static String formatCurrencyByComma(double amount) {
    final formatter = NumberFormat('#,##0');
    return formatter.format(amount);
  }
}
