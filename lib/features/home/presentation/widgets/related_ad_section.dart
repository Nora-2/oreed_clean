
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/shared_widgets/related_ad_card.dart';
import 'package:oreed_clean/features/home/data/models/releted_ad_model.dart';
import 'package:oreed_clean/features/home/presentation/widgets/seaction_header.dart';


/// Section widget displaying a horizontal list of related advertisements
class RelatedAdsSection extends StatelessWidget {
  final List<RelatedAd> items;
  final String? title;
  final int sectionId;

  const RelatedAdsSection({
    super.key,
    required this.items,
    this.title,
    required this.sectionId,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      // Add margin so shadow is visible at edges
      decoration: BoxDecoration(
        // color: AppColors.pageBg, // ensure background color retained
        borderRadius: BorderRadius.circular(12),
      ),
        
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
         SectionHeader(onViewAll: () {
           
         },title: title!,isTablet: false,),
          const SizedBox(height: 16),
          _buildAdsList(),
        ],
      ),
    );
  }

 

  /// Build horizontal scrollable ads list
  Widget _buildAdsList() {
    return SizedBox(
      height: 255,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length <= 6 ? items.length : 6,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) => RelatedCard(
          ad: items[index],
          sectionId: sectionId,
        ),
      ),
    );
  }
}
