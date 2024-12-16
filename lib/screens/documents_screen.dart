import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mdw/screens/orders_screen.dart';
import 'package:mdw/styles.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        title: Text("Documents"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SafeArea(
          child: Column(
            children: [
              DocType(head: "AADHAR CARD"),
              SizedBox(height: 25),
              DocContainer(
                head: "Front Side of Card",
                instruction: "Click to Upload Front Side of Card",
                onTap: (() {}),
              ),
              SizedBox(height: 25),
              DocContainer(
                head: "Back Side of Card",
                instruction: "Click to Upload Back Side of Card",
                onTap: (() {}),
              ),
              SizedBox(height: 25),
              DocType(head: "PAN CARD"),
              SizedBox(height: 15),
              DocContainer(
                instruction: "Click to Upload Front Side of Card",
                onTap: (() {}),
              ),
            ],
          ),
        ),
      ),
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
