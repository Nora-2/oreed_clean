// // lib/view/screens/details_ads/widgets/related_ads_section.dart
// import 'package:flutter/material.dart';
// import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
// /// Model representing a related advertisement
// class RelatedAd {
//   final String image;
//   final String id;
//   final String title;
//   final String location;
//   final String dateText;
//   final String viewsText;
//   final String priceText;
//   final String adType;

//   const RelatedAd({
//     required this.image,
//     required this.id,
//     required this.title,
//     required this.location,
//     required this.dateText,
//     required this.viewsText,
//     required this.priceText,
//     required this.adType,
//   });
// }

// /// Section widget displaying a horizontal list of related advertisements
// class RelatedAdsSection extends StatelessWidget {
//   final List<RelatedAd> items;
//   final String? title;
//   final int sectionId;

//   const RelatedAdsSection({
//     super.key,
//     required this.items,
//     this.title,
//     required this.sectionId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (items.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     return Container(
//       // Add margin so shadow is visible at edges
//       decoration: BoxDecoration(
//         // color: AppColors.pageBg, // ensure background color retained
//         borderRadius: BorderRadius.circular(12),
//       ),
        
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // _buildSectionHeader(context, sectionId),
//           const SizedBox(height: 16),
//           _buildAdsList(),
//         ],
//       ),
//     );
//   }

 

//   /// Build horizontal scrollable ads list
//   Widget _buildAdsList() {
//     return SizedBox(
//       height: 255,
//       child: ListView.separated(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         scrollDirection: Axis.horizontal,
//         physics: const BouncingScrollPhysics(),
//         itemCount: items.length <= 6 ? items.length : 6,
//         separatorBuilder: (_, __) => const SizedBox(width: 6),
//         itemBuilder: (context, index) => RelatedCard(
//           ad: items[index],
//           sectionId: sectionId,
//         ),
//       ),
//     );
//   }
// }
