import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_radio_button.dart';
import 'package:oreed_clean/core/utils/shared_widgets/pin_choice_screen.dart';

class OptionCard extends StatelessWidget {
  final AdType value;
  final AdType groupValue;
  final String title;
  final String icon;

  final Color borderColor;

  final List<String> features;
  final String? badgeText;
  final String? extraEmoji;
  final ValueChanged<AdType> onChanged;

  const OptionCard({
    required this.value,
    required this.groupValue,
    required this.title,
    required this.icon,
    required this.borderColor,
    required this.features,
    this.badgeText,
    this.extraEmoji,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFEEF4FF)
                  : AppColors.whiteColor,
              border: Border.all(
                color: isSelected ? borderColor : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              textDirection: isRTL ? TextDirection.ltr : TextDirection.rtl,
              crossAxisAlignment: isRTL
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.start,
              children: [
                // Custom Radio Button
                CustomRadioButton(isSelected: isSelected),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // List of features
                      ...features.map(
                        (f) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            textDirection: isRTL
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            mainAxisAlignment: isRTL
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  f,
                                  textAlign: isRTL
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.grey.shade400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: SvgPicture.asset(icon),
                ),
              ],
            ),
          ),

          // Badge (Most Popular)
          if (badgeText != null)
            PositionedDirectional(
              top: 0,
              end: 44,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF9900),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  badgeText!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Extra Emoji/Image (Rocket/Megaphone)
          if (extraEmoji != null)
            PositionedDirectional(
              bottom: 10,
              end: 10,
              child: Image.asset(extraEmoji!),
            ),
        ],
      ),
    );
  }
}
