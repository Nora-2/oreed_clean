// features/favorites/domain/usecases/get_favorites.dart
import 'package:oreed_clean/features/favourite/data/repositories/favourite_repo.dart';
import 'package:oreed_clean/features/favourite/domain/entities/favourite_ad_entity.dart';

class GetFavorites {
  final FavoritesRepository repo;
  GetFavorites(this.repo);

  Future<List<FavoriteAdEntity>> call() => repo.getFavorites();
}
