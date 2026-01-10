import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oreed_clean/features/banners/domain/entities/banner_entity.dart';
import 'package:oreed_clean/features/banners/presentation/cubit/banners_cubit.dart';
import 'package:oreed_clean/features/home/data/models/releted_ad_model.dart';
import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';
import 'package:oreed_clean/features/home/domain/entities/section_entity.dart';
import 'package:oreed_clean/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/features/home/domain/usecases/get_related_ad_usecase.dart';
part 'home_state.dart';
class MainHomeCubit extends Cubit<MainHomeState> {
  final GetSectionsUseCase _getSections;
  final GetRelatedAdsUseCase _getRelatedAds;
  final BannerCubit _bannerCubit; // Use the Cubit, not the UseCase

  MainHomeCubit(
    this._getSections,
    this._getRelatedAds,
    this._bannerCubit,
  ) : super(const MainHomeState());

  // Access banners via the BannerCubit's state
  List<BannerEntity> get currentBanners => _bannerCubit.state.banners;

  Future<void> fetchHomeData() async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null));

    try {
      final sections = await _getSections(null);
      emit(state.copyWith(sections: sections));
      
      // Fetch general banners (null section) and related ads
      await Future.wait([
        _bannerCubit.fetchBanners(null),
        fetchRelatedAds(),
      ]);

      emit(state.copyWith(status: HomeStatus.success));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error, errorMessage: e.toString()));
    }
  }

  /// 🔹 Refresh all data (Pull-to-refresh)
  Future<void> refreshHome() async {
    _bannerCubit.clearCache();
    await fetchHomeData();
  }

  /// 🔹 Fetch related ads
  Future<void> fetchRelatedAds() async {
    emit(state.copyWith(relatedAdsStatus: HomeStatus.loading, relatedAdsError: null));

    try {
      // Parallel execution for performance
      final results = await Future.wait([
        _getRelatedAds(sectionId: 1),  // Cars
        _getRelatedAds(sectionId: 2),  // Real Estate
        _getRelatedAds(sectionId: 3),  // Technical
        _getRelatedAds(sectionId: 12), // Phones
      ]);

      emit(state.copyWith(
        relatedAdsStatus: HomeStatus.success,
        relatedAdsCars: _mapEntitiesToRelatedAds(results[0]),
        relatedAdsRealEstate: _mapEntitiesToRelatedAds(results[1]),
        relatedAdsTechnical: _mapEntitiesToRelatedAds(results[2]),
        relatedAdsPhones: _mapEntitiesToRelatedAds(results[3]),
      ));
    } catch (e) {
      emit(state.copyWith(
        relatedAdsStatus: HomeStatus.error,
        relatedAdsError: e.toString(),
      ));
    }
  }

  List<RelatedAd> _mapEntitiesToRelatedAds(List<RelatedAdEntity> entities) {
    return entities.map((e) => RelatedAd(
        image: e.mainImage ?? '',
        title: e.title,
        location: '${e.city} / ${e.state}',
        dateText: e.createdAt ?? '',
        viewsText: e.visit.toString(),
        priceText: '${e.price ?? '0'} د.ك',
        id: e.id.toString(),
        adType: e.adType ?? '',
      )).toList();
  }
}