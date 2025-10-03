import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mdw/core/constants/app_keys.dart';
import 'package:mdw/core/services/app_function_services.dart';
import 'package:mdw/core/services/storage_services.dart';
import 'package:mdw/core/themes/styles.dart';
import 'package:mdw/features/documents/models/file_type_model.dart';
import 'package:mdw/features/documents/models/rider_docs_model.dart';

// import 'package:pdf_render/pdf_render.dart';

import '../../../core/constants/constant.dart';
import '../../../shared/utils/snack_bar_utils.dart';
import '../../../shared/widgets/custom_btn.dart';
import '../../../shared/widgets/custom_divider.dart';
import '../../auth/models/login_user_model.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key, this.type, this.phone});

  final int? type;
  final String? phone;

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  FileTypeModel? aadharFront, aadharBack, pan, dlFront, dlBack, rcFront, rcBack;

  Future<String?> getFile(BuildContext context, String title) async {
    // show popup to choose between Camera or Gallery
    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          backgroundColor: AppColors.white,
          titleTextStyle: TextStyle(
            color: AppColors.btnColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: SizedBox(
                    height: 40,
                    width: 40,
                    child: SvgPicture.asset("assets/1.svg")),
                title: const Text("Camera"),
                onTap: () => Navigator.pop(ctx, "camera"),
              ),
              ListTile(
                leading: SizedBox(
                    height: 40,
                    width: 40,
                    child: SvgPicture.asset("assets/2.svg")),
                title: const Text("Gallery"),
                onTap: () => Navigator.pop(ctx, "gallery"),
              ),
            ],
          ),
        );
      },
    );

    if (choice == "gallery") {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        int fileSize = result.files.single.size; // ✅ safe
        if (fileSize > AppKeys.maxFileSizeInBytes) {
          ScaffoldMessenger.of(context).showSnackBar(
            AppSnackBar().customizedAppSnackBar(
              message: "File size is too large",
              context: context,
            ),
          );
          return null;
        }
        return result.files.single.path;
      }
    } else if (choice == "camera") {
      try {
        XFile? image = await ImagePicker().pickImage(
          source: ImageSource.camera,
        );

        if (image != null) {
          // ✅ Correct way: use File(image.path).length()
          final file = File(image.path);
          int fileSize = await file.length();

          if (fileSize > AppKeys.maxFileSizeInBytes) {
            ScaffoldMessenger.of(context).showSnackBar(
              AppSnackBar().customizedAppSnackBar(
                message: "File size is too large",
                context: context,
              ),
            );
            return null;
          }
          return image.path;
        }
      } catch (e) {
        log(e.toString());
      }
    }

    return null;
  }

  // getDocs() async {
  //   user = await StorageServices.getLoginUserDetails();
  //   if (user != null) {
  //     u = LoginUserModel.fromRawJson(user!);
  //     aadharFront =
  //         await StorageServices.getAadharFront(u?.rider.riderId ?? "");
  //     aadharBack = await StorageServices.getAadharBack(u?.rider.riderId ?? "");
  //     pan = await StorageServices.getPan(u?.rider.riderId ?? "");
  //   } else if (widget.email != null) {
  //     aadharFront = await StorageServices.getAadharFront(widget.email ?? "");
  //     aadharBack = await StorageServices.getAadharBack(widget.email ?? "");
  //     pan = await StorageServices.getPan(widget.email ?? "");
  //   }
  //   setState(() {});
  // }

  // getStoragePermission() async {
  //   var status = await Permission.storage.request();
  //   if (!status.isGranted) {
  //     openAppSettings();
  //   }
  // }

  @override
  void initState() {
    // getStoragePermission();
    // getDocs();
    getData();
    super.initState();
  }

  getData() async {
    log(widget.phone ?? "NULL");
    String? user = await StorageServices.getLoginUserDetails();
    LoginUserModel? u;
    if (user != null) {
      u = LoginUserModel.fromRawJson(user);
    }
    // if (u != null) {
    //   final p = await SharedPreferences.getInstance();
    //   await p.clear();
    // }
    log(widget.phone ?? u?.rider.riderId ?? "RIDER ID NULL");
    RiderDocsModel docs =
        await AppFunctions.getDocs(widget.phone ?? u?.rider.riderId);
    aadharFront = docs.aadharFront;
    aadharBack = docs.aadharBack;
    pan = docs.pan;
    dlFront = docs.dlFront;
    dlBack = docs.dlBack;
    rcFront = docs.rcFront;
    rcBack = docs.rcBack;
    log(rcBack?.path ?? "Path null");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.type != 1 ||
          (aadharFront != null &&
              aadharBack != null &&
              pan != null &&
              dlFront != null &&
              dlBack != null &&
              rcFront != null &&
              rcBack != null),
      onPopInvokedWithResult: (bool result, Object? returnValue) {
        if (!result &&
            widget.type == 1 &&
            (aadharFront == null ||
                aadharBack == null ||
                pan == null ||
                dlFront == null ||
                dlBack == null ||
                rcFront == null ||
                rcBack == null)) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            AppSnackBar().customizedAppSnackBar(
              message:
                  "Please upload all documents before leaving this screen.",
              context: context,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          centerTitle: false,
          title: Text("Documents"),
          leading: widget.type == 1 ? SizedBox() : null,
          actions: [
            CustomBtn(
              horizontalMargin: 15,
              horizontalPadding: 20,
              verticalPadding: 5,
              height: 40,
              onTap: () async {
                // If no documents uploaded, show SnackBar and return early
                if (aadharFront == null &&
                    aadharBack == null &&
                    pan == null &&
                    dlFront == null &&
                    dlBack == null &&
                    rcFront == null &&
                    rcBack == null) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    AppSnackBar().customizedAppSnackBar(
                      message: "Please upload all the documents to proceed.",
                      context: context,
                    ),
                  );
                  return;
                }

                String? user = await StorageServices.getLoginUserDetails();
                LoginUserModel? u;
                if (user != null) {
                  u = LoginUserModel.fromRawJson(user);
                }

                // Save uploaded documents
                if (u != null) {
                  if (aadharFront != null) {
                    await StorageServices.setAadharFront(
                        aadharFront!, u.rider.riderId);
                  }
                  if (aadharBack != null) {
                    await StorageServices.setAadharBack(
                        aadharBack!, u.rider.riderId);
                  }
                  if (pan != null) {
                    await StorageServices.setPan(pan!, u.rider.riderId);
                  }
                  if (dlFront != null) {
                    await StorageServices.setDLFront(dlFront!, u.rider.riderId);
                  }
                  if (dlBack != null) {
                    await StorageServices.setDLBack(dlBack!, u.rider.riderId);
                  }
                  if (rcFront != null) {
                    await StorageServices.setRCFront(rcFront!, u.rider.riderId);
                  }
                  if (rcBack != null) {
                    await StorageServices.setRCBack(rcBack!, u.rider.riderId);
                  }
                } else if (widget.phone != null) {
                  if (aadharFront != null) {
                    await StorageServices.setAadharFront(
                        aadharFront!, widget.phone ?? "");
                  }
                  if (aadharBack != null) {
                    await StorageServices.setAadharBack(
                        aadharBack!, widget.phone ?? "");
                  }
                  if (pan != null) {
                    await StorageServices.setPan(pan!, widget.phone ?? "");
                  }
                  if (dlFront != null) {
                    await StorageServices.setDLFront(
                        dlFront!, widget.phone ?? "");
                  }
                  if (dlBack != null) {
                    await StorageServices.setDLBack(
                        dlBack!, widget.phone ?? "");
                  }
                  if (rcFront != null) {
                    await StorageServices.setRCFront(
                        rcFront!, widget.phone ?? "");
                  }
                  if (rcBack != null) {
                    await StorageServices.setRCBack(
                        rcBack!, widget.phone ?? "");
                  }
                } else {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    AppSnackBar().customizedAppSnackBar(
                      message:
                          "Can't upload documents now.\nPlease try again later.",
                      context: context,
                    ),
                  );
                  return;
                }

                // Pop with result only if it's a verification flow
                if (widget.type == 0 || widget.type == null) {
                  Navigator.pop(
                    context,
                    aadharFront != null &&
                        aadharBack != null &&
                        pan != null &&
                        dlFront != null &&
                        dlBack != null &&
                        rcFront != null &&
                        rcBack != null,
                  );
                }

                // If type is 1 and all documents are uploaded, pop manually
                if (widget.type == 1 &&
                    aadharFront != null &&
                    aadharBack != null &&
                    pan != null &&
                    dlFront != null &&
                    dlBack != null &&
                    rcFront != null &&
                    rcBack != null) {
                  Navigator.pop(context, true);
                }
              },
              text: (aadharFront != null ||
                      aadharBack != null ||
                      pan != null ||
                      dlFront != null ||
                      dlBack != null ||
                      rcFront != null ||
                      rcBack != null)
                  ? "Update"
                  : "Save",
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: AppConstant.physics,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SafeArea(
            child: Column(
              children: [
                DocType(head: "AADHAR CARD"),
                SizedBox(height: 25),
                if (aadharFront == null)
                  DocContainer(
                    head: "Front Side of Card",
                    instruction: "Click to Upload Front Side of Card",
                    onTap: (() async {
                      final filePath = await getFile(
                        context,
                        "Upload Front Side of Aadhar Card",
                      );

                      if (filePath != null) {
                        aadharFront = FileTypeModel(path: filePath);
                        setState(() {});
                      }
                    }),
                  ),
                if (aadharFront != null)
                  NotEmptyContainer(
                    onChange: (() async {
                      aadharFront = null;
                      final filePath = await getFile(
                        context,
                        "Upload Front Side of Aadhar Card",
                      );

                      if (filePath != null) {
                        aadharFront = FileTypeModel(path: filePath);
                        setState(() {});
                      }
                    }),
                    fileModel: aadharFront,
                    head: "Aadhar Card Front",
                  ),
                SizedBox(height: 25),
                if (aadharBack == null)
                  DocContainer(
                    head: "Back Side of Card",
                    instruction: "Click to Upload Back Side of Card",
                    onTap: (() async {
                      final result = await getFile(
                          context, "Upload Back Side of Aadhar Card");
                      if (result != null) {
                        aadharBack = FileTypeModel(path: result);
                        setState(() {});
                      }
                    }),
                  ),
                if (aadharBack != null)
                  NotEmptyContainer(
                    fileModel: aadharBack,
                    head: "Aadhar Card Back",
                    onChange: (() async {
                      aadharBack = null;
                      final result = await getFile(
                          context, "Upload Back Side of Aadhar Card");
                      if (result != null) {
                        aadharBack = FileTypeModel(path: result);
                        setState(() {});
                      }
                    }),
                  ),
                SizedBox(height: 25),
                DocType(head: "PAN CARD"),
                SizedBox(height: 15),
                if (pan == null)
                  DocContainer(
                    instruction: "Click to Upload Front Side of Card",
                    onTap: (() async {
                      final result = await getFile(
                          context, "Upload Back Side of Aadhar Card");
                      if (result != null) {
                        pan = FileTypeModel(path: result);
                        setState(() {});
                      }
                    }),
                  ),
                if (pan != null)
                  NotEmptyContainer(
                    fileModel: pan,
                    head: "PAN Card",
                    onChange: (() async {
                      pan = null;
                      final result = await getFile(
                          context, "Upload Back Side of Aadhar Card");
                      if (result != null) {
                        pan = FileTypeModel(path: result);
                        setState(() {});
                      }
                    }),
                  ),
                SizedBox(height: 25),
                DocType(head: "DRIVING LICENCE"),
                SizedBox(height: 25),
                if (dlFront == null)
                  DocContainer(
                    head: "Front Side of Card",
                    instruction: "Click to Upload Front Side of Card",
                    onTap: (() async {
                      final result = await getFile(
                          context, "Upload Front Side of Driving Licence");
                      if (result != null) {
                        dlFront = FileTypeModel(path: result);
                        setState(() {});
                      }
                    }),
                  ),
                if (dlFront != null)
                  NotEmptyContainer(
                    onChange: (() async {
                      dlFront = null;
                      final result = await getFile(
                          context, "Upload Front Side of Driving Licence");
                      if (result != null) {
                        dlFront = FileTypeModel(path: result);
                        setState(() {});
                      }
                    }),
                    fileModel: dlFront,
                    head: "Driving Licence Front",
                  ),
                SizedBox(height: 25),
                if (dlBack == null)
                  DocContainer(
                    head: "Back Side of Card",
                    instruction: "Click to Upload Back Side of Card",
                    onTap: (() async {
                      final result = await getFile(
                          context, "Upload Back Side of Aadhar Card");
                      if (result != null) {
                        dlBack = FileTypeModel(path: result);
                        setState(() {});
                      }
                    }),
                  ),
                if (dlBack != null)
                  NotEmptyContainer(
                    fileModel: dlBack,
                    head: "Driving Licence Back",
                    onChange: (() async {
                      dlBack = null;
                      final result = await getFile(
                          context, "Upload Back Side of Driving Licence");
                      if (result != null) {
                        dlBack = FileTypeModel(path: result);
                        setState(() {});
                      }
                    }),
                  ),
                SizedBox(height: 25),
                DocType(head: "REGISTRATION CERTIFICATE"),
                SizedBox(height: 25),
                if (rcFront == null)
                  DocContainer(
                    head: "Front Side of Card",
                    instruction: "Click to Upload Front Side of Card",
                    onTap: (() async {
                      final result = await getFile(context,
                          "Upload Front Side of Registration Certificate");
                      if (result != null) {
                        rcFront = FileTypeModel(path: result);
                        setState(() {});
                      }
                    }),
                  ),
                if (rcFront != null)
                  NotEmptyContainer(
                    onChange: (() async {
                      rcFront = null;
                      final result = await getFile(
                          context, "Upload Front Side of Aadhar Card");
                      if (result != null) {
                        rcFront = FileTypeModel(path: result);
                        setState(() {});
                      }
                    }),
                    fileModel: rcFront,
                    head: "Registration Certificate Front",
                  ),
                SizedBox(height: 25),
                if (rcBack == null)
                  DocContainer(
                    head: "Back Side of Card",
                    instruction: "Click to Upload Back Side of Card",
                    onTap: (() async {
                      final result = await getFile(context,
                          "Upload Back Side of Registration Certificate");
                      if (result != null) {
                        rcBack = FileTypeModel(path: result);
                        setState(() {});
                      }
                    }),
                  ),
                if (rcBack != null)
                  NotEmptyContainer(
                    fileModel: rcBack,
                    head: "Registration Certificate Back",
                    onChange: (() async {
                      rcBack = null;
                      final filePath = await getFile(
                        context,
                        "Upload Back Side of Registration Certificate",
                      );

                      if (filePath != null) {
                        rcBack = FileTypeModel(path: filePath);
                        setState(() {});
                      }
                    }),
                  ),
                SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotEmptyContainer extends StatelessWidget {
  const NotEmptyContainer({
    super.key,
    required this.fileModel,
    required this.head,
    required this.onChange,
  });

  final FileTypeModel? fileModel;
  final String head;
  final VoidCallback onChange;

  // Future<Map<String, double>> _getPdfPageDimensions(String filePath) async {
  //   final doc = await PdfDocument.openFile(filePath);
  //   final page = await doc.getPage(1); // Access the first page (index 0)
  //
  //   final width = page.width;
  //   final height = page.height;
  //
  //   doc.dispose();
  //
  //   return {'width': width, 'height': height};
  // }

  // Future<double> _getCalculatedHeight(
  //     String filePath, double desiredWidth) async {
  //   // Get the PDF page dimensions (width and height)
  //   Map<String, double> dimensions = await _getPdfPageDimensions(filePath);
  //
  //   final originalWidth = dimensions['width']!;
  //   final originalHeight = dimensions['height']!;
  //
  //   // Ensure the aspect ratio calculation is correct
  //   final aspectRatio = originalHeight / originalWidth;
  //
  //   // Calculate the height based on the desired width and the aspect ratio
  //   final calculatedHeight = desiredWidth * aspectRatio;
  //
  //   // Return the calculated height
  //   return calculatedHeight - 20;
  // }

  @override
  Widget build(BuildContext context) {
    // Make sure fileModel is not null
    if (fileModel == null) {
      return Container(); // Return an empty container if fileModel is null
    }

    return FutureBuilder<double>(
      future:
          // fileModel!.type == FileTypeEnum.pdf
          //     ? _getCalculatedHeight(fileModel!.path,
          //         MediaQuery.of(context).size.width) // Only call for PDF
          //     :
          Future.value(0.0), // Return 0 if not a PDF (no height for non-PDF)
      builder: (ctx, snapshot) {
        // log(snapshot.toString());
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          // final pageHeight = snapshot.data ?? 0.0; // Safely handle null data

          return Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(
                color: AppColors.black.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                if (fileModel!.type == FileTypeEnum.image)
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(fileModel!.path)),
                      ),
                    ),
                  ),
                // if (fileModel!.type == FileTypeEnum.pdf)
                //   Container(
                //     height: pageHeight,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(15),
                //     ),
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(15),
                //       // Set the same radius as container
                //       child: PDFView(
                //         filePath: fileModel!.path,
                //         enableSwipe: true,
                //         swipeHorizontal: true,
                //         autoSpacing: false,
                //         pageFling: false,
                //         backgroundColor: AppColors.white,
                //         onRender: (_pages) {
                //           log(fileModel!.path);
                //           // Handle rendering
                //         },
                //         onError: (error) {
                //           // Handle error
                //         },
                //         onPageError: (page, error) {
                //           // Handle page error
                //         },
                //         onViewCreated: (PDFViewController pdfViewController) {
                //           // Handle view creation
                //         },
                //       ),
                //     ),
                //   ),
                SizedBox(height: 5),
                Text(head),
                SizedBox(height: 5),
                CustomBtn(
                  onTap: onChange,
                  text: "Change",
                  width: MediaQuery.of(context).size.width,
                  horizontalMargin: 10,
                  verticalPadding: 10,
                ),
                SizedBox(height: 5),
              ],
            ),
          );
        } else {
          return Container(); // Return empty container if no data
        }
      },
    );
  }
}

class DocType extends StatelessWidget {
  const DocType({
    super.key,
    required this.head,
  });

  final String head;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: CustomDivider()),
        SizedBox(width: 10),
        Text(
          head,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 12,
          ),
        ),
        SizedBox(width: 10),
        Flexible(child: CustomDivider()),
      ],
    );
  }
}

class DocContainer extends StatelessWidget {
  const DocContainer({
    super.key,
    this.head,
    required this.instruction,
    required this.onTap,
  });

  final String? head;
  final String instruction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (head != null)
              Text(
                head ?? "",
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            if (head != null)
              Text(
                "*",
                style: TextStyle(
                  color: AppColors.red,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: DottedBorder(
            dashPattern: [4, 4],
            color: AppColors.black.withValues(alpha: 0.5),
            borderType: BorderType.RRect,
            radius: Radius.circular(15),
            child: Container(
              height: 140,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SvgPicture.asset("assets/Icon frame.svg"),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          instruction,
                          style: TextStyle(
                            color: AppColors.green,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "(Max. File size: 25 MB)",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
