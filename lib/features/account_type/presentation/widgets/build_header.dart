import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/core/utils/shared_widgets/circelback.dart';
import 'package:oreed_clean/core/utils/textstyle/apptext_style.dart';

class BuildHeader extends StatelessWidget {
  const BuildHeader({
    super.key,
    required double horizontalPadding,
    required double headerTopPadding,
    required double headerBottomPadding,
    required this.context,
    required double titleFontSize,
  }) : _horizontalPadding = horizontalPadding, _headerTopPadding = headerTopPadding, _headerBottomPadding = headerBottomPadding, _titleFontSize = titleFontSize;

  final double _horizontalPadding;
  final double _headerTopPadding;
  final double _headerBottomPadding;
  final BuildContext context;
  final double _titleFontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:  EdgeInsets.fromLTRB(
        _horizontalPadding,
        _headerTopPadding,
        _horizontalPadding,
        _headerBottomPadding,
      ),
      decoration:  BoxDecoration(
         color: AppColors.primary,
        image: DecorationImage(
          image: AssetImage(Appimage.back), // نفس الخلفية اللي عندك
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
             CircleBack(context: context, background_color: Colors.white),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            AppTranslations.of(context)!.text('select_account_type_title'),
            textAlign: TextAlign.center,
            style: AppTextStyles.title.copyWith(
              fontSize: _titleFontSize,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppTranslations.of(context)!.text('select_account_type_subtitle'),
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
