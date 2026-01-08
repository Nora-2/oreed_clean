import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/textstyle/apptext_style.dart';

class OnboardingTitle extends StatelessWidget {
  final String title;

  const OnboardingTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    const highlight = '"تريد"';

    if (!title.contains(highlight)) {
      return _baseText(title, isRTL);
    }

    final parts = title.split(highlight);

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: parts[0]),
          TextSpan(
            text: highlight,
            style: TextStyle(color: AppColors.primary),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
      textAlign: TextAlign.center,
      style: _style(isRTL),
    );
  }

  Widget _baseText(String text, bool isRTL) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: _style(isRTL),
    );
  }

  TextStyle _style(bool isRTL) {
    return AppTextStyles.title.copyWith(
      fontSize: isRTL ? 20 : 24,
      fontWeight: FontWeight.bold,
      color: AppColors.black,
    );
  }
}
