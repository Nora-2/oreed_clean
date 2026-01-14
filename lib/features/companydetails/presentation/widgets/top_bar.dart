import 'package:flutter/material.dart';
import 'package:oreed_clean/core/enmus/enum.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/companydetails/presentation/widgets/segmented_pill_toggel.dart';

class TopBarads extends StatelessWidget {
  final ViewMode mode;
  final ValueChanged<ViewMode> onModeChanged;

  const TopBarads({super.key, 
    required this.mode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
        child: Row(
          textDirection: isRTL ? TextDirection.ltr : TextDirection.rtl,
          mainAxisAlignment:
              isRTL ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            SegmentedPillToggle(value: mode, onChanged: onModeChanged),
            const Spacer(),
            Text(
              t?.text('tabs.ads') ?? "Ads",
              style:  TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ));
  }
}