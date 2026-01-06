// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:intl/intl.dart'; // Required for DateFormat
// import 'package:oreed_clean/core/app_shared_prefs.dart';
// import 'package:oreed_clean/core/translation/appTranslations.dart';
// import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
// import 'package:oreed_clean/core/utils/shared_widgets/ad_type_badge.dart';
// import 'package:provider/provider.dart';
// class RelatedAdGridCard extends StatelessWidget {
//   final RelatedAdEntity item;
//   final VoidCallback? onTap;
//   final bool isDisabled;
//   final bool visable;
//   final int sectionId; // added

//   const RelatedAdGridCard({
//     super.key,
//     required this.item,
//     required this.sectionId, // added
//     this.onTap,
//     this.visable = true,
//     this.isDisabled = false,
//   });

//   // --- YOUR ORIGINAL DATE LOGIC ---
//   String _formatDate(String? dateString) {
//     if (dateString == null || dateString.isEmpty) return '';
//     try {
//       final date = DateTime.parse(dateString);
//       return DateFormat('yyyy-MM-dd').format(date);
//     } catch (e) {
//       return dateString ?? '';
//     }
//   }

//   String _stripTrailingCents(String? price) {
//     if (price == null) return '';
//     final p = price.trim();
//     if (p.isEmpty) return '';
//     return p.endsWith('.00') ? p.substring(0, p.length - 3) : p;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = AppTranslations.of(context);
//     final String? image = item.mainImage;
//     final String price = _stripTrailingCents(item.price);
//     final isRTL = Directionality.of(context) == ui.TextDirection.rtl;

//     final String formattedDate = _formatDate(item.createdAt);

//     final mainBlueColor = AppColors.primary;

//     return Container(
//       padding: const EdgeInsets.all(5),
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
//         onTap: onTap,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Stack(
//               children: [
//                 AspectRatio(
//                   aspectRatio: 4 / 3,
//                   child: (image != null && image.isNotEmpty)
//                       ? ClipRRect(
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(18),
//                             topRight: Radius.circular(18),
//                           ),
//                           child: Image.network(
//                             image,
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                           ),
//                         )
//                       : Container(
//                           color: const Color(0xFFE8E8E9),
//                           child: const Icon(Icons.image_outlined,
//                               size: 40, color: Colors.grey),
//                         ),
//                 ),
//                 PositionedDirectional(
//                   top: 8,
//                    start: 5,
                  
//                   child: AdTypeBadge(
//                     type: adTypeFromString(item.adType),
//                     dense: true,
//                   ),
//                 ),
//                 PositionedDirectional(
//                   top: 5,
//                   end: 5,
//                   child: Consumer<FavoritesProvider>(
//                     builder: (context, favs, _) {
//                       final int adId = item.id; // fix: item.id is already int
//                       final bool pending = favs.isPending(adId);
//                       final bool fav = favs.isFavorite(adId);
//                       return _FavoriteCircleButton(
//                         onPressed: pending
//                             ? null
//                             : () async {
//                                 final prefs = AppSharedPreferences();
//                                 final userId = prefs.getUserId ?? 0;
//                                 await favs.toggle(
//                                   sectionId: sectionId, // use card's sectionId
//                                   adId: adId,
//                                   userId: userId,
//                                   context: context,
//                                 );
//                               },
//                         isFavorite: fav,
//                         isPending: pending,
//                         isDisabled: isDisabled,
//                       );
//                     },
//                   ),
//                 ),

//                 // --- DATE & VIEWS OVERLAY ---
//                 PositionedDirectional(
//                   bottom: 0,
//                   start: 0,
//                   child: Container(
//                     padding: const EdgeInsets.fromLTRB(12, 6, 8, 6),
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                       image: AssetImage(
//                         isRTL
//                             ? 'assets/images/time_frame.png'
//                             : 'assets/images/time_frameenglish.png',
//                       ),
//                       fit: BoxFit.fill,
//                     )),
//                     child: Visibility(
//                       visible: visable,
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           SvgPicture.asset(
//                             'assets/svg/loading_time.svg',
//                             height: 10,
//                             width: 10,
//                           ),
//                           const SizedBox(width: 3),
//                           Text(
//                             formattedDate,
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(width: 6),
//                           // Add more space between the date and the eye
//                           SvgPicture.asset(
//                             'assets/svg/eye.svg',
//                             height: 10,
//                             width: 10,
//                           ),
//                           const SizedBox(width: 3),
//                           Text(
//                             "${item.visit}",
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(width: 6),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       item.title,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         color: Colors.black87,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                         height: 1.3,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Row(
//                       children: [
//                         SvgPicture.asset('assets/svg/locationcontiry.svg'),
//                         const SizedBox(width: 4),
//                         Expanded(
//                           child: Text(
//                             '${item.city}، ${item.state}',
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontSize: 11,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 6,
//                     ),
//                     if (price.isNotEmpty)
//                       Text(
//                         '$price ${t?.text('currency_kwd') ?? 'د.ك'}',
//                         style:  TextStyle(
//                           color: mainBlueColor,
//                           fontWeight: FontWeight.w800,
//                           overflow: TextOverflow.ellipsis,
//                           fontSize: 16,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               height: 30,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: AppColors.primary,
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 t?.text('action.view_ad') ?? "عرض الاعلان",
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _FavoriteCircleButton extends StatelessWidget {
//   final VoidCallback? onPressed;
//   final bool isFavorite;
//   final bool isPending;
//   final bool isDisabled;

//   const _FavoriteCircleButton({
//     this.onPressed,
//     required this.isFavorite,
//     required this.isPending,
//     this.isDisabled = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final opacity = isDisabled ? 0.4 : 1.0;
//     return Opacity(
//       opacity: opacity,
//       child: InkWell(
//         onTap: onPressed,
//         child: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: const BoxDecoration(
//             shape: BoxShape.circle,
//             color: Color(0xffE8E8E9),
//           ),
//           child: isPending
//               ? const SizedBox(
//                   width: 18,
//                   height: 18,
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 )
//               : SvgPicture.asset(
//                   isFavorite
//                       ? 'assets/svg/heartfull.svg'
//                       : 'assets/svg/heartspace.svg',
//                   color: const Color(0xFF1649D3),
//                   width: 16,
//                   height: 16,
//                 ),
//         ),
//       ),
//     );
//   }
// }
