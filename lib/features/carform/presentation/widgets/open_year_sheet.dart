
  // Added helpers reintroduced after refactor
  import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/bottomsheets/option_sheet_register_grid_year.dart';
import 'package:oreed_clean/core/utils/option_item_register.dart';

Future<String?> openYearSheet(
      BuildContext context, String? currentYear) async {
    final nowYear = DateTime.now().year;

    final recent = <String>[];
    final mid = <String>[];
    final old = <String>[];
    final classic = <String>[]; // Ø¬Ø¯ÙŠØ¯: Ù‚Ø³Ù… ÙƒÙ„Ø§Ø³ÙŠÙƒÙŠ

    for (int y = nowYear + 1; y >= 2021; y--) {
      recent.add(y.toString());
    }
    for (int y = 2020; y >= 2010; y--) {
      mid.add(y.toString());
    }
    for (int y = 2009; y >= 1990; y--) {
      old.add(y.toString());
    }
    // ÙƒÙ„Ø§Ø³ÙŠÙƒÙŠ: Ø§Ù„Ø£Ø¹ÙˆØ§Ù… Ø§Ù„Ø£Ù‚Ø¯Ù…
    for (int y = 1989; y >= 1970; y--) {
      classic.add(y.toString());
    }
    final appTrans = AppTranslations.of(context);
    final groupedOptions = {
      appTrans?.text('options.year_cat.recent') ?? 'Recent:':
          _toOptionItems(recent),
      appTrans?.text('options.year_cat.mid') ?? 'Mid-range:':
          _toOptionItems(mid),
      appTrans?.text('options.year_cat.old') ?? 'Old:': _toOptionItems(old),
      appTrans?.text('options.year_cat.classic') ?? 'Classic:':
          _toOptionItems(classic),
    };

    return showAppOptionSheetregistergridyear(
      context: context,
      title: appTrans?.text('select.choose_year') ?? 'Select Year',
      subtitle: appTrans?.text('select.year_subtitle') ??
          'Select the model year to show correct specifications.',
      hint: appTrans?.text('select.search_year') ?? 'Search for year',
      groupedOptions: groupedOptions,
      current: currentYear,
    );
  }
   List<OptionItemregister> _toOptionItems(
    List<String> labels,
  ) {
    return List.generate(labels.length,
        (i) => OptionItemregister(label: labels[i], colorTag: i));
  }