
  import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/features/carform/presentation/widgets/color_grid_sheet.dart';
  String _tr(AppTranslations? t, String key, String fb) => t?.text(key) ?? fb;



  List<ColorSection> colorsections (BuildContext context)  {
    final appTrans = AppTranslations.of(context);
    const String paletteIcon = AppIcons.colorPallete;

    // Mock Data mimicking the image
   return  [
      // ================== Ø§Ù„Ø£Ù„ÙˆØ§Ù† Ø§Ù„Ø£Ø³Ø§Ø³ÙŠØ© ==================
      ColorSection(
          title: appTrans?.text('options.color_cat.basic') ?? "Basic Colors",
          items: [
            ColorItem(
                id: '1',
                label: _tr(appTrans, 'options.color.black', "Black"),
                iconColor: Colors.black,
                iconPath: paletteIcon),
            ColorItem(
                id: '2',
                label: _tr(appTrans, 'options.color.silver', "Silver"),
                iconColor: const Color(0xFFBDBDBD),
                iconPath: paletteIcon),
            ColorItem(
                id: '3',
                label: _tr(appTrans, 'options.color.gray', "Gray"),
                iconColor: const Color(0xFF9E9E9E),
                iconPath: paletteIcon),
            ColorItem(
                id: '4',
                label: _tr(appTrans, 'options.color.navy', "Navy"),
                iconColor: const Color(0xFF0D47A1),
                iconPath: paletteIcon),
            ColorItem(
                id: '5',
                label: _tr(appTrans, 'options.color.green', "Green"),
                iconColor: const Color.fromARGB(205, 0, 128, 0),
                iconPath: paletteIcon),
            ColorItem(
                id: '6',
                label: _tr(appTrans, 'options.color.yellow', "Yellow"),
                iconColor: Colors.yellow,
                iconPath: paletteIcon),
            ColorItem(
                id: '7',
                label: _tr(appTrans, 'options.color.orange', "Orange"),
                iconColor: Colors.orange,
                iconPath: paletteIcon),
            ColorItem(
                id: '8',
                label: _tr(appTrans, 'options.color.white', "White"),
                iconColor: const Color(0xFFF5F5F5),
                iconPath: paletteIcon),
            ColorItem(
                id: '9',
                label: _tr(appTrans, 'options.color.red', "Red"),
                iconColor: const Color(0xFFD32F2F),
                iconPath: paletteIcon),
            ColorItem(
                id: '10',
                label: _tr(appTrans, 'options.color.blue', "Blue"),
                iconColor: const Color(0xFF1565C0),
                iconPath: paletteIcon),
          ]),

      // ================== Ø£Ù„ÙˆØ§Ù† Ø¥Ø¶Ø§ÙÙŠØ© / ÙØ§Ø®Ø±Ø© ==================
      ColorSection(
          title: appTrans?.text('options.color_cat.extra') ?? "Premium Colors",
          items: [
            ColorItem(
                id: '11',
                label: _tr(appTrans, 'options.color.brown', "Brown"),
                iconColor: const Color(0xFF6D4C41),
                iconPath: paletteIcon),
            ColorItem(
                id: '12',
                label: _tr(appTrans, 'options.color.beige', "Beige"),
                iconColor: const Color(0xFFD9C9A3),
                iconPath: paletteIcon),
            ColorItem(
                id: '13',
                label: _tr(appTrans, 'options.color.champagne', "Champagne"),
                iconColor: const Color(0xFFF7E7CE),
                iconPath: paletteIcon),
            ColorItem(
                id: '14',
                label: _tr(appTrans, 'options.color.maroon', "Maroon"),
                iconColor: const Color(0xFF7B001C),
                iconPath: paletteIcon),
            ColorItem(
                id: '15',
                label: _tr(appTrans, 'options.color.bronze', "Bronze"),
                iconColor: const Color(0xFFC0A27B),
                iconPath: paletteIcon),
            ColorItem(
                id: '16',
                label: _tr(appTrans, 'options.color.copper', "Copper"),
                iconColor: const Color(0xFFB87333),
                iconPath: paletteIcon),
            ColorItem(
                id: '17',
                label: _tr(appTrans, 'options.color.gold', "Gold"),
                iconColor: const Color(0xFFF2C230),
                iconPath: paletteIcon),
            ColorItem(
                id: '18',
                label: _tr(appTrans, 'options.color.turquoise', "Turquoise"),
                iconColor: const Color(0xFF0097A7),
                iconPath: paletteIcon),
          ]),

      // ================== Ø£Ù„ÙˆØ§Ù† Ø®Ø§ØµØ© Ù„Ù„Ø³ÙŠØ§Ø±Ø§Øª Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ© ==================
      ColorSection(
          title: appTrans?.text('options.color_cat.sports') ?? "Sport Colors",
          items: [
            ColorItem(
                id: '19',
                label: _tr(appTrans, 'options.color.mauve', "Mauve"),
                iconColor: const Color(0xFFB39DDB),
                iconPath: paletteIcon),
            ColorItem(
                id: '20',
                label: _tr(appTrans, 'options.color.purple', "Purple"),
                iconColor: const Color(0xFF6A1B9A),
                iconPath: paletteIcon),
            ColorItem(
                id: '21',
                label: _tr(
                    appTrans, 'options.color.dark_turquoise', "Dark Turquoise"),
                iconColor: const Color(0xFF006064),
                iconPath: paletteIcon),
            ColorItem(
                id: '22',
                label: _tr(appTrans, 'options.color.lemon', "Lemon"),
                iconColor: const Color(0xFFCDDC39),
                iconPath: paletteIcon),
          ]),
    ];

  

   
  }
