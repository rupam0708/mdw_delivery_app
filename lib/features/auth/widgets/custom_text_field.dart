import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/themes/styles.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.head,
    required this.hint,
    required this.keyboard,
    this.validator,
    required this.textEditingController,
    this.obscure = false,
    this.suffix,
    this.textCapitalization,
    this.focusNode,
    this.inputFormatters,
    this.isMultiline = false,
  });

  final String head, hint;
  final TextInputType keyboard;
  final String? Function(String?)? validator;
  final TextEditingController textEditingController;
  final bool obscure;
  final Widget? suffix;
  final TextCapitalization? textCapitalization;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final bool isMultiline;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final GlobalKey<FormFieldState> formFieldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Text(
            widget.head,
            style: const TextStyle(color: AppColors.black, fontSize: 13),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          focusNode: widget.focusNode,
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.none,
          obscureText: widget.obscure,
          key: formFieldKey,
          onChanged: (_) => formFieldKey.currentState?.validate(),
          controller: widget.textEditingController,
          style: const TextStyle(color: AppColors.black, fontSize: 15),
          validator: widget.validator,
          keyboardType:
              widget.isMultiline ? TextInputType.multiline : widget.keyboard,
          inputFormatters: widget.inputFormatters,
          cursorColor: AppColors.green,
          maxLines: widget.isMultiline ? null : 1,
          minLines: widget.isMultiline ? 5 : 1,
          decoration: InputDecoration(
            suffixIcon: widget.suffix,
            contentPadding: const EdgeInsets.all(15),
            hintText: widget.hint,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.black.withAlpha(26)),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.black.withAlpha(26)),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.green.withAlpha(178)),
              borderRadius: BorderRadius.circular(15),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.red),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}
