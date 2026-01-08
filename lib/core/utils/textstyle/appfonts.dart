import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

/// App-wide fonts & text styles
class AppFonts {
  AppFonts._(); // private constructor

  // Family
  static const String primaryFont = 'Almarai';

  // Sizes
  static const double fontSizeSmall = 12;
  static const double fontSizeRegular = 14;
  static const double fontSizeMedium = 16;
  static const double fontSizeLarge = 18;
  static const double fontSizeXLarge = 22;
  static const double fontSizeXXLarge = 26;

  // Weights
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // Headings
  static const TextStyle heading1 = TextStyle(
    fontFamily: primaryFont,
    fontSize: fontSizeXXLarge,
    fontWeight: bold,
    color: Colors.black,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: primaryFont,
    fontSize: fontSizeXLarge,
    fontWeight: bold,
    color: Colors.black,
  );

  // Sub / Title
  static const TextStyle title = TextStyle(
    fontFamily: primaryFont,
    fontSize: fontSizeLarge,
    fontWeight: semiBold,
    color: Colors.black,
  );

  // Body
  static const TextStyle body = TextStyle(
    fontFamily: primaryFont,
    fontSize: fontSizeMedium,
    fontWeight: regular,
    color: Colors.black,
  );

  static  TextStyle bodyMuted = TextStyle(
    fontFamily: primaryFont,
    fontSize: fontSizeMedium,
    fontWeight: regular,
    color: AppColors.black2,
  );

  // Caption
  static  TextStyle caption = TextStyle(
    fontFamily: primaryFont,
    fontSize: fontSizeSmall,
    fontWeight: regular,
    color: AppColors.black2,
  );

  // Link / Button
  static  TextStyle link = TextStyle(
    fontFamily: primaryFont,
    fontSize: fontSizeRegular,
    fontWeight: medium,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  static const TextStyle button = TextStyle(
    fontFamily: primaryFont,
    fontSize: fontSizeLarge,
    fontWeight: semiBold,
    color: Colors.white,
  );
}
