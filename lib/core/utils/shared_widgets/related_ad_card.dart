// // lib/view/screens/details_ads/widgets/related_card.dart
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:oreed_clean/core/translation/appTranslations.dart';
// import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
// import 'package:oreed_clean/core/utils/shared_widgets/ad_type_badge.dart';
// import 'package:oreed_clean/core/utils/shared_widgets/shimmer.dart';

// class RelatedCard extends StatelessWidget {
//   final _RelatedAdView ad;
//   final int sectionId;

//   RelatedCard({super.key, required RelatedAd ad, required this.sectionId})
//       : ad = _RelatedAdView.from(ad);

//   @override
//   Widget build(BuildContext context) {
  
//     final mainBlueColor =AppColors.primary;
//     final t = AppTranslations.of(context);
//     final showPrice = _shouldShowPrice(ad.priceText);

//     return Container(
//       width: 184,
//       height: 255,
//       padding: const EdgeInsets.all(5),
//       // Keeping specific width from original RelatedCard to fit list
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: Colors.grey.withOpacity(.4),
//         ),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x0D000000),
//             blurRadius: 10,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: InkWell(
//         onTap: () => _navigateToDetails(context),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // --- Image & Overlays Section ---
//             Stack(
//               children: [
//                 AspectRatio(
//                   aspectRatio: 4 / 3,
//                   child: _buildAdImage(),
//                 ),
//                 PositionedDirectional(
//                   top: 3,
//                   start: 5,
//                   child: AdTypeBadge(
//                     type: adTypeFromString(ad.adType),
//                     dense: true,
//                   ),
//                 ),

//                 // Favorite Button (now wired to provider)
//                 PositionedDirectional(
//                   top: 3,
//                   end: 5,
//                   child: _FavoriteCircleButton(
//                     adId: int.tryParse(ad.id) ?? 0,
//                     sectionId: sectionId,
//                   ),
//                 ),

//                 // --- DATE & VIEWS OVERLAY (Curved White Container) ---
//                 PositionedDirectional(
//                   bottom: 0,
//                   start: 0,
//                   child: Container(
//                     padding: const EdgeInsets.fromLTRB(12, 4, 8, 6),
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage(
//                           Directionality.of(context) == TextDirection.rtl
//                               ? 'assets/images/time_frame.png'
//                               : 'assets/images/time_frameenglish.png',
//                         ),
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // Date
//                         SvgPicture.asset(
//                           'assets/svg/loading_time.svg',
//                           height: 10,
//                           width: 10,
//                           // Fallback icon if SVG fails or for safety
//                           placeholderBuilder: (_) => const Icon(
//                               Icons.access_time,
//                               size: 10,
//                               color: Colors.grey),
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           _dateOnly(ad.dateText),
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),

//                         const SizedBox(width: 8),

//                         // Views
//                         SvgPicture.asset(
//                           'assets/svg/eye.svg',
//                           height: 10,
//                           width: 10,
//                           placeholderBuilder: (_) => const Icon(
//                               Icons.visibility,
//                               size: 10,
//                               color: Colors.grey),
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           ad.viewsText,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(width: 6),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             // --- Content Section ---
//             Expanded(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Title
//                     Flexible(
//                       child: Text(
//                         ad.title,
//                         maxLines: 2,
//                         // overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           color: Colors.black87,
//                           fontWeight: FontWeight.w900,
//                           fontSize: 15,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),

//                     // Location
//                     Row(
//                       children: [
//                         SvgPicture.asset(
//                           'assets/svg/locationcontiry.svg',
//                           height: 12,
//                           placeholderBuilder: (_) =>  Icon(
//                               Icons.location_on,
//                               size: 14,
//                               color: AppColors.primary),
//                         ),
//                         const SizedBox(width: 4),
//                         Expanded(
//                           child: Text(
//                             ad.location,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontSize: 10,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 4),

//                     // Price
//                     if (showPrice)
//                       _PriceDisplay(
//                           priceText: ad.priceText,
//                           mainColor: mainBlueColor,
//                           currencyLabel: t?.text('currency_kwd') ?? 'د.ك'),
//                   ],
//                 ),
//               ),
//             ),

//             // --- Bottom Button ---
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//               child: Container(
//                 height: 30,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: mainBlueColor,
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   t?.text('action.view_ad') ?? "عرض الاعلان",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Navigate to ad details screen
//   // void _navigateToDetails(BuildContext context) {
//   //   Navigator.of(context).push(
//   //     MaterialPageRoute(
//   //       builder: (_) => DetailsScreen(
//   //         sectionId: sectionId,
//   //         adId: int.parse(ad.id),
//   //       ),
//   //     ),
//   //   );
//   // }

//   /// Build advertisement image with Shimmer support
//   Widget _buildAdImage() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(16),
//       child: CachedNetworkImage(
//         imageUrl: ad.image,
//         fit: BoxFit.cover,
//         width: double.infinity,
//         placeholder: (context, url) => ShimmerBox(
//           height: double.infinity,
//           width: double.infinity,
//           borderRadius: BorderRadius.circular(18),
//         ),
//         errorWidget: (context, url, error) => Container(
//           color: const Color(0xFFE8E8E9),
//           alignment: Alignment.center,
//           child: const Icon(
//             Icons.image_outlined,
//             size: 40,
//             color: Colors.grey,
//           ),
//         ),
//       ),
//     );
//   }

//   /// Check if price should be displayed (not zero or empty)
//   bool _shouldShowPrice(String priceText) {
//     if (priceText.isEmpty) return false;
//     final parts = priceText.trim().split(' ');
//     final numberPart = parts.isNotEmpty ? parts.first : priceText;
//     final number = double.tryParse(numberPart);
//     if (number == null) return true;
//     return number != 0;
//   }

//   /// Extract date only from datetime string
//   static String _dateOnly(String raw) {
//     if (raw.isEmpty) return raw;
//     final isoCandidate = raw.replaceFirst(' ', 'T');
//     final dt = DateTime.tryParse(isoCandidate);
//     if (dt != null) return _formatDate(dt);
//     final n = int.tryParse(raw);
//     if (n != null) {
//       final isSeconds = n < 100000000000;
//       final dt2 = DateTime.fromMillisecondsSinceEpoch(isSeconds ? n * 1000 : n);
//       return _formatDate(dt2);
//     }
//     final tIndex = raw.indexOf('T');
//     if (tIndex > 0) return raw.substring(0, tIndex);
//     final spaceIndex = raw.indexOf(' ');
//     if (spaceIndex > 0) return raw.substring(0, spaceIndex);
//     return raw;
//   }

//   static String _formatDate(DateTime dt) {
//     final mm = dt.month.toString().padLeft(2, '0');
//     final dd = dt.day.toString().padLeft(2, '0');
//     return '${dt.year}-$mm-$dd';
//   }
// }

// // ==================== Helper Widgets ====================

// class _FavoriteCircleButton extends StatelessWidget {
//   final int adId;
//   final int sectionId;

//   const _FavoriteCircleButton({
//     required this.adId,
//     required this.sectionId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<FavoritesProvider>(
//       builder: (context, favs, _) {
//         final isPending = favs.isPending(adId);
//         final isFav = favs.isFavorite(adId);
//         return GestureDetector(
//           onTap: isPending
//               ? null
//               : () async {
//                   final prefs = AppSharedPreferences();
//                   final userId = prefs.getUserId ?? 0;
//                   await favs.toggle(
//                     sectionId: sectionId,
//                     adId: adId,
//                     userId: userId,
//                     context: context,
//                   );
//                 },
//           child: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: Color(0xffE8E8E9),
//             ),
//             child: isPending
//                 ? const SizedBox(
//                     width: 16,
//                     height: 16,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   )
//                 : Icon(
//                     isFav ? Icons.favorite : Icons.favorite_border,
//                     color: const Color(0xFF1649D3),
//                     size: 16,
//                   ),
//           ),
//         );
//       },
//     );
//   }
// }

// class _PriceDisplay extends StatelessWidget {
//   final String priceText;
//   final Color mainColor;
//   final String currencyLabel;

//   const _PriceDisplay(
//       {required this.priceText,
//       required this.mainColor,
//       required this.currencyLabel});

//   @override
//   Widget build(BuildContext context) {
//     final parts = _splitPrice(priceText);

//     final displayCurrency =
//         parts.currency.isNotEmpty ? parts.currency : currencyLabel;

//     return Text(
//       '${parts.number} $currencyLabel',
//       style: TextStyle(
//         color: mainColor,
//         fontWeight: FontWeight.w600,
//         fontSize: 17,
//       ),
//     );
//   }

//   ({String number, String currency}) _splitPrice(String text) {
//     final parts = text.trim().split(' ');
//     var number = parts.isNotEmpty ? parts.first : text;
//     final currency =
//         parts.length > 1 ? text.substring(number.length).trim() : '';
//     if (number.endsWith('.00')) {
//       number = number.substring(0, number.length - 3);
//     }
//     return (number: number, currency: currency);
//   }
// }

// // ==================== View Model ====================

// class _RelatedAdView {
//   final String image;
//   final String id;
//   final String title;
//   final String location;
//   final String dateText;
//   final String viewsText;
//   final String priceText;
//   final String adType;

//   const _RelatedAdView({
//     required this.image,
//     required this.id,
//     required this.title,
//     required this.location,
//     required this.dateText,
//     required this.viewsText,
//     required this.priceText,
//     required this.adType,
//   });

//   factory _RelatedAdView.from(RelatedAd raw) {
//     return _RelatedAdView(
//       image: raw.image,
//       id: raw.id,
//       title: raw.title,
//       location: raw.location,
//       dateText: raw.dateText,
//       viewsText: raw.viewsText,
//       priceText: raw.priceText,
//       adType: raw.adType,
//     );
//   }
// }
