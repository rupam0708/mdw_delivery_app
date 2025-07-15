import 'package:flutter/material.dart';
import 'package:mdw/core/themes/styles.dart';

import '../../../shared/widgets/custom_btn.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuTap;
  final Widget title;
  final bool showShiftButton;
  final bool attendanceStatus;
  final bool? centerTitle;
  final VoidCallback onShiftTap;

  const MainAppBar({
    super.key,
    required this.onMenuTap,
    required this.title,
    this.showShiftButton = false,
    this.attendanceStatus = false,
    required this.onShiftTap,
    this.centerTitle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: centerTitle,
      leading: IconButton(
        onPressed: onMenuTap,
        icon: const Icon(Icons.menu, color: AppColors.green),
      ),
      title: title,
      actions: showShiftButton
          ? [
              CustomBtn(
                horizontalPadding: 15,
                horizontalMargin: 10,
                verticalPadding: 0,
                height: 40,
                onTap: onShiftTap,
                text: attendanceStatus ? "End Shift" : "Start Shift",
              ),
              const SizedBox(width: 10),
            ]
          : null,
    );
  }
}
