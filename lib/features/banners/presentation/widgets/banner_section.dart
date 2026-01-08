// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
// import 'package:oreed_clean/core/utils/shared_widgets/shimmer.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../domain/entities/banner_entity.dart';
// import '../providers/banner_provider.dart';

// class BannerSection extends StatefulWidget {
//   final int? sectionId;

//   const BannerSection({super.key, required this.sectionId});

//   @override
//   State<BannerSection> createState() => _BannerSectionState();
// }

// class _BannerSectionState extends State<BannerSection> {
//   int _current = 0;
//   final CarouselSliderController _controller = CarouselSliderController();

//   @override
//   void initState() {
//     super.initState();
//     // ✅ Check cache first, fetch only if needed
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final provider = context.read<BannerProvider>();
//       final cachedBanners = provider.getCachedBanners(widget.sectionId);

//       if (cachedBanners.isEmpty) {
//         provider.fetchBanners(widget.sectionId);
//       } else {
//         // Use cached data immediately
//         provider.banners = cachedBanners;
//         provider.status = BannerStatus.success;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<BannerProvider>(
//       builder: (context, provider, _) {
//         // ✅ Get section-specific banners from cache
//         final sectionBanners = provider.getCachedBanners(widget.sectionId);

//         switch (provider.status) {
//           case BannerStatus.idle:
//             return const SizedBox.shrink();
//           case BannerStatus.loading:
//             return const _BannerSkeleton(height: 140);
//           case BannerStatus.error:
//             return Center(
//               child: Text(provider.errorMessage ?? 'خطأ في تحميل البنرات'),
//             );
//           case BannerStatus.success:
//             // ✅ Use section-specific banners if available, otherwise use provider banners
//             final banners =
//                 sectionBanners.isNotEmpty ? sectionBanners : provider.banners;
//             if (banners.isEmpty) return const SizedBox.shrink();
//             final hasMultiple = banners.length > 1;

//             return Column(
//               children: [
//                 CarouselSlider.builder(
//                   itemCount: banners.length,
//                   carouselController: _controller,
//                   itemBuilder: (context, index, realIndex) {
//                     final banner = banners[index];
//                     final bool isSelected = _current == index;

//                     return AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeInOut,
//                       // Current item is 180 height, others are 150
//                       margin: EdgeInsets.symmetric(
//                         vertical: isSelected ? 0 : 5,
//                         horizontal: 5,
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(22),
//                         // Orange border for the active item
//                         border: Border.all(
//                           color:
//                               isSelected ? Colors.orange : Colors.transparent,
//                           width: 1.5,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withValues(alpha: 0.1),
//                             blurRadius: 10,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: _BannerItem(
//                         banner: banner,
//                         onTap: () => _onBannerTap(context, banner),
//                       ),
//                     );
//                   },
//                   options: CarouselOptions(
//                     height: 160,
//                     // Total height to accommodate the scaling
//                     viewportFraction: 1,
//                     // Shows parts of neighboring images
//                     enlargeCenterPage: true,
//                     // This creates the "bigger" effect
//                     enlargeStrategy: CenterPageEnlargeStrategy.height,

//                     autoPlay: hasMultiple,
//                     autoPlayInterval: const Duration(seconds: 4),
//                     onPageChanged: (i, _) => setState(() => _current = i),
//                   ),
//                 ),
//                 if (hasMultiple) const SizedBox(height: 10),
//                 if (hasMultiple)
//                   _DotsIndicator(
//                     count: banners.length,
//                     currentIndex: _current,
//                     onDotTap: (i) => _controller.animateToPage(i),
//                   ),
//               ],
//             );
//         }
//       },
//     );
//   }

//   Future<void> _onBannerTap(BuildContext context, BannerEntity banner) async {
//     final type = banner.type; // non-nullable
//     try {
//       switch (type) {
//         case 'link':
//           final raw = banner.valueSectionId;
//           if (raw == null) return;
//           final uri = Uri.tryParse(raw);
//           if (uri != null && await canLaunchUrl(uri)) {
//             await launchUrl(uri, mode: LaunchMode.externalApplication);
//           } else {
//             debugPrint('Cannot launch link: $raw');
//           }
//           break;
//         case 'phone':
//           final phone = banner.valueSectionId?.trim();
//           if (phone == null || phone.isEmpty) {
//             debugPrint('Banner phone is empty');
//             return;
//           }
//           _showPhoneActionsBottomSheet(context, phone);
//           break;
//         case 'ads_id':
//           final adIdRaw = banner.valueAdId;
//           final sectionId = banner.sectionId;
//           final adId = int.tryParse(adIdRaw ?? '');
//           if (adId == null || sectionId == null) {
//             debugPrint('Invalid ad id or section id');
//             return;
//           }
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (_) => DetailsScreen(sectionId: sectionId, adId: adId),
//             ),
//           );
//           break;
//         case 'company_id':
//           final companyId = int.tryParse(banner.companyId);
//           final sectionId = int.tryParse(banner.valueSectionId ?? '');
//           if (companyId == null || sectionId == null) {
//             debugPrint('Invalid company id or section id');
//             return;
//           }
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (_) => CompanyDetailsScreen(
//                 sectionId: sectionId,
//                 companyId: companyId,
//               ),
//             ),
//           );
//           break;
//         default:
//           debugPrint('Unhandled banner type: $type');
//       }
//     } catch (e) {
//       debugPrint('Banner tap error: $e');
//     }
//   }

//   void _showPhoneActionsBottomSheet(BuildContext context, String phone) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       backgroundColor: Colors.white,
//       builder: (_) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.20,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             border:
//                 Border(top: BorderSide(color: AppColors.seccolor, width: 5)),
//             borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Center(
//                   child: Container(
//                     width: 100,
//                     height: 5,
//                     margin: const EdgeInsets.only(top: 12, bottom: 15),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 const Text(
//                   'تواصل مع الشركة',
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w800,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 4),

//                 // --- Subtitle ---
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 40),
//                   child: Text(
//                     'اختار طريقة التواصل المناسبة ليك',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: Colors.grey.shade500,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: GestureDetector(
//                           onTap: () => _callNumber(phone),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 8, horizontal: 18),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(25),
//                               color: AppColors.primary,
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SvgPicture.asset(
//                                   'assets/svg/phone.svg',
//                                   color: Colors.white,
//                                 ),
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 const Text(
//                                   'اتصال',
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ],
//                             ),
//                           )),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: GestureDetector(
//                           onTap: () => _openWhatsApp(phone),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 8, horizontal: 18),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(25),
//                               color: const Color(0xff3AA517),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SvgPicture.asset(
//                                   'assets/svg/whatsapp.svg',
//                                 ),
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 const Text(
//                                   'واتساب',
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ],
//                             ),
//                           )),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _callNumber(String phone) async {
//     final uri = Uri(scheme: 'tel', path: phone);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       debugPrint('Cannot call $phone');
//     }
//   }

//   Future<void> _openWhatsApp(String phone) async {
//     // Remove non-digits & ensure international format is handled externally if needed
//     final clean = phone.replaceAll(RegExp(r'[^0-9+]'), '');
//     final uri = Uri.parse('https://wa.me/$clean');
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       debugPrint('Cannot open WhatsApp for $clean');
//     }
//   }
// }

// // --- Sub Widgets ---
// class _BannerItem extends StatelessWidget {
//   final BannerEntity banner;
//   final VoidCallback onTap;

//   const _BannerItem({required this.banner, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     // Note: The border is handled by the parent AnimatedContainer.
//     // We just clip the image here to match the radius.
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(19), // Slightly less than parent (22)
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(19),
//         child: CachedNetworkImage(
//           imageUrl: banner.image,
//           fit: BoxFit.cover,
//           // Or BoxFit.contain depending on your exact image needs
//           width: double.infinity,
//           height: double.infinity,
//           placeholder: (context, url) => ShimmerBox(
//             width: double.infinity,
//             height: double.infinity,
//             borderRadius: BorderRadius.circular(19),
//           ),
//           errorWidget: (context, url, error) => const Icon(
//             Icons.broken_image,
//             size: 50,
//             color: Colors.grey,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _DotsIndicator extends StatelessWidget {
//   final int count;
//   final int currentIndex;
//   final ValueChanged<int> onDotTap;

//   const _DotsIndicator(
//       {required this.count,
//       required this.currentIndex,
//       required this.onDotTap});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(count, (i) {
//         final active = i == currentIndex;
//         return GestureDetector(
//           onTap: () => onDotTap(i),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 250),
//             margin: const EdgeInsets.symmetric(horizontal: 2),
//             height: 5,
//             width: 12,
//             decoration: BoxDecoration(
//               color: active ? AppColors.primary: AppColors.secondary,
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }

// class _BannerSkeleton extends StatelessWidget {
//   final double height;

//   const _BannerSkeleton({required this.height});

//   @override
//   Widget build(BuildContext context) {
//     return ShimmerBox(
//       height: height,
//       width: double.infinity,
//       borderRadius: BorderRadius.circular(22),
//     );
//   }
// }
