import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/textstyle/appfonts.dart';
import 'package:oreed_clean/features/favourite/presentation/cubit/favourite_cubit.dart';

class FavoriteTile extends StatelessWidget {
  const FavoriteTile({
    super.key,
    required this.adId,
    required this.sectionId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.location,
    required this.section,
    this.onTap,
  });

  final int adId;
  final int sectionId;
  final String title;
  final String imageUrl;
  final String price;
  final String location;
  final String section;
  final VoidCallback? onTap;

  Future<void> _onFavoritePressed(BuildContext context) async {
    final cubit = context.read<FavoritesCubit>();

    final result = await cubit.toggleFavorite(sectionId: sectionId, adId: adId);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.messageKey),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEFF4EF)),
          ),
          child: Row(
            children: [
              /// IMAGE + FAVORITE
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 120,
                      height: 85,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image, size: 36),
                      ),
                    ),
                  ),

                  /// FAVORITE ICON (Cubit)
                  Positioned(
                    top: 4,
                    right: isRTL ? 4 : null,
                    left: isRTL ? null : 4,
                    child: BlocBuilder<FavoritesCubit, FavoritesState>(
                      buildWhen: (p, c) =>
                          p.favoriteIds != c.favoriteIds ||
                          p.pendingIds != c.pendingIds,
                      builder: (context, state) {
                        final isFav = state.favoriteIds.contains(adId);
                        final isPending = state.pendingIds.contains(adId);

                        return _FavoriteButton(
                          isFav: isFav,
                          isPending: isPending,
                          onTap: isPending
                              ? null
                              : () => _onFavoritePressed(context),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              /// TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.caption.copyWith(
                        fontWeight: AppFonts.medium,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.title.copyWith(
                        fontSize: 18,
                        fontWeight: AppFonts.bold,
                      ),
                    ),
                    if (price.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        price,
                        style: AppFonts.title.copyWith(
                          fontSize: 14.5,
                          fontWeight: AppFonts.bold,
                          color: AppColors.red,
                        ),
                      ),
                    ],
                    if (location.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 11,
                            color: Colors.black45,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppFonts.caption.copyWith(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 🔹 Favorite Button Widget
class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({
    required this.isFav,
    required this.isPending,
    this.onTap,
  });

  final bool isFav;
  final bool isPending;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 4),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: isPending
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                  ),
                )
              : Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  size: 20,
                  color: isFav ? AppColors.red : AppColors.primary,
                ),
        ),
      ),
    );
  }
}
