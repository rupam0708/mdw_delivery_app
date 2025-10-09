import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mdw/shared/utils/snack_bar_utils.dart';

import '../../../core/themes/styles.dart';
import '../../../shared/widgets/custom_btn.dart';

class MarkAsArrivedButton extends StatefulWidget {
  final Future<http.Response> Function() onApiCall;

  const MarkAsArrivedButton({super.key, required this.onApiCall});

  @override
  State<MarkAsArrivedButton> createState() => _MarkAsArrivedButtonState();
}

class _MarkAsArrivedButtonState extends State<MarkAsArrivedButton> {
  bool _loading = false;
  bool _isArrived = false;

  Future<void> _handleTap() async {
    setState(() => _loading = true);

    try {
      final res = await widget.onApiCall();

      if (!mounted) return;

      log(res.body);
      final resJson = jsonDecode(res.body);

      if (res.statusCode == 200) {
        final success = resJson["success"] == true ||
            resJson["message"]?.toString().toLowerCase().contains("arrived") ==
                true;

        if (success) {
          setState(() {
            _isArrived = true;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            AppSnackBar().customizedAppSnackBar(
              message: "Marked as arrived successfully",
              context: context,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            AppSnackBar().customizedAppSnackBar(
              message: "Failed: ${resJson["message"] ?? "Unknown error"}",
              context: context,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          AppSnackBar().customizedAppSnackBar(
              message: "${resJson["message"] ?? ""}", context: context),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        AppSnackBar().customizedAppSnackBar(
          message: "Error: $e",
          context: context,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: _loading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: CircularProgressIndicator(),
              ),
            )
          : CustomBtn(
              height: 45,
              text: _isArrived ? "ARRIVED" : "Mark as arrived",
              color: _isArrived
                  ? AppColors.grey.withAlpha(128)
                  : AppColors.lightGreen,
              textColor: AppColors.black,
              onTap: _isArrived
                  ? (() {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Status was already updated to arrived",
                          context: context,
                        ),
                      );
                    })
                  : () => _handleTap(),
              horizontalMargin: 0,
              verticalPadding: 7,
              fontSize: 12,
              horizontalPadding: 15,
            ),
    );
  }
}
