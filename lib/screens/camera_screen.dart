import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mdw/styles.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraPage({required this.cameras, Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  List<XFile> picturesList = [];
  bool capturing = false;

  @override
  void initState() {
    super.initState();
    if (widget.cameras.isNotEmpty) {
      controller = CameraController(
        widget.cameras[0],
        ResolutionPreset.max,
      );
    }
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (() {
                        Navigator.pop(context);
                      }),
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 10, right: 13),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (() {
                        Navigator.pop(context, picturesList);
                      }),
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.7,
                width: MediaQuery.of(context).size.width,
                child: CameraPreview(controller),
              ),
              if (picturesList.isNotEmpty)
                Container(
                  height: 90,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: picturesList.length,
                    itemBuilder: ((ctx, idx) {
                      return Container(
                        width: 90,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(
                              File(picturesList[idx].path),
                            ),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: (() {
                              picturesList.removeAt(idx);
                            }),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15)),
                              ),
                              child: Icon(
                                Icons.delete_rounded,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              SizedBox(
                height: 15,
              ),
              if (!capturing)
                GestureDetector(
                  onTap: (() async {
                    setState(() {
                      capturing = true;
                    });
                    final image = await controller.takePicture();
                    picturesList.insert(0, image);
                    // log(picturesList.length.toString());
                    setState(() {
                      capturing = false;
                    });
                  }),
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 1.5),
                      // color: AppColors.white.withOpacity(0.5),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: AppColors.white,
                    ),
                  ),
                ),
              if (capturing)
                Container(
                  height: 70,
                  width: 70,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 1.5,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
