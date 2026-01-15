import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

class RowWithArrow extends StatelessWidget {
  static const double _rowHeight = 50;

  final String? title;
  final String? icon;
  final VoidCallback? onPressed;
  final bool? hasArrow;
  final EdgeInsetsGeometry? margin;
  final TextStyle? textStyle;

  final Widget? trailing;

  const RowWithArrow({
    super.key,
    this.title,
    this.icon,
    this.onPressed,
    this.hasArrow,
    this.margin,
    this.textStyle,

    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final showArrow = hasArrow == null || hasArrow == true;

    return Padding(
      // هوامش رأسية فقط – العرض يتظبط من Padding الأب
      padding: margin ?? const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        height: _rowHeight,
        width: double.infinity,
        child: Card(
          color: Colors.grey.shade100,
          elevation: .5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: Row(
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  SvgPicture.asset(
                    icon!,
                    width: 35,
                    height: 35,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        textStyle ??
                        const TextStyle(
                          fontSize: 16,
                          height: 1.8,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF676768),
                        ),
                  ),
                  Spacer(),
                  if (trailing != null) ...[
                    const SizedBox(width: 8),
                    trailing!,
                  ],
                  if (showArrow)
                    Icon(
                      isRTL ? Icons.arrow_forward : Icons.arrow_forward,
                      size: 22,
                      color: AppColors.primary,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
