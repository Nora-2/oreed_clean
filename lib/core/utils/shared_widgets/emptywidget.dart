import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';

Widget emptyAdsView({
  required BuildContext context,
  required String title,
  required String button,
  required String subtitle,
  required String image,
  required bool visible,
  required VoidCallback onAddPressed,
}) {
  return SingleChildScrollView(
    physics: const NeverScrollableScrollPhysics(),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(image),

          const SizedBox(height: 16),

          /// Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1C1E),
            ),
          ),

          const SizedBox(height: 6),

          /// Subtitle
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF8E8E93),
            ),
          ),

          const SizedBox(height: 32),

          Visibility(
            visible: visible,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CustomButton(onTap: onAddPressed, text: button)),
          ),
        ],
      ),
    ),
  );
}
