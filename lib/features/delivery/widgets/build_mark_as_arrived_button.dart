import 'package:flutter/material.dart';

import '../../../core/themes/styles.dart';
import '../../../shared/widgets/custom_btn.dart';

class MarkAsArrivedButton extends StatefulWidget {
  final Future<void> Function() onApiCall;

  const MarkAsArrivedButton({super.key, required this.onApiCall});

  @override
  State<MarkAsArrivedButton> createState() => _MarkAsArrivedButtonState();
}

class _MarkAsArrivedButtonState extends State<MarkAsArrivedButton> {
  bool _loading = false;

  Future<void> _handleTap() async {
    setState(() => _loading = true);

    try {
      await widget.onApiCall(); // your API call here
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Marked as arrived successfully")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
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
              text: "Mark as arrived",
              color: AppColors.lightGreen,
              textColor: AppColors.black,
              onTap: _handleTap,
              horizontalMargin: 0,
              verticalPadding: 7,
              fontSize: 12,
              horizontalPadding: 15,
            ),
    );
  }
}
