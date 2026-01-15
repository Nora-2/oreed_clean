// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:oreed/core/theme/color_manager.dart';
// import 'package:oreed/features/auth/domain/widgets/custom_button.dart';
// import 'package:oreed/networking/api_provider.dart';
// import 'package:oreed/translation/appTranslations.dart';
// import 'package:oreed/utils/app_shared_prefs.dart';
// import 'package:oreed_clean/core/app_shared_prefs.dart';
// import 'package:oreed_clean/core/enmus/enum.dart';
// import 'package:oreed_clean/core/routing/routes.dart';
// import 'package:oreed_clean/core/translation/appTranslations.dart';
// import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
// import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
// import 'package:oreed_clean/core/utils/shared_widgets/ad_type_badge.dart';
// import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
// import 'package:oreed_clean/features/chooseplane/presentation/pages/chooseplan_screen.dart';
// import 'package:oreed_clean/features/verification/presentation/pages/payment_webview.dart' hide PaymentResult;
// import 'package:oreed_clean/networking/api_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../../../core/enums/section_type_enum.dart';
// import '../../../../core/widgets/ad_type_badge.dart';
// import '../../../../features/ad_details/presentation/screens/ad_details_screen.dart';
// import '../../../../features/car_ads/presentation/screen/car_form.dart';
// import '../../../../features/company_profile/presentation/providers/company_profile_provider.dart';
// import '../../../../features/create_anything/presentation/screen/any_thing_form.dart';
// import '../../../../features/packages/presentation/screens/choose_plan_screen.dart';
// import '../../../../features/property_ads/presentation/screen/real_estate_form_ui.dart';
// import '../../../../features/technician_ads/presentation/screen/technician_form_ui.dart';
// import '../../../../features/technician_ads/presentation/screen/technician_payment_webview.dart';

// class AdBannerCarousel extends StatefulWidget {
//   final int itemCount;
//   final String Function(int index) titleBuilder;
//   final String Function(int index) sectionTypeBuilder;
//   final String Function(int index) adIdBuilder;
//   final String Function(int index) typeBuilder;
//   final String Function(int index) adTypeBuilder;
//   final String Function(int index) dateBuilder;
//   final int Function(int index) viewsBuilder;
//   final int companyId;
//   final String ownerType;
//   final int Function(int index) sectionId;
//   final String? Function(int index)? imageUrlBuilder;
//   final String Function(int index)? statusBuilder;
//   final bool Function(int index)? showPin;
//   final void Function(int index)? onEdit;
//   final void Function(int index)? onDelete;
//   final void Function(int index)? onRepublish;
//   final BoxDecoration? cardDecoration;

//   /// ✅ للتحكم في ظهور "تمييز إعلانك"
//   final bool showHighlight;

//   /// ✅ للتحكم في ظهور "ثبّت إعلانك"

//   const AdBannerCarousel({
//     super.key,
//     required this.ownerType,
//     required this.itemCount,
//     required this.titleBuilder,
//     required this.sectionTypeBuilder,
//     required this.adIdBuilder,
//     required this.adTypeBuilder,
//     required this.companyId,
//     required this.typeBuilder,
//     required this.dateBuilder,
//     required this.viewsBuilder,
//     required this.sectionId,
//     this.imageUrlBuilder,
//     this.statusBuilder,
//     this.onEdit,
//     this.onDelete,
//     this.onRepublish,
//     this.cardDecoration,
//     this.showHighlight = true,
//     this.showPin,
//   });

//   @override
//   State<AdBannerCarousel> createState() => _AdBannerCarouselState();
// }

// class _AdBannerCarouselState extends State<AdBannerCarousel> {
//   @override
//   Widget build(BuildContext context) {
//     if (widget.itemCount == 0) {
//       return const Column(
//         children: [
//           AspectRatio(
//             aspectRatio: 16 / 9,
//             child: _EmptyCard(),
//           ),
//         ],
//       );
//     }

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: widget.itemCount,
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 16.0),
//           child: _AdCardNewLook(
//             ownerType: widget.ownerType,
//             key: ValueKey('ad_card_$index'),
//             title: widget.titleBuilder(index),
//             date: widget.dateBuilder(index),
//             sectionType: widget.sectionTypeBuilder(index),
//             companyId: widget.companyId,
//             views: widget.viewsBuilder(index),
//             sectionId: widget.sectionId(index),
//             status: widget.statusBuilder?.call(index),
//             imageUrl: widget.imageUrlBuilder?.call(index),
//             onEdit: widget.onEdit != null ? () => widget.onEdit!(index) : null,
//             onDelete:
//                 widget.onDelete != null ? () => widget.onDelete!(index) : null,
//             onRepublish: widget.onRepublish != null
//                 ? () => widget.onRepublish!(index)
//                 : null,

//             // ✅ مرّر الفلاجين للكارت
//             showHighlight: widget.showHighlight,
//             showPin: widget.showPin?.call(index) ?? true,
//             type: widget.typeBuilder(index),
//             adType: widget.adTypeBuilder(index),
//             adId: widget.adIdBuilder(index),
//           ),
//         );
//       },
//     );
//   }
// }

// class _AdCardNewLook extends StatefulWidget {
//   final String title;
//   final String type;
//   final String date;
//   final int views;
//   final int sectionId;
//   final int companyId;
//   final String? status;
//   final String? adType;
//   final String? adId;
//   final String? sectionType;
//   final String? imageUrl;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;
//   final VoidCallback? onRepublish;

//   /// ✅ فلاجين التحكم في البادجات
//   final bool showHighlight;
//   final bool showPin;
//   final String ownerType;

//   const _AdCardNewLook({
//     super.key,
//     required this.title,
//     required this.adId,
//     required this.ownerType,
//     required this.sectionType,
//     required this.type,
//     required this.adType,
//     required this.companyId,
//     required this.date,
//     required this.views,
//     required this.sectionId,
//     this.status,
//     this.imageUrl,
//     this.onEdit,
//     this.onDelete,
//     this.onRepublish,
//     this.showHighlight = true,
//     this.showPin = true,
//   });

//   @override
//   State<_AdCardNewLook> createState() => _AdCardNewLookState();
// }

// class _AdCardNewLookState extends State<_AdCardNewLook> {
//   bool _isUpdatingPriority = false;

//   Future<void> _updatePriority(int priority, int companyId) async {
//     if (_isUpdatingPriority) return;

//     setState(() => _isUpdatingPriority = true);

//     try {
//       final companyProvider =
//           Provider.of<CompanyProfileProvider>(context, listen: false);
//       final result = await companyProvider.updateAdPriority(
//         sectionId: widget.sectionId,
//         adId: int.tryParse(widget.adId ?? '0') ?? 0,
//         priority: priority,
//         companyId: companyId,
//       );

//       if (mounted) {
//         if (result['success'] == true) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content:
//                   Text(result['message'] ?? 'Priority updated successfully'),
//               backgroundColor: Colors.green,
//               duration: const Duration(seconds: 2),
//             ),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(result['message'] ?? 'Failed to update priority'),
//               backgroundColor: Colors.red,
//               duration: const Duration(seconds: 2),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error: ${e.toString()}'),
//             backgroundColor: Colors.red,
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isUpdatingPriority = false);
//       }
//     }
//   }

//   void showPriorityWorkflow(BuildContext context, int companyId) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => PriorityBottomSheet(companyId: companyId),
//     );
//   }

//   void _showPriorityMenu() {
//     if (_isUpdatingPriority) return;
//     AppTranslations t = AppTranslations.of(context)!;
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       backgroundColor: Colors.white,
//       builder: (context) => SafeArea(
//         child: Container(
//           padding: EdgeInsets.only(
//             left: 20,
//             right: 20,
//             top: 24,
//             bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Header with drag indicator
//               Column(
//                 children: [
//                   Container(
//                     width: 40,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     t.text('set_ad_priority') ,
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           color: Colors.black87,
//                         ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     t.text('choose_priority_to_increase_visibility') ,
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           color: Colors.grey[600],
//                           fontSize: 13,
//                         ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               // Priority options
//               _buildPriorityOption(
//                 context,
//                 priority: 1,
//                 titleAr: t.text('very_high_priority') ,
//                 subtitleAr: t.text('maximum_visibility') ,
//                 icon: Icons.star,
//                 color: const Color(0xFFFFC837),
//                 badgeColor: const Color(0xFFFFEB3B),
//                 companyId: widget.companyId,
//               ),
//               const SizedBox(height: 12),
//               _buildPriorityOption(
//                 context,
//                 priority: 2,
//                 titleAr: t.text('high_priority') ,
//                 subtitleAr: t.text('featured_visibility') ,
//                 icon: Icons.star_half,
//                 color: const Color(0xFFFF9800),
//                 badgeColor: const Color(0xFFFFC107),
//                 companyId: widget.companyId,
//               ),
//               const SizedBox(height: 12),
//               _buildPriorityOption(
//                 context,
//                 priority: 3,
//                 titleAr: t.text('medium_priority') ,
//                 subtitleAr: t.text('good_visibility') ,
//                 icon: Icons.star_half_outlined,
//                 color: const Color(0xFF2196F3),
//                 badgeColor: const Color(0xFFBBDEFB),
//                 companyId: widget.companyId,
//               ),
//               const SizedBox(height: 12),
//               _buildPriorityOption(
//                 context,
//                 priority: 4,
//                 titleAr: t.text('normal_priority')  ,
//                 subtitleAr: t.text('standard_visibility') ,
//                 icon: Icons.star_outline,
//                 color: Colors.grey[600]!,
//                 badgeColor: Colors.grey[300]!,
//                 companyId: widget.companyId,
//               ),
//               const SizedBox(height: 12),
//               _buildPriorityOption(
//                 context,
//                 priority: 5,
//                 titleAr: t.text('low_priority') ,
//                 subtitleAr: t.text('basic_visibility'),
//                 icon: Icons.stars_outlined,
//                 color: Colors.grey[400]!,
//                 badgeColor: Colors.grey[200]!,
//                 companyId: widget.companyId,
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPriorityOption(
//     BuildContext context, {
//     required int priority,
//     required int companyId,
//     required String titleAr,
//     required String subtitleAr,
//     required IconData icon,
//     required Color color,
//     required Color badgeColor,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: _isUpdatingPriority
//             ? null
//             : () {
//                 Navigator.pop(context);
//                 _updatePriority(priority, companyId);
//               },
//         borderRadius: BorderRadius.circular(14),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: color.withValues(alpha: 0.3),
//               width: 1.5,
//             ),
//             borderRadius: BorderRadius.circular(14),
//             color: badgeColor.withValues(alpha: 0.1),
//           ),
//           child: Row(
//             children: [
//               // Star Icon with background
//               Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: color.withValues(alpha: 0.2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Center(
//                   child: Icon(
//                     icon,
//                     color: color,
//                     size: 24,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 14),
//               // Text content
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       titleAr,
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                             fontSize: 15,
//                           ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       subtitleAr,
//                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Chevron
//               Icon(
//                 Icons.chevron_right,
//                 color: color,
//                 size: 24,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   bool _isExpired(String? dateString) {
//     if (dateString == null || dateString.isEmpty) return false;

//     try {
//       // Try parsing the date (supports both with/without time)
//       final expiry = DateTime.tryParse(dateString);
//       if (expiry == null) return false;

//       final now = DateTime.now();
//       return expiry.isBefore(now);
//     } catch (e) {
//       // If parsing fails, assume not expired to avoid false positives
//       return false;
//     }
//   }

//   String _formatDateOnly(String? dateString) {
//     if (dateString == null || dateString.isEmpty) return '';

//     try {
//       final dateTime = DateTime.tryParse(dateString);
//       if (dateTime == null) return dateString;

//       // Format as YYYY-MM-DD
//       return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
//     } catch (e) {
//       return dateString;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = AppTranslations.of(context)!;
    
//     final s = (widget.status ?? '').trim();
//     final bool isExpired = _isExpired(widget.date);
//     final bool ispending = s.toLowerCase() == 'pending';
//     final isRTL = Directionality.of(context) == TextDirection.rtl;

//     return Container(
//       // height: widget.ownerType == 'personal' ? 250 : 200,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(25),
//           border: Border.all(color: const Color(0xffE8E8E9))),
//       padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 10),
//       child: Column(
//         children: [
//           SizedBox(
//             height: 180,
//             child: InkWell(
//               onTap: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (_) => DetailsScreen(
//                       sectionId: widget.sectionId,
//                       adId: int.tryParse(widget.adId!)!,
//                     ),
//                   ),
//                 );
//               },
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(18),
//                 child: LayoutBuilder(builder: (context, constraints) {
//                   final cardWidth = constraints.maxWidth;
//                   final infoWidth =
//                       cardWidth * 0.60; // area for title / info pills
//                   final typeWidth = cardWidth * 0.60;

//                   return Stack(
//                     children: [
//                       // الخلفية (صورة)
//                       Positioned.fill(child: _buildImageBackground()),

//                       // تدرّج فوق الصورة
//                       Positioned.fill(
//                         child: DecoratedBox(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                               colors: [
//                                 Colors.black.withValues(alpha: 0.05),
//                                 Colors.black.withValues(alpha: 0.55),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       widget.adType != 'free'
//                           ? PositionedDirectional(
//                               top: 10,
//                               start: 8,
//                               // left: isRTL ? 0 : 8,
//                               child: AdTypeBadge(
//                                 type: adTypeFromString(widget.adType),
//                                 dense: true,
//                               ),
//                             )
//                           : Positioned(top: 0, right: 2, child: Container()),
//                       if (widget.status != null &&
//                           widget.status!.trim().isNotEmpty)
//                         ispending
//                             ? PositionedDirectional(
//                                 start: 8,
//                                 // left: isRTL ? 0 : 8,
//                                 top: widget.adType == 'free' ? 8 : 38,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(top: 0.0),
//                                   child: Align(
//                                       alignment: isRTL
//                                           ? Alignment.centerLeft
//                                           : Alignment.centerRight,
//                                       child: _StatusChip(
//                                         status: 'pending',
//                                         date: widget.date,
//                                       )),
//                                 ),
//                               )
//                             : PositionedDirectional(
//                                 start: 8,
//                                 // left: isRTL ? 0 : 8,
//                                 top: widget.adType == 'free' ? 8 : 38,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(top: 0.0),
//                                   child: Align(
//                                       alignment: isRTL
//                                           ? Alignment.centerLeft
//                                           : Alignment.centerRight,
//                                       child: _StatusChip(
//                                         status: isExpired ? 'Expired' : s,
//                                         date: widget.date,
//                                       )),
//                                 ),
//                               ),

//                       PositionedDirectional(
//                         end: 8,
//                         // right: isRTL ? 12 : 0,
//                         top: 12,
//                         child: Row(
//                           children: [
//                             widget.ownerType == 'personal'
//                                 ? Container()
//                                 : GestureDetector(
//                                     onTap: () {
//                                       // showPriorityWorkflow(context, widget.companyId);
//                                       _showPriorityMenu();
//                                     },
//                                     child: _PriorityButton(
//                                       isLoading: _isUpdatingPriority,
//                                       onTap: () {
//                                         _showPriorityMenu();
//                                       },
//                                     ),
//                                   ),
//                             const SizedBox(width: 5),
//                             if (widget.onEdit != null) ...[
//                               GestureDetector(
//                                 child: SvgPicture.asset(AppIcons.edit),
//                                 onTap: () async {
//                                   // push the appropriate form and wait for result.
//                                   Object? result;
//                                   if (widget.sectionType == 'technician') {
//                                     result = await Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => TechnicianFormUI(
//                                           sectionID: widget.sectionId,
//                                           categoryId: 0,
//                                           adId: int.tryParse(widget.adId!),
//                                         ),
//                                       ),
//                                     );
//                                   } else if (widget.sectionType == 'property') {
//                                     result = await Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => RealEstateFormUI(
//                                           sectionId: 0,
//                                           categoryId: 0,
//                                           adId: int.tryParse(widget.adId!),
//                                           supCategoryId: 0,
//                                         ),
//                                       ),
//                                     );
//                                   } else if (widget.sectionType == 'car') {
//                                     result = await Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => CarFormUI(
//                                           sectionId: 0,
//                                           categoryId: 0,
//                                           adId: int.tryParse(widget.adId!),
//                                           supCategoryId: 0,
//                                         ),
//                                       ),
//                                     );
//                                   } else {
//                                     result = await Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => AnythingForm(
//                                           sectionId: widget.sectionId,
//                                           categoryId: 0,
//                                           adId: int.tryParse(widget.adId!),
//                                           supCategoryId: 0,
//                                         ),
//                                       ),
//                                     );
//                                   }

//                                   // If the pushed screen returned `true`, notify parent via onEdit
//                                   if (result == true) {
//                                     try {
//                                       if (widget.onEdit != null) {
//                                         widget.onEdit!();
//                                       }
//                                     } catch (_) {}
//                                   }
//                                 },
//                               ),
//                             ],
//                             const SizedBox(width: 5),
//                             if (widget.onDelete != null)
//                               GestureDetector(
//                                 onTap: widget.onDelete ?? () {},
//                                 child: SvgPicture.asset(
//                                    AppIcons.deleteWithBackGrey),
//                               ),
//                           ],
//                         ),
//                       ),

//                       // العنوان + التاريخ + المشاهدات (يمين أسفل)
//                       Positioned(
//                         right: isRTL ? 14 : 0,
//                         left: isRTL ? 0 : 14,
//                         bottom: 12,
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: isRTL
//                               ? CrossAxisAlignment.start
//                               : CrossAxisAlignment.start,
//                           children: [
//                             ConstrainedBox(
//                               constraints: BoxConstraints(maxWidth: infoWidth),
//                               child: Text(
//                                 widget.title,
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w700,
//                                   height: 1.2,
//                                   fontSize: 14,
//                                   shadows: [
//                                     Shadow(
//                                       offset: Offset(0, 1),
//                                       blurRadius: 2,
//                                       color: Colors.black38,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 2),
//                             Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 _InfoPill(
//                                     icon: AppIcons.loadingTime,
//                                     label: _formatDateOnly(widget.date)),
//                                 const SizedBox(width: 8),
//                                 _InfoPill(
//                                     icon: AppIcons.eyeActive,
//                                     label: '${widget.views}'),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),

//                       // نوع الإعلان (قبل العنوان بقليل، أعلى منه)
//                       Positioned(
//                         right: widget.type == 'Cars'
//                             ? (isRTL ? 14 : 0)
//                             : (isRTL ? 14 : 0),
//                         left: widget.type == 'Cars'
//                             ? (isRTL ? 0 : 14)
//                             : (isRTL ? 0 : 14),
//                         bottom: 66,
//                         child: ConstrainedBox(
//                           constraints: BoxConstraints(maxWidth: typeWidth),
//                           child: Text(
//                             widget.type,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               height: 1.2,
//                               fontSize: 14,
//                               shadows: [
//                                 Shadow(
//                                   offset: Offset(0, 1),
//                                   blurRadius: 2,
//                                   color: Colors.black38,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 }),
//               ),
//             ),
//           ),
//           widget.ownerType == 'personal'
//               ? const SizedBox(height: 12)
//               : Container(),
//           // SizedBox(height: 10,),
//           (widget.ownerType == 'personal' && widget.adType == 'free')
//               ? Row(
//                   children: [
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () async {
//                           // trigger light haptic then open plan chooser
//                           HapticFeedback.lightImpact();
//                           final planResult = await ChoosePlanScreen.show(
//                             context: context,
//                             type: 'featured',
//                             // could be 'pinned', 'subscription', etc.
//                             title: t.text('choose_featured_plan_title') ,
//                             icon: Icons.star_rounded,
//                             introText: t.text('choose_plan_intro') ,
//                             accentColor: const Color(0xFFFFC837),
//                             onTap: () {},
//                           );

//                           // user dismissed the sheet
//                           if (planResult == null) return;

//                           if (planResult.isFree) {
//                             // Free plan → go home immediately
//                             if (!mounted) return;
//                             Navigator.pushNamedAndRemoveUntil(
//                                 context,Routes.homelayout, (_) => false);
//                             return;
//                           }

//                           // Paid plan → open in-app payment webview
//                           final url = Uri.parse(
//                               '${ApiProvider.baseUrl}/payment/request?user_id=${AppSharedPreferences().userId}&packageId=${planResult.id}&ads_id=${widget.adId}&model=${widget.sectionType}');

//                           if (!mounted) return;
//                           final paymentResult =
//                               await Navigator.of(context).push<PaymentResult>(
//                             MaterialPageRoute(
//                               builder: (_) => PaymentWebView(
//                                 url: url.toString(),
//                                 title: AppTranslations.of(context)!
//                                         .text('payment_title') ,
//                               ),
//                             ),
//                           );

//                           if (!mounted) return;
//                           if (paymentResult == PaymentResult.success ||
//                               paymentResult == null) {
//                             // Treat null (user closed after success page) as success fallback
//                             Navigator.pushNamedAndRemoveUntil(
//                                 context, Routes.homelayout, (_) => false);
//                           }
//                         },
//                         child: _BottomActionButton(
//                           text: t.text('highlight_your_ad_btn') ,
//                           color: const Color(0xff8133F1),
//                           icon: AppIcons.starWithBackGrey,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () async {
//                           Provider.of<CompanyProfileProvider>(context,
//                               listen: false);
//                           HapticFeedback.lightImpact();

//                           final result = await ChoosePlanScreen.show(
//                             context: context,
//                             type: 'pinned',
//                             // could be 'pinned', 'subscription', etc.
//                             title: t.text('choose_pinned_plan_title') ,
//                             icon: Icons.star_rounded,
//                             introText: t.text('choose_plan_intro') ,
//                             accentColor: const Color(0xFFFFC837),
//                             onTap: () {},
//                           );

//                           if (result!.isFree) {
//                             // ✅ Free plan → go home immediately
//                             Navigator.pushNamedAndRemoveUntil(
//                                 context,Routes.homelayout, (_) => false);
//                           } else {
//                             // ✅ Paid plan → open payment page
//                             final url = Uri.parse(
//                                 '${ApiProvider.baseUrl}/payment/request?user_id=${AppSharedPreferences().userId}&packageId=${result.id}&ads_id=${widget.adId}&model=${widget.sectionType}');

//                             if (!mounted) return;
//                             final paymentResult =
//                                 await Navigator.of(context).push<PaymentResult>(
//                               MaterialPageRoute(
//                                 builder: (_) => PaymentWebView(
//                                   url: url.toString(),
//                                   title: AppTranslations.of(context)!
//                                           .text('payment_title') ,
//                                 ),
//                               ),
//                             );

//                             if (!mounted) return;
//                             if (paymentResult == PaymentResult.success ||
//                                 paymentResult == null) {
//                               // Treat null (user closed after success page) as success fallback
//                               Navigator.pushNamedAndRemoveUntil(
//                                   context,Routes.homelayout, (_) => false);
//                             }
//                           }
//                         },
//                         child: _BottomActionButton(
//                           text: t.text('pin_your_ad_btn'),
//                           color: const Color(0xffFF8A00),
//                           icon: AppIcons.pinWithBackGrey,
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               : Container()
//         ],
//       ),
//     );
//   }

//   Widget _buildImageBackground() {
//     final placeholder = Container(
//       color: Colors.grey[300],
//       child: const Center(
//         child: Icon(Icons.image_rounded, size: 42, color: Colors.white70),
//       ),
//     );

//     if (widget.imageUrl == null || widget.imageUrl!.isEmpty) return placeholder;

//     final isNetwork = widget.imageUrl!.startsWith('http');
//     return isNetwork
//         ? Image.network(
//             widget.imageUrl!,
//             fit: BoxFit.cover,
//             errorBuilder: (_, __, ___) => placeholder,
//           )
//         : Image.asset(
//             widget.imageUrl!,
//             fit: BoxFit.cover,
//             errorBuilder: (_, __, ___) => placeholder,
//           );
//   }
// }

// class _StatusChip extends StatelessWidget {
//   final String status;
//   final String date;

//   const _StatusChip({required this.status, required this.date});

//   String _formatDateOnly(String? dateString) {
//     if (dateString == null || dateString.isEmpty) return '';

//     try {
//       final dateTime = DateTime.tryParse(dateString);
//       if (dateTime == null) return dateString;

//       // Format as YYYY-MM-DD
//       return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
//     } catch (e) {
//       return dateString;
//     }
//   }

//   @override
//   Widget build(
//     BuildContext context,
//   ) {
//     final t = AppTranslations.of(context);
//     final s = status.trim();
//     final isRTL = Directionality.of(context) == TextDirection.rtl;

//     final bool isActive = s.toLowerCase() != 'pending';
//     final bool isExpired = s.toLowerCase() == 'expired';

//     if (isActive) {
//       return Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SvgPicture.asset(
//             'assets/svg/active.svg',
//             width: 25,
//             height: 25,
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//             decoration: BoxDecoration(
//               color: const Color(0xff3AA517),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: const Color(0xff3AA517), width: 1),
//             ),
//             child: Text(
//               '${t?.text('active_until') ?? 'نشط حتي'} " ${_formatDateOnly(date)}"',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 10,
//               ),
//             ),
//           ),
//         ],
//       );
//     }
//     if (isExpired) {
//       return Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SvgPicture.asset(
//             'assets/svg/exit.svg',
//             width: 25,
//             height: 25,
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//             decoration: BoxDecoration(
//               color: const Color(0xffA72424),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: const Color(0xffA72424), width: 1),
//             ),
//             child: Text(
//               t?.text('expired') ?? 'منتهي الصلاحية',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 10,
//               ),
//             ),
//           ),
//         ],
//       );
//     } else {
//       return Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SvgPicture.asset(
//             'assets/svg/bending.svg',
//             width: 25,
//             height: 25,
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//             decoration: BoxDecoration(
//               color: const Color(0xff1146D1),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: const Color(0xff1146D1), width: 1),
//             ),
//             child: Text(
//               t?.text('pending_approval') ?? 'بانتظار الموافقة',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 10,
//               ),
//             ),
//           ),
//         ],
//       );
//     }
//   }
// }

// /// ⭐ تمييز إعلانك
// class _HighlightChip extends StatelessWidget {
//   final String label;

//   const _HighlightChip({this.label = 'تمييز إعلانك'});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.amber[50],
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.amber.shade200, width: 1),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.star_rounded, size: 14, color: Colors.amber[700]),
//           const SizedBox(width: 6),
//           Text(
//             label,
//             style: TextStyle(
//               color: Colors.amber[800],
//               fontWeight: FontWeight.w700,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// 📌 ثبّت إعلانك
// class _PinChip extends StatelessWidget {
//   final String label;

//   const _PinChip({this.label = 'ثبّت إعلانك'});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.blue[50],
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.blue.shade200, width: 1),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.push_pin_rounded, size: 14, color: Colors.blue[700]),
//           const SizedBox(width: 6),
//           Text(
//             label,
//             style: TextStyle(
//               color: Colors.blue[800],
//               fontWeight: FontWeight.w700,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// كبسولة معلومات صغيرة
// class _InfoPill extends StatelessWidget {
//   final String icon;
//   final String label;

//   const _InfoPill({required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 4),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SvgPicture.asset(
//             icon,
//             color: const Color(0xffE8E8E9),
//             width: 10,
//             height: 10,
//           ),
//           const SizedBox(width: 4),
//           ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 120),
//             child: Text(
//               label,
//               style: const TextStyle(
//                 color: Color(0xffE8E8E9),
//                 fontWeight: FontWeight.w600,
//                 fontSize: 10,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// 🎯 Priority Button Widget
// class _PriorityButton extends StatelessWidget {
//   final bool isLoading;
//   final VoidCallback onTap;

//   const _PriorityButton({
//     required this.isLoading,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: isLoading
//           ? SizedBox(
//               width: 20,
//               height: 20,
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(
//                   Colors.grey.shade700,
//                 ),
//                 strokeWidth: 2.5,
//               ),
//             )
//           : Tooltip(
//               message: 'تعيين أولوية',
//               textStyle: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//               ),
//               child: SvgPicture.asset('assets/svg/evaluation.svg')),
//     );
//   }
// }

// /// كارت فارغ
// class _EmptyCard extends StatelessWidget {
//   const _EmptyCard();

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     final t = AppTranslations.of(context)!;

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 6),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(18),
//         color: cs.surface,
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Center(
//         child: Text(
//           t.text('no_ads') ?? 'لا توجد إعلانات',
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 color: Theme.of(context).hintColor,
//                 fontWeight: FontWeight.w600,
//               ),
//         ),
//       ),
//     );
//   }
// }

// class PriorityBottomSheet extends StatefulWidget {
//   final int companyId;

//   const PriorityBottomSheet({super.key, required this.companyId});

//   @override
//   State<PriorityBottomSheet> createState() => _PriorityBottomSheetState();
// }

// class _PriorityBottomSheetState extends State<PriorityBottomSheet> {
//   int _currentStep = 1; // 1 = Priority Level, 2 = Rank Selection
//   int _selectedPriority = 0; // Index of priority
//   int _selectedRank = 0; // Index of rank

//   List<Map<String, String>> _getPriorities(AppTranslations? t) => [
//         {
//           'title': t?.text('very_high_priority') ?? 'أولوية عالية جداً',
//           'subtitle': t?.text('maximum_visibility') ?? 'أقصى ظهور للاعلان'
//         },
//         {
//           'title': t?.text('high_priority') ?? 'أولوية عالية',
//           'subtitle': t?.text('featured_visibility') ?? 'ظهور متميز'
//         },
//         {
//           'title': t?.text('normal_priority') ?? 'أولوية عادية',
//           'subtitle': t?.text('standard_visibility') ?? 'ظهور قياسي'
//         },
//       ];

//   List<Map<String, String>> _getRanks(AppTranslations? t) => [
//         {
//           'title': t?.text('first_rank') ?? 'الأول',
//           'subtitle': t?.text('first_rank_desc') ?? 'يظهر إعلانك في أعلى الصفحة'
//         },
//         {
//           'title': t?.text('second_rank') ?? 'الثاني',
//           'subtitle': t?.text('second_rank_desc') ?? 'يظهر بعد الإعلان الأول'
//         },
//         {
//           'title': t?.text('third_rank') ?? 'الثالث',
//           'subtitle': t?.text('third_rank_desc') ?? 'يظهر بعد الإعلان الثاني'
//         },
//       ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration:  BoxDecoration(
//         color: Colors.white,
//         border: Border(top: BorderSide(color: AppColors.secondary, width: 5)),
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//       child: Directionality(
//         textDirection: TextDirection.rtl, // Set RTL for Arabic
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Top Indicator
//             Container(
//                 width: 150,
//                 height: 4,
//                 decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(2))),
//             const SizedBox(height: 24),

//             // Header (Changes based on step)
//             _buildHeader(),
//             const SizedBox(height: 24),

//             // Content List
//             _currentStep == 1 ? _buildPriorityList() : _buildRankList(),
//             const SizedBox(height: 24),

//             // Footer Buttons
//             _buildFooter(),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     final t = AppTranslations.of(context);
//     final priorities = _getPriorities(t);
//     String title = _currentStep == 1
//         ? t?.text('choose_ad_visibility_order') ??
//             "اختر ترتيب ظهور هذا الإعلان للزوار"
//         : priorities[_selectedPriority]['title']!;
//     String subtitle = _currentStep == 1
//         ? t?.text('visibility_order_company_page') ??
//             "ترتيب الظهور في صفحة الشركة"
//         : priorities[_selectedPriority]['subtitle']!;

//     return Column(
//       children: [
//         Text(title,
//             style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black)),
//         const SizedBox(height: 4),
//         Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
//       ],
//     );
//   }

//   // Right Screenshot UI
//   Widget _buildPriorityList() {
//     final t = AppTranslations.of(context);
//     final priorities = _getPriorities(t);
//     return Column(
//       children: List.generate(priorities.length, (index) {
//         bool isSelected = _selectedPriority == index;
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: InkWell(
//             onTap: () => setState(() {
//               _selectedPriority = index;
//               _currentStep = 2; // Transition to Step 2
//             }),
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                     color: isSelected
//                         ? const Color(0xFF1E4AD3)
//                         : Colors.grey[100]!),
//                 color: isSelected ? const Color(0xFFF5F8FF) : Colors.white,
//               ),
//               child: Row(
//                 textDirection: TextDirection.ltr,
//                 children: [
//                   // Blue Arrow Icon
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                         color: isSelected
//                             ? const Color(0xFF1E4AD3)
//                             : const Color(0xffE8E8E9).withOpacity(.5),
//                         shape: BoxShape.circle),
//                     child: Icon(Icons.arrow_forward,
//                         color: isSelected
//                             ? AppColors.secondary
//                             : const Color(0xFF1E4AD3),
//                         size: 16),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(priorities[index]['title']!,
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black)),
//                         Text(priorities[index]['subtitle']!,
//                             style: const TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w600)),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 4),
//                   SvgPicture.asset(
//                     index == 0
//                         ? 'assets/svg/Rating Starfull.svg'
//                         : index == 1
//                             ? 'assets/svg/Rating Star half.svg'
//                             : 'assets/svg/Rating Starempty.svg',
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   // Left Screenshot UI
//   Widget _buildRankList() {
//     final t = AppTranslations.of(context);
//     final ranks = _getRanks(t);
//     return Column(
//       children: List.generate(ranks.length, (index) {
//         bool isSelected = _selectedRank == index;
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: InkWell(
//             onTap: () => setState(() => _selectedRank = index),
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                     color: isSelected
//                         ? const Color(0xFF1E4AD3)
//                         : Colors.grey[100]!),
//                 color: isSelected ? const Color(0xFFF5F8FF) : Colors.white,
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 22,
//                     height: 22,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: isSelected
//                             ? const Color(0xFF1E4AD3)
//                             : Colors.grey[300]!,
//                         width: 1.4,
//                       ),
//                     ),
//                     child: isSelected
//                         ? Center(
//                             child: Container(
//                               width: 15,
//                               height: 15,
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Color(0xFF1E4AD3),
//                               ),
//                             ),
//                           )
//                         : null,
//                   ),

//                   const SizedBox(
//                     width: 5,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(ranks[index]['title']!,
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black)),
//                       Text(ranks[index]['subtitle']!,
//                           style: const TextStyle(
//                               color: Colors.grey,
//                               fontWeight: FontWeight.w600,
//                               fontSize: 12)),
//                     ],
//                   ),
//                   // Custom Radio Button
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildFooter() {
//     final t = AppTranslations.of(context);
//     return CustomButton(
//         onTap: () {
//           if (_currentStep == 2) {
//             setState(() => _currentStep = 1);
//           } else {
//             Navigator.pop(context);
//           }
//         },
//         text: t?.text('confirm') ?? 'تأكيد');
//   }
// }

// class _BottomActionButton extends StatelessWidget {
//   final String text;
//   final String icon;
//   final Color color;

//   const _BottomActionButton({
//     required this.text,
//     required this.icon,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isRTL = Directionality.of(context) == TextDirection.rtl;
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 6,
//         vertical: 6,
//       ),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: Row(
//         textDirection: isRTL ? TextDirection.ltr : TextDirection.rtl,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           isRTL ? const SizedBox(width: 20) : const SizedBox(width: 0),
//           Text(
//             text,
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//             ),
//           ),
//           SvgPicture.asset(
//             icon,
//             width: 25,
//             height: 25,
//             fit: BoxFit.fill,
//           ),
//         ],
//       ),
//     );
//   }
// }
