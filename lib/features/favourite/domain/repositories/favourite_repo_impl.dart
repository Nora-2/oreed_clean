import 'package:oreed_clean/features/favourite/data/datasources/favourite_remote_data_source.dart';
import 'package:oreed_clean/features/favourite/data/repositories/favourite_repo.dart';
import 'package:oreed_clean/features/favourite/domain/entities/favourite_action_entity.dart';
import 'package:oreed_clean/features/favourite/domain/entities/favourite_ad_entity.dart';
import 'package:oreed_clean/features/favourite/domain/usecases/toggel_favouriteparams.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remote;

  FavoritesRepositoryImpl(this.remote,);

  @override
  Future<FavoriteActionResult> toggleFavorite(
      ToggleFavoriteParams params) async {
    try {
      final res = await remote.toggleFavorite(
        sectionId: params.sectionId,
        adId: params.adId,
      );

      // السيرفر بيرجع msg كمفتاح ترجمة:
      final msgKey = res.messageKey;

      // نستنتج الـ action من المفتاح (لو متاح)
      final action = _parseActionFromMsgKey(msgKey);

      return FavoriteActionResult(
        success: res.status,
        messageKey: msgKey,
        action: action,
      );
    } catch (e) {
      // نرجّع messageKey عام في حالة الخطأ (هتترجمه لاحقًا)
      return const FavoriteActionResult(
        success: false,
        messageKey: 'locale.error_try_again',
      );
    }
  }

  FavoriteAction? _parseActionFromMsgKey(String key) {
    final k = key.toLowerCase();
    if (k.contains('added')) return FavoriteAction.added;
    if (k.contains('removed')) return FavoriteAction.removed;
    // لو السيرفر بيرجع صياغة تانية، ممكن تضيف mapping هنا
    return null;
  }

  @override
  Future<List<FavoriteAdEntity>> getFavorites() async {
    final res = await remote.getFavorites();
    if (!res.status) return <FavoriteAdEntity>[];

    return res.items
        .map((m) => FavoriteAdEntity(
              id: m.id,
              title: m.title,
              imageUrl: m.imageUrl,
              price: m.price,
              city: m.cityName,
              state: m.stateName,
              section: m.sectionName,
              baseSection: m.baseSection,
              sectionId: m.sectionId,
            ))
        .toList();
  }
}
