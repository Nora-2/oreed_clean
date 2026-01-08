import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/textstyle/apptext_style.dart';

class OnboardingDescription extends StatelessWidget {
  final String description;

  const OnboardingDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      textAlign: TextAlign.center,
      style: AppTextStyles.body.copyWith(
        fontSize: 16,
        color: Colors.grey[600],
        height: 1.5,
      ),
    );
  }
}
