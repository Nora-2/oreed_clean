import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/shared_widgets/emptywidget.dart';
import 'package:oreed_clean/core/utils/textstyle/appfonts.dart';
import 'package:oreed_clean/features/companydetails/presentation/widgets/related_ad_grid_card.dart';
import 'package:oreed_clean/features/favourite/presentation/cubit/favourite_cubit.dart';
import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';

class FavoritesSection extends StatelessWidget {
  const FavoritesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);

    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.error != null) {
          return Center(
            child: Text(
              state.error!,
              style: AppFonts.body.copyWith(fontWeight: AppFonts.semiBold),
            ),
          );
        }

        if (state.items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: emptyAdsView(
              visible: true,
              context: context,
              button:
                  appTrans?.text('common.explore_ads') ?? 'استكشاف الإعلانات',
              image: AppIcons.emptyFav,
              title: appTrans?.text('empty_favorites') ?? 'المفضلة فارغة',
              subtitle:
                  appTrans?.text('empty_favorites_subtitle') ??
                  'لم تقم بإضافة أي عناصر إلى المفضلة بعد.',
              onAddPressed: () {
                Navigator.pushNamed(context, Routes.homelayout);
              },
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          itemCount: state.items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: .68,
          ),
          itemBuilder: (context, i) {
            final ad = state.items[i];

            return RelatedAdGridCard(
              visable: false,
              item: RelatedAdEntity(
                id: ad.id,
                title: ad.title,
                mainImage: ad.imageUrl,
                price: ad.price,
                city: ad.city ?? '',
                state: ad.state ?? '',
                createdAt: '',
                visit: 0,
                adType: '',
              ),
              sectionId: ad.sectionId,
              onTap: () {
                Navigator.of(context).pushNamed(
                  Routes.addetails,
                  arguments: {'sectionId': ad.sectionId, 'adId': ad.id},
                );
              },
            );
          },
        );
      },
    );
  }
}
