import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/features/addetails/domain/entities/ad_detiles_entity.dart';
import 'package:oreed_clean/features/addetails/presentation/widgets/socialbutton.dart';

class SocilaLinkes extends StatelessWidget {
  const SocilaLinkes({super.key, required this.context, required this.ad});

  final BuildContext context;
  final AdDetailesEntity ad;

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);
    final instagram = ad.extra['instagram'];
    final facebook = ad.extra['facebook'];
    final hasInstagram =
        instagram != 'null' &&
        instagram is String &&
        instagram.trim().isNotEmpty;
    final hasFacebook =
        facebook != 'null' && facebook is String && facebook.trim().isNotEmpty;

    final items = <Widget>[
      if (hasFacebook)
        SocilaButton(profileUrl: facebook, iconAsset: AppIcons.facebook),
      if (hasInstagram)
        SocilaButton(profileUrl: instagram, iconAsset: AppIcons.insta),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0x14000000)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: items.isEmpty
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.secondary,
                        ),
                        height: 40,
                        width: 3,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t?.text('ad_details.social_title') ??
                                'حسابات المعلن على التواصل:',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            t?.text('ad_details.social_cta') ??
                                'اضغط هنا لمشاهدة حسابات المعلن',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: items,
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.secondary,
                        ),
                        height: 40,
                        width: 3,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t?.text('social_accounts_title') ??
                                'حسابات المعلن على التواصل:',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            t?.text('ad_details.social_cta') ??
                                'اضغط هنا لمشاهدة حسابات المعلن',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: items,
                  ),
                ],
              ),
      ),
    );
  }
}
