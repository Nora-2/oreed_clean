import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:oreed_clean/core/enmus/enum.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/shared_widgets/ad_type_badge.dart';
import 'package:oreed_clean/features/companydetails/presentation/widgets/favouritebutton.dart';
import 'package:oreed_clean/features/favourite/presentation/cubit/favourite_cubit.dart';
import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';

class RelatedAdListCard extends StatelessWidget {
  final RelatedAdEntity item;
  final VoidCallback? onTap;
  final VoidCallback? onToggleFavorite;

  // Favorites states
  final bool isFavorite;
  final bool isPending;
  final bool isDisabled;
  final int? sectionId; // section id of the list context

  const RelatedAdListCard({
    super.key,
    required this.item,
    this.onTap,
    this.onToggleFavorite,
    this.isFavorite = false,
    this.isPending = false,
    this.isDisabled = false,
    this.sectionId, // new optional param
  });

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatPrice(String raw) {
    if (raw.isEmpty) return raw;
    if (raw.endsWith('.00')) return raw.substring(0, raw.length - 3);
    if (raw.endsWith('.0')) return raw.substring(0, raw.length - 2);
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    final String? image = item.mainImage;
    final String displayPrice = _formatPrice(item.price ?? '');
    final String date = _formatDate(item.createdAt);
    final t = AppTranslations.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.withOpacity(.2)),
          ),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Image Section
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 100,
                          height: 90,
                          child: (image != null && image.isNotEmpty)
                              ? Image.network(image, fit: BoxFit.contain)
                              : Container(
                                  color: const Color(0xFFF3F4F6),
                                  child: const Icon(
                                    Icons.image_outlined,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: AdTypeBadge(
                          type: adTypeFromString(item.adType),
                          dense: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            end: 30.0,
                          ), // Space for Heart Icon
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF0F172A),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Location
                        Row(
                          children: [
                            SvgPicture.asset(AppIcons.locationCountry),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${item.city}، ${item.state}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Bottom Row (Price & Actions)
                        Row(
                          children: [
                            if (displayPrice.isNotEmpty)
                              Expanded(
                                child: SizedBox(
                                  child: Text(
                                    '$displayPrice ${t?.text('currency_kwd') ?? 'د.ك'}',
                                    style: const TextStyle(
                                      color: Color(0xFF2563EB),
                                      // Blue color like screenshot
                                      fontWeight: FontWeight.w800,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(width: 5),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AppIcons.loadingTime,
                                  height: 12,
                                  width: 12,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.grey,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  date, // Or relative time like "3 days ago"
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                SvgPicture.asset(
                                  AppIcons.eyeActive,
                                  height: 12,
                                  width: 12,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.grey,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${item.visit}",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 4),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffe8e8e9),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.all(6),
                              child: Icon(
                                Icons.arrow_forward,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // 3. Absolute Positioned Heart Button (Top Left / End)
              PositionedDirectional(
                top: 0,
                end: 0,
                child: BlocBuilder<FavoritesCubit, FavoritesState>(
                  buildWhen: (p, c) =>
                      p.favoriteIds != c.favoriteIds ||
                      p.pendingIds != c.pendingIds,
                  builder: (context, state) {
                    final adId = item.id;
                    final cubit = context.read<FavoritesCubit>();

                    return FavoriteButton(
                      isFavorite: cubit.isFavorite(adId),
                      isPending: cubit.isPending(adId),
                      isDisabled: isDisabled,
                      onPressed: cubit.isPending(adId)
                          ? null
                          : () {
                              cubit.toggleFavorite(
                                adId: adId,
                                sectionId: sectionId!,
                              );
                            },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
