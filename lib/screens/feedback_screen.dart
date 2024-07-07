import 'package:flutter/material.dart';
import 'package:mdw/models/feedback_model.dart';
import 'package:mdw/screens/code_verification_screen.dart';
import 'package:mdw/services/app_function_services.dart';
import 'package:mdw/styles.dart';
import 'package:mdw/utils/snack_bar_utils.dart';

import 'onboarding_screen.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late TextEditingController _feedbackEditingController;
  FeedbackModel? feedbackModel;
  List<FeedbackModel> feedbackModels = [
    FeedbackModel(
      emoji: "assets/feedback-emojis/raw/Group-6.png",
      selectedEmoji: "assets/feedback-emojis/colored/Group-4.png",
      type: FeedbackType.excellent,
      index: 0,
      message: "",
    ),
    FeedbackModel(
      emoji: "assets/feedback-emojis/raw/Group-5.png",
      selectedEmoji: "assets/feedback-emojis/colored/Group-7.png",
      type: FeedbackType.fair,
      index: 1,
      message: "",
    ),
    FeedbackModel(
      emoji: "assets/feedback-emojis/raw/Group-3.png",
      selectedEmoji: "assets/feedback-emojis/colored/Group-8.png",
      type: FeedbackType.good,
      index: 2,
      message: "",
    ),
    FeedbackModel(
      emoji: "assets/feedback-emojis/raw/Group-2.png",
      selectedEmoji: "assets/feedback-emojis/colored/Group-9.png",
      type: FeedbackType.bad,
      index: 3,
      message: "",
    ),
    FeedbackModel(
      emoji: "assets/feedback-emojis/raw/Group.png",
      selectedEmoji: "assets/feedback-emojis/colored/Group-10.png",
      type: FeedbackType.worst,
      index: 4,
      message: "",
    ),
  ];
  int? feedbackSelectedIndex;

  @override
  void initState() {
    _feedbackEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: CustomAppBarTitle(
                  title: "Give us your Feedback",
                  textColor: AppColors.green,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: CustomUpperPortion(
                  head:
                      "Tell us about your experience, things you liked,\nand areas of improvement. your feedback is\nvaluable to us.",
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: feedbackModels
                    .map((e) => CustomFeedbackEmoji(
                        width: MediaQuery.of(context).size.width / 6.5,
                        onTap: (() {
                          setState(() {
                            feedbackSelectedIndex = e.index;
                          });
                        }),
                        selected: feedbackSelectedIndex ?? -1,
                        feedbackModel: e))
                    .toList(),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _feedbackEditingController,
                style: TextStyle(color: AppColors.black, fontSize: 15),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                cursorColor: AppColors.green,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  hintText: "Write your feedback here...",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.black.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.black.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.green.withOpacity(0.7),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.red,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
              ),
              Center(
                child: CustomBtn(
                  onTap: (() {
                    if (feedbackSelectedIndex == -1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Please select a experience",
                          context: context,
                        ),
                      );
                    } else if (_feedbackEditingController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Please write a feedback",
                          context: context,
                        ),
                      );
                    } else {
                      setState(() {
                        feedbackSelectedIndex = -1;
                        _feedbackEditingController.clear();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Feedback sent successfully",
                          context: context,
                        ),
                      );
                    }
                  }),
                  text: "Done",
                  horizontalMargin: 0,
                  verticalPadding: 7,
                  fontSize: 12,
                  horizontalPadding: 15,
                  width: MediaQuery.of(context).size.width / 2.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomFeedbackEmoji extends StatelessWidget {
  const CustomFeedbackEmoji({
    super.key,
    required this.width,
    required this.onTap,
    required this.selected,
    required this.feedbackModel,
  });

  final double width;
  final VoidCallback onTap;
  final int selected;
  final FeedbackModel feedbackModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Image.asset(
              selected == feedbackModel.index
                  ? feedbackModel.selectedEmoji
                  : feedbackModel.emoji,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            AppFunctions.feedbackTypeToString(feedbackModel.type),
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
