import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

/// App-wide text styles matching design system
class AppTextStyles {
  AppTextStyles._(); // Private constructor to prevent instantiation

  // Font family
  static const String _primaryFont = 'Almarai';

  // Font sizes
  // static const double _sizeXXSmall = 10;
  static const double _sizeSmall = 12;
  static const double _sizeRegular = 14;
  static const double _sizeMedium = 16;
  static const double _sizeLarge = 18;
  static const double _sizeXLarge = 22;
  static const double _sizeXXLarge = 26;

  // Font weights
  static const FontWeight _regular = FontWeight.w400;
  static const FontWeight _medium = FontWeight.w500;
  static const FontWeight _semiBold = FontWeight.w600;
  static const FontWeight _bold = FontWeight.w700;

  // ===== Heading Styles =====
  static const TextStyle heading1 = TextStyle(
    fontFamily: _primaryFont,
    fontSize: _sizeXXLarge,
    fontWeight: _bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: _primaryFont,
    fontSize: _sizeXLarge,
    fontWeight: _bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // ===== Title Styles =====
  static const TextStyle title = TextStyle(
    fontFamily: _primaryFont,
    fontSize: _sizeLarge,
    fontWeight: _semiBold,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: _primaryFont,
    fontSize: _sizeMedium,
    fontWeight: _semiBold,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ===== Body Styles =====
  static const TextStyle body = TextStyle(
    fontFamily: _primaryFont,
    fontSize: _sizeMedium,
    fontWeight: _regular,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyBold = TextStyle(
    fontFamily: _primaryFont,
    fontSize: _sizeMedium,
    fontWeight: _semiBold,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMuted = TextStyle(
    fontFamily: _primaryFont,
    fontSize: _sizeMedium,
    fontWeight: _regular,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _primaryFont,
    fontSize: _sizeRegular,
    fontWeight: _regular,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // ===== Small/Caption Styles =====
  static const TextStyle caption = TextStyle(
    fontFamily: _primaryFont,
    fontSize: _sizeSmall,
    fontWeight: _regular,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle captionBold = TextStyle(
    fontFamily: _primaryFont,
    fontSize: _sizeSmall,
    fontWeight: _semiBold,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle smallGrey = TextStyle(
    fontFamily: _primaryFont,
    fontSize: _sizeSmall,
    fontWeight: _regular,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ===== Button Styles =====
  static  TextStyle button = TextStyle(
    fontFamily: _primaryFont,
    fontSize: _sizeLarge,
    fontWeight: _semiBold,
    color: AppColors.whiteColor,
    height: 1.2,
  );

  static  TextStyle buttonSmall = TextStyle(
    fontFamily: _primaryFont,
    fontSize: _sizeMedium,
    fontWeight: _semiBold,
    color: AppColors.whiteColor,
    height: 1.2,
  );

  // ===== Link Styles =====
  static  TextStyle link = TextStyle(
    fontFamily: _primaryFont,
    fontSize: _sizeRegular,
    fontWeight: _medium,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
    height: 1.5,
  );

  static  TextStyle linkBold = TextStyle(
    fontFamily: _primaryFont,
    fontSize: _sizeRegular,
    fontWeight: _semiBold,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
    height: 1.5,
  );

  // ===== Error/Status Styles =====
  static const TextStyle errorText = TextStyle(
    fontFamily: _primaryFont,
    fontSize: _sizeRegular,
    fontWeight: _regular,
    color: AppColors.error,
    height: 1.4,
  );

  static const TextStyle successText = TextStyle(
    fontFamily: _primaryFont,
    fontSize: _sizeRegular,
    fontWeight: _regular,
    color: AppColors.success,
    height: 1.4,
  );
}
