import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mdw/models/file_type_model.dart';
import 'package:mdw/screens/onboarding_screen.dart';
import 'package:mdw/screens/orders_screen.dart';
import 'package:mdw/services/app_keys.dart';
import 'package:mdw/services/storage_services.dart';
import 'package:mdw/styles.dart';
// import 'package:pdf_render/pdf_render.dart';

import '../utils/snack_bar_utils.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  FileTypeModel? aadharFront, aadharBack, pan;

  Future<FilePickerResult?> getFile(String title) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      int fileSize = result.files.single.size; // File size in bytes
      if (fileSize > AppKeys.maxFileSizeInBytes) {
        ScaffoldMessenger.of(context).showSnackBar(
          AppSnackBar().customizedAppSnackBar(
              message: "File size is too large", context: context),
        );
        return null;
      }
      return result;
    }
    return null;
  }

  getDocs() async {
    aadharFront = await StorageServices.getAadharFront();
    aadharBack = await StorageServices.getAadharBack();
    pan = await StorageServices.getPan();
    setState(() {});
  }

  // getStoragePermission() async {
  //   var status = await Permission.storage.request();
  //   if (!status.isGranted) {
  //     openAppSettings();
  //   }
  // }

  @override
  void initState() {
    // getStoragePermission();
    getDocs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        title: Text("Documents"),
        actions: [
          CustomBtn(
            horizontalMargin: 15,
            horizontalPadding: 20,
            verticalPadding: 5,
            height: 40,
            onTap: (() async {
              if (aadharFront != null) {
                await StorageServices.setAadharFront(aadharFront!);
              }
              if (aadharBack != null) {
                await StorageServices.setAadharBack(aadharBack!);
              }
              if (pan != null) {
                await StorageServices.setPan(pan!);
              }

              Navigator.pop(context);
            }),
            text: "Save",
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                    FilePickerResult? result =
                        await getFile("Upload Front Side of Aadhar Card");
                    if (result != null) {
                      aadharFront =
                          FileTypeModel(path: result.files.single.path!);
                      setState(() {});
                    }
                  }),
                ),
              if (aadharFront != null)
                NotEmptyContainer(
                  onChange: (() async {
                    aadharFront = null;
                    FilePickerResult? result =
                        await getFile("Upload Front Side of Aadhar Card");
                    if (result != null) {
                      aadharFront =
                          FileTypeModel(path: result.files.single.path!);
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
                    FilePickerResult? result =
                        await getFile("Upload Back Side of Aadhar Card");
                    if (result != null) {
                      aadharBack =
                          FileTypeModel(path: result.files.single.path!);
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
                    FilePickerResult? result =
                        await getFile("Upload Back Side of Aadhar Card");
                    if (result != null) {
                      aadharBack =
                          FileTypeModel(path: result.files.single.path!);
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
                    FilePickerResult? result =
                        await getFile("Upload Back Side of Aadhar Card");
                    if (result != null) {
                      pan = FileTypeModel(path: result.files.single.path!);
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
                    FilePickerResult? result =
                        await getFile("Upload Back Side of Aadhar Card");
                    if (result != null) {
                      pan = FileTypeModel(path: result.files.single.path!);
                      setState(() {});
                    }
                  }),
                ),
            ],
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
          final pageHeight = snapshot.data ?? 0.0; // Safely handle null data

          return Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(
                color: AppColors.black.withOpacity(0.2),
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
                if (fileModel!.type == FileTypeEnum.pdf)
                  Container(
                    height: pageHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      // Set the same radius as container
                      child: PDFView(
                        filePath: fileModel!.path,
                        enableSwipe: true,
                        swipeHorizontal: true,
                        autoSpacing: false,
                        pageFling: false,
                        backgroundColor: AppColors.white,
                        onRender: (_pages) {
                          log(fileModel!.path);
                          // Handle rendering
                        },
                        onError: (error) {
                          // Handle error
                        },
                        onPageError: (page, error) {
                          // Handle page error
                        },
                        onViewCreated: (PDFViewController pdfViewController) {
                          // Handle view creation
                        },
                      ),
                    ),
                  ),
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
            color: AppColors.black.withOpacity(0.5),
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
