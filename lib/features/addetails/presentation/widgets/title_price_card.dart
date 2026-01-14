// lib/view/screens/details_ads/widgets/title_price_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';

class TitlePriceCard extends StatelessWidget {
  final String dateText; // مثال: "2025-07-21"
  final String title; // عنوان الإعلان
  final String priceText; // مثال: "22,5 ألف د.ك"
  final String pinned;
  final int sectionId;
  final String? viewsText; // مثال: "123 مشاهدة"
  final String? cityText; // مثال: "العاصمة"
  final String? stateText; // مثال: "الكويت"
  final String? type;

  const TitlePriceCard({
    super.key,
    required this.dateText,
    required this.title,
    required this.priceText,
    this.pinned = '',
    this.viewsText,
    this.type = '',
    this.cityText,
    this.stateText,
    required this.sectionId,
  });

  // Helper method to remove .00 from price
  String _cleanPrice(String price) {
    return price.replaceAll('.00', '').replaceAll(',00', '');
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final textTheme = Theme.of(context).textTheme;
    final t = AppTranslations.of(context);
    final cleanedPrice = _cleanPrice(priceText);

    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    height: 1.8,
                    fontSize: 18,
                    color: const Color(0xFF111827),
                  ),
                ),
              ),
              Container(),
              _MetaItem(
                icon: AppIcons.loadingTime,
                label: dateText,
                color: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (cityText != null || stateText != null)
            Row(
              children: [
                cleanedPrice.isNotEmpty &&
                        cleanedPrice != (t?.text('currency_kwd') ?? 'د.ك')
                    ? sectionId == 3
                          ? Expanded(
                              child: Align(
                                alignment: isRTL
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Text(
                                  type ?? '',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    height: 1.8,
                                    fontSize: 14,
                                    color: const Color(0xFF111827),
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: Align(
                                alignment: isRTL
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: _PricePill(text: cleanedPrice),
                              ),
                            )
                    : const SizedBox.shrink(),
                if (cityText != null && stateText != null)
                  const SizedBox(width: 2),
                if (stateText != null)
                  _MetaItem(
                    icon: AppIcons.locationCountry,
                    label: '$stateText , $cityText',
                    color: AppColors.primary,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _PricePill extends StatelessWidget {
  final String text;

  const _PricePill({required this.text});

  @override
  Widget build(BuildContext context) {
    final parts = text.trim().split(RegExp(r'\s+'));
    final number = parts.isNotEmpty ? parts.first : text;
    final rest = parts.length > 1
        ? text.substring(number.length).trimLeft()
        : '';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Color(0xFF1649D3),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (rest.isNotEmpty) ...[
          const SizedBox(width: 6),
          Text(
            rest,
            style: const TextStyle(
              color: Color(0xFF1649D3),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  final String icon;
  final String label;
  final Color? color;

  const _MetaItem({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(icon, width: 12, height: 12),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
