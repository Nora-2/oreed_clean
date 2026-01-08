import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';

class OnboardingBottomButtons extends StatelessWidget {
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback? onLoginPressed;
  final VoidCallback? onRegisterPressed;

  const OnboardingBottomButtons({
    super.key,
    required this.isLast,
    required this.onNext,
    this.onLoginPressed,
    this.onRegisterPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLast) {
      return SizedBox(
        width: double.infinity,
        child: CustomButton(
          text: AppTranslations.of(context)!.text('onboarding_next'),
          onTap: onNext,
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: _buildPrimaryButton(
            context,
            text: AppTranslations.of(context)!.text('onboarding_register'),
            onTap: onRegisterPressed,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _buildSecondaryButton(
            context,
            text: AppTranslations.of(context)!.text('onboarding_login'),
            onTap: onLoginPressed,
          ),
        ),
      ],
    );
  }

  // ---------- PRIVATE BUILDERS (same file) ----------

  Widget _buildPrimaryButton(
    BuildContext context, {
    required String text,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xff1146D1),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
             Padding(
              padding: EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_forward,
                  size: 30,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(
    BuildContext context, {
    required String text,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.secondary),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style:  TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
             Padding(
              padding: EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_forward,
                  size: 30,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
