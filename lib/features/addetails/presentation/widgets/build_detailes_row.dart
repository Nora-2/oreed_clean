import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

class DetailsRowItem {
  final String label;
  final String value;
  const DetailsRowItem({required this.label, required this.value});
}

class DetailsTableSimple extends StatelessWidget {
  final String sectionTitle;
  final List<DetailsRowItem> rows;

  final double radius;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry contentPadding; // inside the card
  final double rowPaddingV; // vertical padding per row
  final bool zebra; // alternate background for long lists

  const DetailsTableSimple({
    super.key,
    required this.sectionTitle,
    required this.rows,
    this.radius = 12,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
    this.rowPaddingV = 10,
    this.zebra = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = AppColors.whiteColor;
    final borderColor = theme.dividerColor.withOpacity(isDark ? .25 : .35);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section title (right aligned, strong but not flashy)
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 6, bottom: 6),
          child: Text(
            sectionTitle,
            textAlign: TextAlign.right,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        // Card
        Container(
          margin: margin,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: borderColor),
          ),
          child: Padding(
            padding: contentPadding,
            child: Column(
              children: [
                for (int i = 0; i < rows.length; i++) ...[
                  _RowItem(
                    label: rows[i].label,
                    value: rows[i].value,
                    rowPaddingV: rowPaddingV,
                    bg: zebra && i.isOdd
                        ? (isDark
                              ? Colors.white.withOpacity(.03)
                              : const Color(0xFFF9FAFB))
                        : Colors.transparent,
                  ),
                  if (i != rows.length - 1)
                    Divider(height: 1, thickness: 1, color: borderColor),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RowItem extends StatelessWidget {
  final String label;
  final String value;
  final double rowPaddingV;
  final Color bg;
  const _RowItem({
    required this.label,
    required this.value,
    required this.rowPaddingV,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: bg,
      padding: EdgeInsetsDirectional.only(
        top: rowPaddingV,
        bottom: rowPaddingV,
        start: 4,
        end: 4,
      ),
      constraints: const BoxConstraints(minHeight: 52), // large touch target
      child: Row(
        children: [
          // Label (right side in RTL)
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                label,
                textAlign: TextAlign.right,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Value (left)
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                textAlign: TextAlign.left,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<DetailsRowItem> buildDetailsRows(
  int sectionId,
  Map<String, dynamic> x,
  context,
) {
  final t = AppTranslations.of(context);
  switch (sectionId) {
    case 1:
      return [
        DetailsRowItem(
          label: t?.text('ad_details.car_marka') ?? 'الماركه',
          value: x['car_marka_name'] ?? '',
        ),
        DetailsRowItem(
          label: t?.text('ad_details.model') ?? 'الموديل',
          value: x['car_model_name'] ?? '',
        ),
        DetailsRowItem(
          label: t?.text('ad_details.color') ?? 'اللون',
          value: x['color'] ?? '',
        ),
        DetailsRowItem(
          label: t?.text('ad_details.year') ?? 'السنة',
          value: '${x['year'] ?? ''}',
        ),
        DetailsRowItem(
          label: t?.text('ad_details.fuel_type') ?? 'نوع الوقود',
          value: x['fuel_type'] ?? '',
        ),
        DetailsRowItem(
          label: t?.text('ad_details.transmission') ?? 'ناقل الحركة',
          value: x['transmission'] ?? '',
        ),
        DetailsRowItem(
          label: t?.text('ad_details.condition') ?? 'الحاله',
          value: x['condition'] ?? '',
        ),
        DetailsRowItem(
          label: t?.text('ad_details.engine_size') ?? 'قوه المحرك',
          value: x['engine_size'] ?? '',
        ),
        DetailsRowItem(
          label: t?.text('ad_details.kilometers') ?? 'الكيلومترات',
          value: x['kilometers']?.toString() ?? '',
        ),
      ];
    case 2:
      return [
        DetailsRowItem(
          label: t?.text('ad_details.section') ?? 'القسم',
          value: '${x['sub_category_name'] ?? ''}',
        ),
        DetailsRowItem(
          label: t?.text('ad_details.rooms') ?? 'عدد الغرف',
          value: '${x['rooms'] ?? ''}',
        ),
        DetailsRowItem(
          label: t?.text('ad_details.bathrooms') ?? 'عدد الحمامات',
          value: '${x['bathrooms'] ?? ''}',
        ),
        DetailsRowItem(
          label: t?.text('ad_details.area') ?? 'المساحة',
          value: '${x['area'] ?? ''} م²',
        ),
        DetailsRowItem(
          label: t?.text('ad_details.floor') ?? 'الطابق',
          value: '${x['floor'] ?? ''}',
        ),
      ];
    case 3:
      return [];
    default:
      return [
        if (x['section'] != null)
          DetailsRowItem(
            label: t?.text('ad_details.section') ?? 'القسم',
            value: x['section']?.toString() ?? '—',
          ),
        if (x['category_name'] != null)
          DetailsRowItem(
            label: t?.text('ad_details.sub_category') ?? 'القسم الفرعي',
            value: x['category_name']?.toString() ?? '—',
          ),
        if (x['price_before_discount'] != null)
          DetailsRowItem(
            label:
                t?.text('ad_details.price_before_discount') ??
                'السعر قبل الخصم',
            value: x['price_before_discount']?.toString() ?? '—',
          ),
        if (x['color'] != null)
          DetailsRowItem(
            label: t?.text('ad_details.color') ?? 'اللون',
            value: x['color'] ?? '—',
          ),
        if (x['new_or_used'] != null)
          DetailsRowItem(
            label: t?.text('ad_details.new_or_used') ?? 'الحاله',
            value: x['new_or_used'] ?? '—',
          ),
        if (x['model'] != null)
          DetailsRowItem(
            label: t?.text('ad_details.model') ?? 'الموديل',
            value: x['model'] ?? '—',
          ),
        if (x['condition'] != null)
          DetailsRowItem(
            label: t?.text('ad_details.condition') ?? 'الحاله',
            value: x['condition'] ?? '—',
          ),
        if (x['area'] != null)
          DetailsRowItem(
            label: t?.text('ad_details.area') ?? 'المساحه',
            value: x['area'].toString(),
          ),
        if (x['size'] != null)
          DetailsRowItem(
            label: t?.text('ad_details.size') ?? 'الحجم',
            value: x['size']?.toString() ?? '—',
          ),
        if (x['age'] != null)
          DetailsRowItem(
            label: t?.text('ad_details.age') ?? 'العمر',
            value: x['age']?.toString() ?? '—',
          ),
      ];
  }
}

String sectionTitle(int sectionId, context) {
  final t = AppTranslations.of(context);
  switch (sectionId) {
    case 1:
      return t?.text('ad_details.title_car') ?? 'تفاصيل السيارة';
    case 2:
      return t?.text('ad_details.title_property') ?? 'تفاصيل العقار';
    case 3:
      return t?.text('ad_details.title_technician') ?? 'تفاصيل الفني';
    default:
      return t?.text('ad_details.title_default') ?? 'تفاصيل الإعلان';
  }
}
