import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' show asin, cos, pi, sin, sqrt;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:mdw/core/services/storage_services.dart';
import 'package:mdw/features/delivery/models/rider_details_model.dart';
import 'package:mdw/shared/utils/snack_bar_utils.dart';

import '../../../core/constants/app_keys.dart';
import '../../../core/services/app_function_services.dart';
import '../../auth/models/login_user_model.dart';
import '../models/orders_model.dart';

class HomeController extends ChangeNotifier {
  LoginUserModel? rider;
  OrdersListModel? ordersList;
  bool ordersListEmpty = false;
  bool tokenInvalid = false;
  String message = "";
  bool isLoading = false;
  int timer = 5;
  Timer? _countdownTimer;
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStream;
  bool arrivedLoading = false, packedLoading = false;

  Position? get currentPosition => _currentPosition;

  Future<bool> hasLastIDs() => StorageServices.hasLastOrderIDs();

  void toggleArrivedLoading() {
    arrivedLoading = !arrivedLoading;
    notifyListeners();
  }

  void togglePackedLoading() {
    packedLoading = !packedLoading;
    notifyListeners();
  }

  Future<void> initialize() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = await StorageServices.getLoginUserDetails();
      if (user != null) {
        rider = LoginUserModel.fromRawJson(user);
        await getRiderDetails();
        await getOrders();
      }
    } catch (e) {
      log(e.toString());
      message = "Failed to load rider info.";
      showMessage();
    }

    await startLocationStream();

    isLoading = false;
    notifyListeners();
  }

  Future<http.Response?> markOrderAsPacked(String orderId) async {
    togglePackedLoading();
    try {
      final response = await http.patch(
        Uri.parse(AppKeys.apiUrlKey + AppKeys.ordersKey + AppKeys.statusKey),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // "authorization": "Bearer ${rider!.token}",
        },
        body: jsonEncode(<String, dynamic>{
          "orderId": orderId,
          "status": "Packed",
        }),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        print("Failed: ${response.statusCode} → ${response.body}");
        return response; // failure case
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    } finally {
      togglePackedLoading(); // always toggle at end
    }
  }

  Future<http.Response?> markArrivedAtWarehouse(String orderId) async {
    toggleArrivedLoading(); // ✅ start loading
    try {
      final response = await http.patch(
        Uri.parse(AppKeys.apiUrlKey + AppKeys.ordersKey + AppKeys.statusKey),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // "authorization": "Bearer ${rider!.token}", // add token if required
        },
        body: jsonEncode(<String, dynamic>{
          "orderId": orderId,
          "status": "Arrived at Warehouse",
        }),
      );

      if (response.statusCode == 200) {
        await StorageServices.clearLastOrderIDs();
        return response; // ✅ full response for success
      } else {
        print("❌ Failed: ${response.statusCode} → ${response.body}");
        return response; // ✅ return response even on failure
      }
    } catch (e) {
      print("⚠️ Exception while marking as arrived: $e");
      return null; // ✅ return null on exception
    } finally {
      toggleArrivedLoading(); // ✅ always stop loading
    }
  }

  /// Start listening to location updates
  Future<void> startLocationStream() async {
    bool serviceEnabled;
    LocationPermission permission;

    // ✅ Check if location services are enabled
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   throw Exception("Location services are disabled.");
    // }

    // ✅ Check permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          "Location permissions are permanently denied, cannot request.");
    }

    // ✅ Start the location stream
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // only notify if moved 10m
      ),
    ).listen((Position position) {
      _currentPosition = position;
      notifyListeners(); // 🔔 notify UI
    });
  }

  RiderDetailsModel? rider2;

  Future<RiderDetailsModel?>? getRiderDetails() async {
    http.Response res = await http.get(Uri.parse(
        "${AppKeys.apiUrlKey}${AppKeys.ridersKey}/${rider!.rider.riderId}"));

    log(res.body);

    if (res.statusCode == 200) {
      final resJson = jsonDecode(res.body);

      if (resJson["success"] == 1) {
        rider2 = RiderDetailsModel.fromJson(resJson);
        notifyListeners();
      }
    }
    return null;
  }

  void stopLocationStream() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  // Add this function inside HomeController
  int calculateDistanceInKm(
      double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371; // Radius of Earth in kilometers

    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * asin(sqrt(a));
    final distance = earthRadius * c; // distance in kilometers (double)

    return (distance * 1000).round(); // return integer km
  }

  double _degToRad(double degree) {
    return degree * pi / 180;
  }

  final BuildContext context;

  HomeController(this.context) {
    initialize();
  }

  /// Initializes rider data and fetches orders

  /// Fetches rider orders
  Future<void> getOrders() async {
    final url = AppKeys.apiUrlKey +
        AppKeys.ridersKey +
        "/${rider?.rider.riderId}" +
        AppKeys.allottedOrdersKey;

    try {
      final res = await http.get(
        Uri.parse(url),
        headers: {"authorization": "Bearer ${rider?.token}"},
      );

      final resJson = jsonDecode(res.body);

      log(resJson.toString());

      if (res.statusCode == 200) {
        if (resJson["orders"].isEmpty) {
          ordersListEmpty = true;
          message = resJson["message"] ?? "No orders found";
        } else {
          ordersListEmpty = false;
          ordersList = OrdersListModel.fromJson(resJson);
          message = "";
        }
      } else {
        ordersListEmpty = true;
        tokenInvalid = true;
        message = resJson["message"] ?? "Token invalid or expired.";
        startTimer();
      }
    } catch (_) {
      ordersListEmpty = true;
      message = "Error fetching orders.";
    }

    notifyListeners();
    if (message.isNotEmpty) showMessage();
  }

  /// Starts logout countdown when token is invalid
  void startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (this.timer > 0) {
        this.timer--;
        notifyListeners();
      } else {
        timer.cancel();
        logout();
      }
    });
  }

  /// Logs out user and clears data
  Future<void> logout() async => await AppFunctions.logout();

  /// Displays snackbar message
  void showMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBar().customizedAppSnackBar(
        message: message,
        context: context,
      ),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    stopLocationStream();
    super.dispose();
  }
}
