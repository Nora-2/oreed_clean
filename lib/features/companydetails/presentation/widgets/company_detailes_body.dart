import 'package:flutter/material.dart';
import 'package:oreed_clean/features/companydetails/domain/entities/company_entity.dart';
import 'package:oreed_clean/features/companydetails/presentation/widgets/companycard.dart';
import 'package:oreed_clean/features/companydetails/presentation/widgets/related_ads_view.dart';
import 'package:oreed_clean/features/companydetails/presentation/widgets/socila_media_pill.dart';
import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';

class CompanyDetailsBody extends StatelessWidget {
  final CompanyDetailsEntity company;
  final List<RelatedAdEntity> ads;
  final int sectionId;
  final int userId;
  final Function(String) onCall;
  final Function(String) onWhatsApp;
  final Function(String) onOpenUrl;

  const CompanyDetailsBody({
    super.key,
    required this.company,
    required this.ads,
    required this.sectionId,
    required this.userId,
    required this.onCall,
    required this.onWhatsApp,
    required this.onOpenUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: BackButton(color: Color(0xffe8e8e9)),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CompanyCard(
                company: company,
                adsCount: ads.length,
                onCall: onCall,
                onWhatsApp: onWhatsApp,
              ),
            ),
            SocialMediaPill(company: company, onOpenUrl: onOpenUrl),
            Padding(
              padding: const EdgeInsets.all(10),
              child: RelatedAdsView(
                ads: ads,
                embedded: true,
                sectionId: sectionId,
                userId: userId,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
