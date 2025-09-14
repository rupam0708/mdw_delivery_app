import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mdw/core/constants/app_keys.dart';

class MapsProvider extends ChangeNotifier {
  LocationData? srcLocationData;
  LocationData? destLocationData;

  List<LatLng> polyPoints = [];
  double distance = 0.0;
  Duration eta = Duration.zero;
  bool showDistanceInfo = false;
  double? deviceHeading;

  final Location _location = Location();
  final PolylinePoints polylinePoints =
      PolylinePoints(apiKey: AppKeys.googleMapsApiKey);

  StreamSubscription<CompassEvent>? _compassSubscription;
  StreamSubscription<LocationData>? _locationSubscription;

  /// 🎨 Create a custom Google Maps marker using a Material Icon
  BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;

  Future<BitmapDescriptor> _getMarkerIcon(
      IconData iconData, Color color, double size) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final icon = Icon(iconData, size: size, color: color);
    final textSpan = TextSpan(
      text: String.fromCharCode(icon.icon!.codePoint),
      style: TextStyle(
        fontSize: size,
        fontFamily: icon.icon!.fontFamily,
        color: color,
      ),
    );
    textPainter.text = textSpan;
    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  /// ✅ Set up custom marker for "current location"
  Future<void> _setCustomMarker() async {
    currentIcon = await _getMarkerIcon(Icons.navigation, Colors.green, 80);
    notifyListeners();
  }

  // Init provider
  MapsProvider(LocationData src, LocationData dest, String address) {
    srcLocationData = src;
    destLocationData = dest;
    _setCustomMarker();
    _setUpCompass();
    _getDestPosition(address);
    _getCurrPosition();
    _calculatePolyline();
  }

  // Distance formula
  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371;
    double lat1 = start.latitude * pi / 180;
    double lon1 = start.longitude * pi / 180;
    double lat2 = end.latitude * pi / 180;
    double lon2 = end.longitude * pi / 180;
    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  Duration _calculateETA(double distanceKm) {
    const double avgSpeed = 30.0;
    double hours = distanceKm / avgSpeed;
    return Duration(minutes: (hours * 60).round());
  }

  Future<void> _getDestPosition(String address) async {
    try {
      if (destLocationData?.latitude == null ||
          destLocationData?.longitude == null) {
        List<geocoding.Location> location =
            await geocoding.locationFromAddress(address);
        if (location.isNotEmpty) {
          destLocationData = LocationData.fromMap({
            "latitude": location.last.latitude,
            "longitude": location.last.longitude,
          });
          notifyListeners();
        }
      }
    } catch (e) {
      dev.log("Error dest pos: $e");
    }
  }

  Future<void> _getCurrPosition() async {
    try {
      await _location.changeSettings(
        accuracy: Platform.isAndroid
            ? LocationAccuracy.high
            : LocationAccuracy.navigation,
        interval: 2000,
        distanceFilter: 1.0,
      );
      LocationData currLoc = await _location.getLocation();
      srcLocationData = currLoc;
      notifyListeners();

      _locationSubscription =
          _location.onLocationChanged.listen((LocationData newLocation) {
        srcLocationData = newLocation;

        if (destLocationData != null) {
          distance = _calculateDistance(
              LatLng(srcLocationData!.latitude!, srcLocationData!.longitude!),
              LatLng(
                  destLocationData!.latitude!, destLocationData!.longitude!));
          eta = _calculateETA(distance);
          showDistanceInfo = true;
        }
        notifyListeners();
      });
    } catch (e) {
      dev.log("Error current pos: $e");
    }
  }

  Future<void> _calculatePolyline() async {
    if (srcLocationData != null &&
        destLocationData != null &&
        srcLocationData!.latitude != null &&
        destLocationData!.latitude != null) {
      try {
        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          request: PolylineRequest(
            origin: PointLatLng(
                srcLocationData!.latitude!, srcLocationData!.longitude!),
            destination: PointLatLng(
                destLocationData!.latitude!, destLocationData!.longitude!),
            mode: TravelMode.twoWheeler,
          ),
        );
        if (result.points.isNotEmpty) {
          polyPoints = result.points
              .map((e) => LatLng(e.latitude, e.longitude))
              .toList();
          distance = _calculateDistance(
              LatLng(srcLocationData!.latitude!, srcLocationData!.longitude!),
              LatLng(
                  destLocationData!.latitude!, destLocationData!.longitude!));
          eta = _calculateETA(distance);
          showDistanceInfo = true;
          notifyListeners();
        }
      } catch (e) {
        dev.log("Polyline error: $e");
      }
    }
  }

  void _setUpCompass() {
    _compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
      deviceHeading = event.heading;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _locationSubscription?.cancel();
    super.dispose();
  }
}
