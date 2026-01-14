import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/features/addetails/presentation/pages/ad_detailes_screen.dart';
import 'package:oreed_clean/features/companydetails/presentation/widgets/related_ad_list_card.dart';
import 'package:oreed_clean/features/favourite/presentation/cubit/favourite_cubit.dart';
import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';

/// ✅ List Layout using RelatedAdListCard
class ListAdsView extends StatelessWidget {
  final List<RelatedAdEntity> items;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final int sectionId;
  final int userId;

  const ListAdsView({
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
    return ListView.separated(
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: const EdgeInsets.fromLTRB(4, 10, 4, 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) {
        final ad = items[i];
        final favProvider = ctx.watch<FavoritesCubit>();
        final isFav = favProvider.isFavorite(ad.id);
        final isBusy = favProvider.isPending(ad.id);

        return RelatedAdListCard(
          item: ad,
          isFavorite: isFav,
          isPending: isBusy,
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
  }
}
