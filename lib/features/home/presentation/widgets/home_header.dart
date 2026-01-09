import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/core/utils/appstring/app_string.dart';
import 'package:oreed_clean/features/home/presentation/widgets/search_field.dart';

class HomeHeader extends StatelessWidget {
  final bool isTablet;

  const HomeHeader({super.key, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);
    final prefs = AppSharedPreferences();
    final String displayName =
        (prefs.userNameAr?.trim().isNotEmpty == true
                ? prefs.userNameAr!
                : (prefs.userName?.trim().isNotEmpty == true
                      ? prefs.userName!
                      : (AppTranslations.of(context)?.text('guest_name') ??
                            'ضيف')))
            .split(' ') // in case of full name, take first part
            .first;
    return Padding(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(Appimage.logo),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.notification);
                },
                child: SvgPicture.asset(
                  AppIcons.notification,
                  width: 25,
                  height: 25,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            (appTrans?.text('welcome_message') ?? 'هلا ومرحبا {name} 👋')
                .replaceAll('{name}', displayName),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppTranslations.of(context)!.text(AppString.homeSubtitle),
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 20 : 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const HomeSearchField(),
        ],
      ),
    );
  }
}
