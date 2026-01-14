import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/textstyle/appfonts.dart';
import 'package:pinput/pinput.dart';

class OtpInputSection extends StatelessWidget {
  final TextEditingController controller;

  const OtpInputSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context)!;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        controller: controller,
        length: 4,
        autofocus: true,
        validator: (v) {
          if (v == null || v.isEmpty) {
            return t.text('code_required');
          }
          if (v.length < 4) {
            return t.text('code_too_short');
          }
          return null;
        },
        defaultPinTheme: _pinTheme(),
        focusedPinTheme: _pinTheme(border: AppColors.primary),
        submittedPinTheme: _pinTheme(border: AppColors.primary),
        errorPinTheme: _pinTheme(border: Colors.red),
      ),
    );
  }

  PinTheme _pinTheme({Color? border}) => PinTheme(
        width: 60,
        height: 60,
        textStyle: AppFonts.body.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border ?? Colors.grey.shade300),
        ),
      );
}
