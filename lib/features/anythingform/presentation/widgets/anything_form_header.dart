import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

class AnythingFormHeader extends StatelessWidget {
  const AnythingFormHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);
    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffe8e8e9),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 40),
            Text(
              appTrans?.text('page.enter_ad_details') ??
                  'Enter your ad details',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
