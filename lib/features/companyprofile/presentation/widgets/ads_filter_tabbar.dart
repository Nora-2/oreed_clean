
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/pill_tab.dart';

class AdsFilterTabBar extends StatelessWidget {
  final TabController tabController;
  final int companyAdsCount;
  final int personalAdsCount;

  const AdsFilterTabBar({
    required this.tabController,
    required this.companyAdsCount,
    required this.personalAdsCount,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context)!;

    return Container(
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
      ),
      child: TabBar(
        controller: tabController,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(24),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.zero,
        dividerColor: Colors.transparent,
        // splashFactory: NoSplash.splashFactory,
        // overlayColor: WidgetStateProperty.all(Colors.transparent),
        labelPadding: EdgeInsets.zero,
        tabs: [
          PillTab(
            icon: AppIcons.building,
            label: t.text('company_ads') ,
            isSelected: tabController.index == 0,
          ),
          PillTab(
            icon: AppIcons.profile,
            label: t.text('personal_ads') ,
            isSelected: tabController.index == 1,
          ),
        ],
      ),
    );
  }
}
