import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/features/companydetails/domain/entities/company_entity.dart';

class SocialMediaPill extends StatelessWidget {
  final CompanyDetailsEntity company;
  final Function(String) onOpenUrl;

  const SocialMediaPill({
    super.key,
    required this.company,
    required this.onOpenUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(.8),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (company.facebook != null)
            _icon(AppIcons.facebook, company.facebook!),
          if (company.instagram != null)
            _icon(AppIcons.insta, company.instagram!),
          if (company.tiktok != null) _icon(AppIcons.tiktok, company.tiktok!),
          if (company.snapchat != null) _icon(AppIcons.snap, company.snapchat!),
        ],
      ),
    );
  }

  Widget _icon(String asset, String url) {
    return GestureDetector(
      onTap: () => onOpenUrl(url),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SvgPicture.asset(
          asset,
          width: 22,
          height: 22,
          color: Colors.white,
        ),
      ),
    );
  }
}
