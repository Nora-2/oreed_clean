
  import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

Map<String, Style> getHtmlStyles(Color textColor, bool isDark) {
    return {
      "body": Style(
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
        fontSize: FontSize(15),
        lineHeight: const LineHeight(1.8),
        color: textColor,
        textAlign: TextAlign.justify,
      ),
      "h1": Style(
        fontSize: FontSize(24),
        fontWeight: FontWeight.w800,
        color: AppColors.primary,
        margin: Margins.only(bottom: 16, top: 12),
        textAlign: TextAlign.start,
      ),
      "h2": Style(
        fontSize: FontSize(20),
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
        margin: Margins.only(bottom: 12, top: 10),
      ),
      "h3": Style(
        fontSize: FontSize(18),
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        margin: Margins.only(bottom: 10, top: 8),
      ),
      "h4": Style(
        fontSize: FontSize(16),
        fontWeight: FontWeight.w600,
        color: textColor,
        margin: Margins.only(bottom: 8, top: 6),
      ),
      "p": Style(
        margin: Margins.only(bottom: 12),
        color: textColor,
      ),
      "ul": Style(
        margin: Margins.only(bottom: 12, top: 8, left: 20, right: 16),
        color: textColor,
      ),
      "ol": Style(
        margin: Margins.only(bottom: 12, top: 8, left: 20, right: 16),
        color: textColor,
      ),
      "li": Style(
        margin: Margins.only(bottom: 8, left: 0),
        color: textColor,
      ),
      "a": Style(
        color: AppColors.primary,
        textDecoration: TextDecoration.underline,
        fontWeight: FontWeight.w600,
      ),
      "strong": Style(
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      "em": Style(
        fontStyle: FontStyle.italic,
        color: textColor,
      ),
      "blockquote": Style(
        backgroundColor: AppColors.primary.withValues(alpha: 0.08),
        padding: HtmlPaddings.all(12),
        margin: Margins.only(top: 12, bottom: 12, left: 8, right: 8),
        border:  Border(
          left: BorderSide(
            color: AppColors.primary,
            width: 4,
          ),
        ),
        fontStyle: FontStyle.italic,
        color: textColor,
      ),
      "code": Style(
        backgroundColor: isDark ? Colors.white10 : const Color(0xFFF0F1F3),
        padding: HtmlPaddings.symmetric(horizontal: 6, vertical: 2),
        fontSize: FontSize(13),
        fontFamily: 'monospace',
        color: AppColors.primary,
      ),
      "pre": Style(
        backgroundColor: isDark ? Colors.white10 : const Color(0xFFF0F1F3),
        padding: HtmlPaddings.all(12),
        margin: Margins.only(top: 10, bottom: 10),
        fontSize: FontSize(13),
      ),
      "table": Style(
        backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
        margin: Margins.only(top: 12, bottom: 12),
        padding: HtmlPaddings.all(0),
        border: Border.all(
          color: isDark ? Colors.white24 : const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      "thead": Style(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      ),
      "th": Style(
        padding: HtmlPaddings.all(10),
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
        textAlign: TextAlign.center,
      ),
      "td": Style(
        padding: HtmlPaddings.all(10),
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white12 : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      "hr": Style(
        margin: Margins.only(top: 16, bottom: 16),
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
      ),
      "img": Style(
        margin: Margins.only(top: 12, bottom: 12),
      ),
    };
  }