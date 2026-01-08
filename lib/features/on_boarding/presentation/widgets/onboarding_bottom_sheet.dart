import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/on_boarding/presentation/widgets/onboarding_buttons.dart';
import 'package:oreed_clean/features/on_boarding/presentation/widgets/onboarding_describtion.dart';
import 'package:oreed_clean/features/on_boarding/presentation/widgets/onboarding_indecators.dart';
import 'package:oreed_clean/features/on_boarding/presentation/widgets/onboarging_title.dart';

class OnboardingBottomSheet extends StatelessWidget {
  final String title;
  final String description;
  final int currentIndex;
  final int total;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback? onLoginPressed;
  final VoidCallback? onRegisterPressed;

  const OnboardingBottomSheet({
    super.key,
    required this.title,
    required this.description,
    required this.currentIndex,
    required this.total,
    required this.isLast,
    required this.onNext,
    this.onLoginPressed,
    this.onRegisterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OnboardingTitle(title: title),
            const SizedBox(height: 16),
            OnboardingDescription(description: description),
            const SizedBox(height: 24),
            OnboardingIndicators(
              currentIndex: currentIndex,
              total: total,
            ),
            const SizedBox(height: 24),
            OnboardingBottomButtons(
              isLast: isLast,
              onNext: onNext,
              onLoginPressed: onLoginPressed,
              onRegisterPressed: onRegisterPressed,
            ),
          ],
        ),
      ),
    );
  }
}
