import 'package:flutter/material.dart';
import 'package:oreed_clean/features/addetails/presentation/pages/ad_detailes_screen.dart';
import 'package:oreed_clean/features/companydetails/presentation/widgets/related_ad_grid_card.dart';
import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';

/// ✅ Grid Layout using RelatedAdGridCard
class GridAdsView extends StatelessWidget {
  final List<RelatedAdEntity> items;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final int sectionId;
  final int userId;

  const GridAdsView({
    super.key,
    required this.items,
    required this.controller,
    required this.physics,
    required this.shrinkWrap,
    required this.sectionId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const crossAxisCount = 2;
        const spacing = 8.0;
        const horizontalPadding = 40.0; // 12 padding left + 12 padding right

        // حساب عرض البطاقة الواحدة
        final availableWidth = constraints.maxWidth - horizontalPadding;
        final cardWidth =
            (availableWidth - spacing * (crossAxisCount - 1)) / crossAxisCount;

        // حساب ارتفاع الصورة بناءً على نسبة 4:3
        final imageH = cardWidth * 0.79;

        const contentH = 132.0;

        final mainExtent = imageH + contentH;

        return GridView.builder(
          controller: controller,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: const EdgeInsets.fromLTRB(4, 10, 4, 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            mainAxisExtent: mainExtent, // الارتفاع المحسوب الجديد
          ),
          itemCount: items.length,
          itemBuilder: (ctx, i) {
            final ad = items[i];

            return RelatedAdGridCard(
              item: ad,
              sectionId: sectionId,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        DetailsAdsScreen(sectionId: sectionId, adId: ad.id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
