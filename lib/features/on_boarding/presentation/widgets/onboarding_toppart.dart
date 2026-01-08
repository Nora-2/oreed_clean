import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';

class OnboardingTopBar extends StatelessWidget {
  final bool isLast;
  final VoidCallback? onSkip;

  const OnboardingTopBar({
    super.key,
    required this.isLast,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            textDirection: isRTL ? TextDirection.ltr : TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                Appimage.logo,
                width: 40,
                height: 40,
              ),
              if (!isLast)
                TextButton(
                  onPressed: onSkip,
                  child: Text(
                    AppTranslations.of(context)!.text('onboarding_skip'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                )
              else
                const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }
}
