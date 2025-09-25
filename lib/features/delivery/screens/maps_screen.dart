import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mdw/core/themes/styles.dart';
import 'package:mdw/features/delivery/widgets/custom_app_bar_title.dart';
import 'package:provider/provider.dart';

import '../controller/maps_controller.dart';

class MapsScreen extends StatelessWidget {
  final String address;
  final LocationData srcLocationData;
  final LocationData destLocationData;
  final String name;

  const MapsScreen({
    super.key,
    required this.address,
    required this.srcLocationData,
    required this.destLocationData,
    required this.name,
  });

  String formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return "${duration.inHours}h ${duration.inMinutes.remainder(60)}m";
    } else if (duration.inMinutes > 0) {
      return "${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s";
    } else {
      return "${duration.inSeconds}s";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapsProvider(srcLocationData, destLocationData, address),
      child: Consumer<MapsProvider>(
        builder: (context, maps, _) {
          if (maps.srcLocationData == null || maps.destLocationData == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: CustomAppBarTitle(title: name),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(maps.srcLocationData!.latitude!,
                          maps.srcLocationData!.longitude!),
                      zoom: 14.5,
                    ),
                    markers: {
                      // if (maps.srcLocationData != null)
                      //   Marker(
                      //     markerId: const MarkerId("source"),
                      //     position: LatLng(maps.srcLocationData!.latitude!,
                      //         maps.srcLocationData!.longitude!),
                      //   ),
                      if (maps.destLocationData != null)
                        Marker(
                          markerId: const MarkerId("destination"),
                          position: LatLng(maps.destLocationData!.latitude!,
                              maps.destLocationData!.longitude!),
                        ),
                      if (maps.srcLocationData != null)
                        Marker(
                          markerId: const MarkerId("current"),
                          position: LatLng(maps.srcLocationData!.latitude!,
                              maps.srcLocationData!.longitude!),
                          // rotation: ((maps.deviceHeading ?? 0) + 90) % 360,

                          rotation: maps.deviceHeading ?? 0,
                          anchor: const Offset(0.5, 0.5),
                          icon: maps.currentIcon, // 👈 now from provider
                        ),
                    },
                    polylines: {
                      if (maps.polyPoints.isNotEmpty)
                        Polyline(
                          polylineId: const PolylineId("route"),
                          points: maps.polyPoints,
                          width: 4,
                          color: AppColors.green,
                        ),
                    },
                    myLocationEnabled: true,
                    compassEnabled: true,
                  ),
                  if (maps.showDistanceInfo)
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(51),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${maps.distance.toStringAsFixed(2)} km",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.green,
                                  ),
                            ),
                            Text("ETA: ${formatDuration(maps.eta)}"),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
