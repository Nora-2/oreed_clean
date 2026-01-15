import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/textstyle/appfonts.dart';

class SelectSheetFieldads extends StatelessWidget {
  const SelectSheetFieldads({
    super.key,
    required this.label,
    required this.onTap,
    this.height = 52,
    required this.hint,
    this.prefixIcon,
    this.redius = 10,
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
  });

  final dynamic label;
  final String hint;
  final VoidCallback onTap;
  final double height;
  final double redius;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final Widget? prefixIcon;
  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      height: 45,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(redius)),
      child: Material(
        elevation: 0,
        color: Colors.transparent, // Ensure material doesn't block background
        borderRadius: BorderRadius.circular(redius),
        child: TextFormField(
          readOnly: true, // Prevents keyboard from opening
          onTap: onTap,
          textAlign: isRTL ? TextAlign.right : TextAlign.left,
          decoration: InputDecoration(
            label: label,

            floatingLabelBehavior: floatingLabelBehavior,
            hintText: hint,
            hintStyle: AppFonts.body.copyWith(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
            prefixIcon: prefixIcon,
            filled: true,
            labelStyle: AppFonts.body.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ), // Make sure AppFonts is imported
            fillColor: Colors.white,

            // Optional: Add a suffix icon to show it is clickable
            suffixIcon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(redius),
              borderSide: const BorderSide(color: Colors.red, width: 1.2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(redius),
              borderSide: const BorderSide(color: Colors.red, width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(redius),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(redius),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}
