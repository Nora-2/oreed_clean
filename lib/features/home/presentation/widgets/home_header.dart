import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/core/utils/appstring/app_string.dart';
import 'package:oreed_clean/features/home/presentation/widgets/search_field.dart';

class HomeHeader extends StatelessWidget {
  final bool isTablet;

  const HomeHeader({super.key, required this.isTablet});

  @override
  Widget build(BuildContext context) {
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
                                    backgroundImage:
                                        AssetImage(Appimage.logo),
                                  ),
              SvgPicture.asset(AppIcons.notification,width: 25,height: 25,),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${AppTranslations.of(context)!.text(AppString.homeTitle)} '
            '${AppTranslations.of(context)!.text(AppString.guest)} '
            '${AppTranslations.of(context)!.text(AppString.waveHand)}',
            style: const TextStyle(color: Colors.white70),
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
