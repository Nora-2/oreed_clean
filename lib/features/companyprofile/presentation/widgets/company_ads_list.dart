import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/companyprofile/domain/entities/company_ad_entity.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/adbanner_carousel.dart';

class CompanyAdsList extends StatelessWidget {
  final List<CompanyAdEntity> ads;
  final bool isExpired;
  final VoidCallback? onAdTap;
  final Future<void> Function(int adId, int sectionId) onDelete;
  final int? companyUserId;
  final int? companyId;
  final String ownerType;

  const CompanyAdsList({
    required this.ads,
    required this.isExpired,
    this.onAdTap,
    required this.ownerType,
    required this.onDelete,
    this.companyUserId,
    this.companyId,
  });

  bool _isCompanyAd(int index) {
    return ads[index].adOwnerType == 'company';
  }
  bool get _isCompanyList => ownerType == 'company';

  bool _shouldShowExpiredOverlay(int index) {
    return isExpired && _isCompanyList;
  }

 
  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context)!;

    if (ads.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_rounded,
                size: 64,
                color: AppColors.textSecondary.withOpacity(0.4),
              ),
              const SizedBox(height: 16),
              Text(
                t.text('no_ads_for_company') ,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Stack(
          children: [
            AdBannerCarousel(
              ownerType: ownerType,
              itemCount: ads.length,
              titleBuilder: (i) => ads[i].title,
              companyId: companyId ?? 0,
              dateBuilder: (i) => ads[i].adsExpirationDate,
              viewsBuilder: (i) => ads[i].visit,
              sectionId: (i) => ads[i].sectionId,
              imageUrlBuilder: (i) => ads[i].mainImage,
              statusBuilder: (i) => ads[i].status,
              onEdit: (i) {
                // Only restrict company ads when expired
                if (_shouldShowExpiredOverlay(i) && onAdTap != null) {
                  onAdTap!();
                }
              },
              onDelete: (i) => onDelete(ads[i].id, ads[i].sectionId),
              onRepublish: (i) {
                // Only restrict company ads when expired
                if (_shouldShowExpiredOverlay(i) && onAdTap != null) {
                  onAdTap!();
                }
              },
              showHighlight: true,
              showPin: (i) => ads[i].adOwnerType == 'personal',
              typeBuilder: (i) => ads[i].sectionName,
              adTypeBuilder: (i) => ads[i].adType,
              sectionTypeBuilder: (i) => ads[i].sectionType,
              adIdBuilder: (i) => ads[i].id.toString(),
            ),
            // Only show expired overlay on company ads
            if (isExpired && ads.any((ad) => ad.adOwnerType == 'company'))
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Find the current visible ad index
                    // Note: This is a simplified approach. In a real carousel,
                    // you'd track the current page index
                    return StreamBuilder<int>(
                      stream: null, // Would need carousel controller stream
                      builder: (context, snapshot) {
                        // For now, check if ANY company ad exists
                        final hasCompanyAd =
                            ads.any((ad) => ad.adOwnerType == 'company');
                        if (!hasCompanyAd) return const SizedBox.shrink();

                        return GestureDetector(
                          onTap: onAdTap,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFFD32F2F)
                                          .withValues(alpha: 0.95),
                                      const Color(0xFFC62828)
                                          .withValues(alpha: 0.95),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFD32F2F)
                                          .withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.lock_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppTranslations.of(context)?.text(
                                              'subscription_expired_company_only') ??
                                          'الإعلانات الخاصة بالشركة معلقة',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      
      ],
    );
  }
}

