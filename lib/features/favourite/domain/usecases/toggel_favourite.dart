import 'package:oreed_clean/features/favourite/data/repositories/favourite_repo.dart';
import 'package:oreed_clean/features/favourite/domain/entities/favourite_action_entity.dart';
import 'package:oreed_clean/features/favourite/domain/usecases/toggel_favouriteparams.dart';
class ToggleFavorite {
  final FavoritesRepository repository;

  const ToggleFavorite(this.repository);

  Future<FavoriteActionResult> call(ToggleFavoriteParams params) {
    return repository.toggleFavorite(params);
  }
}
