import 'package:flutter/foundation.dart';

import '../../domain/entities/banner_entity.dart';
import '../../domain/usecases/get_banners_usecase.dart';

enum BannerStatus { idle, loading, success, error }

class BannerProvider extends ChangeNotifier {
  final GetBannersUseCase getBannersUseCase;

  BannerProvider(this.getBannersUseCase);

  BannerStatus status = BannerStatus.idle;
  List<BannerEntity> banners = [];
  String? errorMessage;

  // ✅ Cache banners by sectionId to avoid redundant API calls
  final Map<int?, List<BannerEntity>> _bannersCache = {};
  final Map<int?, DateTime> _lastFetchTime = {};

  // Cache duration (5 minutes)
  static const _cacheDuration = Duration(minutes: 5);

  Future<void> fetchBanners(int? sectionId, {bool forceRefresh = false}) async {
    
    if (!forceRefresh && _isCacheValid(sectionId)) {
      banners = _bannersCache[sectionId] ?? [];
      status = BannerStatus.success;
      notifyListeners();
      return;
    }

    try {
      status = BannerStatus.loading;
      notifyListeners();

      final fetchedBanners = await getBannersUseCase(sectionId);

      // ✅ Update cache
      _bannersCache[sectionId] = fetchedBanners;
      _lastFetchTime[sectionId] = DateTime.now();

      banners = fetchedBanners;
      status = BannerStatus.success;
    } catch (e) {
      errorMessage = e.toString();
      status = BannerStatus.error;
    }
    notifyListeners();
  }

  /// ✅ Check if cached data is still valid
  bool _isCacheValid(int? sectionId) {
    if (!_bannersCache.containsKey(sectionId)) return false;

    final lastFetch = _lastFetchTime[sectionId];
    if (lastFetch == null) return false;

    return DateTime.now().difference(lastFetch) < _cacheDuration;
  }

  /// ✅ Clear cache for a specific section or all sections
  void clearCache({int? sectionId}) {
    if (sectionId != null) {
      _bannersCache.remove(sectionId);
      _lastFetchTime.remove(sectionId);
    } else {
      _bannersCache.clear();
      _lastFetchTime.clear();
    }
  }

  /// ✅ Get cached banners for a specific section
  List<BannerEntity> getCachedBanners(int? sectionId) {
    return _bannersCache[sectionId] ?? [];
  }
}
