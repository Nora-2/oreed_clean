// banner_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:oreed_clean/features/banners/domain/usecases/get_banner_usecase.dart';
import 'package:oreed_clean/features/banners/presentation/cubit/banners_state.dart';
import '../../domain/entities/banner_entity.dart';


enum BannerStatus { idle, loading, success, error }

class BannerCubit extends Cubit<BannerState> {
  final GetBannersUseCase getBannersUseCase;

  BannerCubit(this.getBannersUseCase) : super(const BannerState());

  final Map<int?, DateTime> _lastFetchTime = {};
  static const _cacheDuration = Duration(minutes: 5);

  Future<void> fetchBanners(int? sectionId, {bool forceRefresh = false}) async {
    if (!forceRefresh && _isCacheValid(sectionId)) {
      emit(state.copyWith(
        status: BannerStatus.success,
        banners: state.sectionBanners[sectionId] ?? [],
      ));
      return;
    }

    emit(state.copyWith(status: BannerStatus.loading));

    try {
      final fetchedBanners = await getBannersUseCase(sectionId);
      
      // Update the map cache
      final updatedCache = Map<int?, List<BannerEntity>>.from(state.sectionBanners);
      updatedCache[sectionId] = fetchedBanners;
      _lastFetchTime[sectionId] = DateTime.now();

      emit(state.copyWith(
        status: BannerStatus.success,
        banners: fetchedBanners,
        sectionBanners: updatedCache,
      ));
    } catch (e) {
      emit(state.copyWith(status: BannerStatus.error, errorMessage: e.toString()));
    }
  }

  bool _isCacheValid(int? sectionId) {
    if (!state.sectionBanners.containsKey(sectionId)) return false;
    final lastFetch = _lastFetchTime[sectionId];
    return lastFetch != null && DateTime.now().difference(lastFetch) < _cacheDuration;
  }

  void clearCache() {
    _lastFetchTime.clear();
    emit(const BannerState());
  }
}