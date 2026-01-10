import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/appstring/app_string.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool isTablet;
  final VoidCallback? onViewAll;

  const SectionHeader({
    super.key,
    required this.title,
    required this.isTablet,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        textDirection: TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 👈 View All
          InkWell(
            onTap: onViewAll,
            borderRadius: BorderRadius.circular(30),
            child: Row(
              children: [
                Text(
                  AppTranslations.of(context)!.text(AppString.viewAll),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: isTablet ? 15 : 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.neutral50,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: SvgPicture.asset(
                    AppIcons.arrowLeft,
                    width: 10,
                    height: 10,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          // 🏷️ Title
          Row(
            children: [
              Container(
                width: 2.5,
                height: isTablet ? 22 : 16,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class SectionsTitle extends StatelessWidget {
  const SectionsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFFFF9F00),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              appTrans?.text('discover_sections') ?? 'اكتشف الأقسام',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
