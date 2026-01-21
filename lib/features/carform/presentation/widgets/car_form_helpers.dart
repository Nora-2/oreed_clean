// utils/car_form_helpers.dart
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/option_item_register.dart';

class CarFormHelpers {
  static String tr(AppTranslations? t, String key, String fb) =>
      t?.text(key) ?? fb;

  static String? keyFromLabel(String? label, Map<String, String> dict) {
    if (label == null) return null;
    final found = dict.entries.firstWhere(
      (e) => e.value == label,
      orElse: () => const MapEntry<String, String>('', ''),
    );
    return found.key.isEmpty ? null : found.key;
  }

  static Color tagColor(int tag) {
    return tag.isEven ? AppColors.primary : AppColors.accentLight;
  }

  static List<OptionItemregister> toOptionItems(List<String> labels) {
    return List.generate(
      labels.length,
      (i) => OptionItemregister(label: labels[i], colorTag: i),
    );
  }

  static String mapGearToApi(String? k) {
    switch (k) {
      case 'manual':
        return 'Manual';
      case 'automatic':
        return 'Automatic';
      default:
        return '';
    }
  }

  static String dashIfEmpty(String? v) =>
      (v == null || v.trim().isEmpty) ? '-' : v;

  static String formatMoney(String v, AppTranslations? t) =>
      v.isEmpty ? '-' : '$v ${t?.text('currency_kwd') ?? 'د.ك'}';

  static List<String> getEngineCcValues() {
    return [
      '800',
      '1000',
      '1200',
      '1300',
      '1400',
      '1500',
      '1600',
      '1800',
      '2000',
      '2200',
      '2400',
      '2500',
      '2700',
      '3000',
      '3500',
      '4000',
      '4500',
      '5000',
      '6000',
    ];
  }
}
