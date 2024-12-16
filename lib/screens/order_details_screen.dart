import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mdw/screens/code_verification_screen.dart';
import 'package:mdw/services/app_function_services.dart';
import 'package:mdw/styles.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/location_service.dart';
import 'onboarding_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({
    super.key,
    required this.orderID,
    required this.name,
    required this.phone,
    required this.address,
  });

  final String orderID, name, phone, address;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool isPinVerified = false, isLoading = false;
  Position? position;
  List<Placemark>? placemarks;
  final LocationService locationService = LocationService();
  List<XFile> selectedImages = [];

  Future<bool> getPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permission = await Geolocator.requestPermission();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        openAppSettings();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      openAppSettings();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return true;
  }

  // Future<void> getLocationPermission() async {
  //   Permission permission = Permission.location;
  //   PermissionStatus  status = await permission.status;
  //   if(status.i)
  // }

  Future<Position?> _determinePosition() async {
    return await Geolocator.getCurrentPosition();
  }

  Future<List<Placemark>> _getPositionDetails(Position pos) async {
    return await placemarkFromCoordinates(pos.latitude, pos.longitude);
  }

  getDate() async {
    setState(() {
      isLoading = true;
    });
    position = await _determinePosition();
    if (position != null) {
      placemarks = await _getPositionDetails(position!);
    }
    // if (placemarks != null) {
    //   log(placemarks.toString());
    // }
    Future.delayed(Duration.zero, (() {
      setState(() {
        isLoading = false;
      });
    }));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: false,
        title: CustomAppBarTitle(
          title: "#0CAC6C64",
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    width: 1,
                    color: AppColors.containerBorderColor,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 7),
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.green.withOpacity(0.6),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "01 Jan 2025, 02:14 PM",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Random Name",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "00000 00000",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "Random Address",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 15,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 45,
                child: CustomBtn(
                  horizontalMargin: 0,
                  horizontalPadding: 0,
                  verticalPadding: 10,
                  onTap: (() async {
                    log("message");
                    // await locationService.requestLocationPermission(context);
                    await AppFunctions.launchMap(context,
                            "Techno International New Town, Kolkata, India")
                        .whenComplete(() {});
                  }),
                  text: "View On Map",
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.containerBorderColor,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Product Details",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.green,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        1,
                        2,
                        3,
                        4,
                        5,
                        6,
                        7,
                        8,
                        9,
                        10,
                        11,
                        12,
                        13,
                        14,
                        15
                      ]
                          .map(
                            (e) => Padding(
                              padding: EdgeInsets.only(top: e == 1 ? 0 : 5),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Center(child: Text(e.toString())),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: Center(child: Text("Product $e")),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: CustomBtn(
                height: 45,
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((ctx) => CodeVerificationScreen(
                            head: "Code Verification",
                            upperText:
                                "Enter the code to confirm the delivery\nof the order.",
                            type: 1,
                            btnText: "Confirm Order",
                          )),
                    ),
                  ).whenComplete(() {
                    log("Refreshed");
                  });
                }),
                text: "Enter Code",
                horizontalMargin: 0,
                verticalPadding: 7,
                fontSize: 12,
                horizontalPadding: 15,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
