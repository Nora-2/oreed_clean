import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/textstyle/textstyle.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final dynamic label;
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final String? hint;
  final int max;
  final int min;
  final void Function(String)? onChanged;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.hint,
    this.max = 1,
    this.min = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
     Color focusColor = AppColors.primary;

    // Convert label to Widget if it's a String
    Widget? labelWidget;
    if (label is String) {
      labelWidget = Text(label as String);
    } else if (label is Widget) {
      labelWidget = label as Widget;
    }

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: max,
      minLines: min,
      onChanged: onChanged,
      decoration: InputDecoration(
        label: labelWidget,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hint,
        hintStyle: AppFonts.body.copyWith(
          fontSize: 13,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        labelStyle: AppFonts.body.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:  BorderSide(color: focusColor, width: 1.2),
        ),
      ),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
