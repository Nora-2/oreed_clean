import 'package:flutter/material.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/shared_widgets/emptywidget.dart';

class Emptyview extends StatelessWidget {
  const Emptyview({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return emptyAdsView(
      visible: false,
      context: context,
      button: AppTranslations.of(context)?.text("common.explore_ads") ?? '',
      image: AppIcons.emptyAds,
      title: AppTranslations.of(context)?.text("no_ads") ?? '',
      subtitle:
          AppTranslations.of(
            context,
          )?.text("company_details.no_ads_subtitle") ??
          '',
      onAddPressed: () => Navigator.pushNamed(context, Routes.homelayout),
    );
  }
}
