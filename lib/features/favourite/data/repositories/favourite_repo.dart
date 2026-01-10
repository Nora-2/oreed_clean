import 'package:oreed_clean/features/favourite/domain/entities/favourite_action_entity.dart';
import 'package:oreed_clean/features/favourite/domain/entities/favourite_ad_entity.dart';
import 'package:oreed_clean/features/favourite/domain/usecases/toggel_favouriteparams.dart';


abstract class FavoritesRepository {
  Future<FavoriteActionResult> toggleFavorite(ToggleFavoriteParams params);
  Future<List<FavoriteAdEntity>> getFavorites();

}
