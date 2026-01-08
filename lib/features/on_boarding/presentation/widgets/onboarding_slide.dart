import 'package:flutter/material.dart';
import 'package:oreed_clean/features/on_boarding/presentation/widgets/onboarding_back.dart';
import 'package:oreed_clean/features/on_boarding/presentation/widgets/onboarding_bottom_sheet.dart';
import 'package:oreed_clean/features/on_boarding/presentation/widgets/onboarding_toppart.dart';

class OnboardingSlide extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String description;
  final int currentIndex;
  final int total;
  final VoidCallback onNext;
  final VoidCallback? onSkip;
  final bool isLast;
  final VoidCallback? onLoginPressed;
  final VoidCallback? onRegisterPressed;

  const OnboardingSlide({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.description,
    required this.currentIndex,
    required this.total,
    required this.onNext,
    this.onSkip,
    this.isLast = false,
    this.onLoginPressed,
    this.onRegisterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        OnboardingBackground(imageAsset: imageAsset),

        OnboardingTopBar(
          isLast: isLast,
          onSkip: onSkip,
        ),

        OnboardingBottomSheet(
          title: title,
          description: description,
          currentIndex: currentIndex,
          total: total,
          isLast: isLast,
          onNext: onNext,
          onLoginPressed: onLoginPressed,
          onRegisterPressed: onRegisterPressed,
        ),
      ],
    );
  }
}
