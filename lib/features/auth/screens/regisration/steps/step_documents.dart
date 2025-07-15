import 'package:flutter/material.dart';

import '../../../../../core/themes/styles.dart';
import '../../../../documents/screens/documents_screen.dart';

class StepDocuments extends StatelessWidget {
  final bool docRes;
  final int changed;
  final String phone;
  final Function onDocChanged;

  const StepDocuments({
    super.key,
    required this.docRes,
    required this.changed,
    required this.phone,
    required this.onDocChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (!docRes) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Documents uploaded successfully."),
        if (changed != 0) const SizedBox(height: 10),
        if (changed != 0) Text("Documents updated: $changed"),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text("Want to update?"),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () async {
                final bool? docResult = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DocumentsScreen(
                      type: 1,
                      phone: phone,
                    ),
                  ),
                );
                if (docResult ?? false) {
                  onDocChanged();
                }
              },
              child: const Text(
                "change",
                style: TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
