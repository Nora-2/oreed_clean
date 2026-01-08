import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

class OnboardingIndicators extends StatelessWidget {
  final int currentIndex;
  final int total;

  const OnboardingIndicators({
    super.key,
    required this.currentIndex,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        total,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 4,
          width: 15,
          decoration: BoxDecoration(
            color: index == currentIndex
                ? AppColors.primary
                : AppColors.secondary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}
