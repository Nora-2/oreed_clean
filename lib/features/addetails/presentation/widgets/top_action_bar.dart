// lib/view/screens/details_ads/widgets/top_actions_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart'
    show AppColors;
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/features/favourite/presentation/cubit/favourite_cubit.dart';

import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class TopActionsBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSave;
  final int adId;
  final int sectionId;
  final String adTitle;
  final String? adImage;
  final String? pin;

  const TopActionsBar({
    super.key,
    required this.onBack,
    required this.onSave,
    required this.adId,
    required this.sectionId,
    required this.adTitle,
    this.pin,
    this.adImage,
  });

  /// Share ad with professional formatted message and deep linking
  void _shareAd(BuildContext context) {
    final t = AppTranslations.of(context);

    final String httpsLink = '';

    const String appName = 'Oreed';
    const String downloadLink = 'https://onelink.to/oreed';

    final String message =
        '''
$appName

${t?.text('download_app_from') ?? 'تحميل التطبيق من'}
$downloadLink

━━━━━━━━━━━━━━━━━━━━━━━━━━

$adTitle

━━━━━━━━━━━━━━━━━━━━━━━━━━

${t?.text('shared_link') ?? 'الرابط المشارك'}:
$httpsLink
''';

    Share.share(message, subject: '$appName - $adTitle');
  }

  @override
  Widget build(BuildContext context) {
    // زر دائري عام
    Widget circleBtn(
      IconData icon,
      Color color,
      VoidCallback onTap, {
      double size = 50,
      double iconSize = 24,
    }) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: color, size: iconSize),
        ),
      );
    }

    return Row(
      children: [
        const SizedBox(width: 10),
        circleBtn(
          Icons.arrow_back,
          AppColors.primary,
          onBack,
          size: 35,
          iconSize: 20,
        ),
        const SizedBox(width: 10),
        pin == 'pinned'
            ? _MetaItem(
                icon: AppIcons.pin,
                label: AppTranslations.of(context)!.text('ad_type.pinned'),
                color: const Color(0xFFFF8A00),
              )
            : pin == 'featured'
            ? _MetaItem(
                icon: AppIcons.specific,
                label: AppTranslations.of(context)!.text('ad_type.featured'),
                color: const Color(0xFF8133F1),
              )
            : Container(),
        const Spacer(),
        Row(
          children: [
            circleBtn(
              Icons.share,
              AppColors.primary,
              () => _shareAd(context),
              size: 35,
              iconSize: 20,
            ),
            const SizedBox(width: 8),
            // زر المفضلة مع Provider
            BlocBuilder<FavoritesCubit, FavoritesState>(
              // Rebuild only if the favorite status or pending status of THIS specific ad changes
              buildWhen: (previous, current) {
                final wasFav = previous.favoriteIds.contains(adId);
                final isFav = current.favoriteIds.contains(adId);
                final wasPending = previous.pendingIds.contains(adId);
                final isPending = current.pendingIds.contains(adId);
                return wasFav != isFav || wasPending != isPending;
              },
              builder: (context, state) {
                final isFav = state.favoriteIds.contains(adId);
                final isPending = state.pendingIds.contains(adId);

                return InkWell(
                  onTap: isPending
                      ? null
                      : () async {
                          // Trigger the toggle via Cubit
                          final result = await context
                              .read<FavoritesCubit>()
                              .toggleFavorite(sectionId: sectionId, adId: adId);

                          // Handle the snackbar message
                          if (context.mounted) {
                            // translate message key if you use translation logic, otherwise use raw string
                            final msg = result.messageKey;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(msg),
                                duration: const Duration(milliseconds: 1500),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },

                  borderRadius: BorderRadius.circular(17.5),
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: isPending
                        ? Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            size: 25,
                            color: isFav
                                ? AppColors.primary
                                : AppColors.primary,
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  final String icon;
  final String label;
  final Color? color;

  const _MetaItem({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(icon, width: 25, height: 25),
        const SizedBox(width: 4),
        Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: color,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
