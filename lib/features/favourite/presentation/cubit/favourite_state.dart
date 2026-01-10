
part of 'favourite_cubit.dart';

class FavoritesState extends Equatable {
  final List<FavoriteAdEntity> items;
  final Set<int> favoriteIds;
  final Set<int> pendingIds;
  final bool isLoading;
  final String? error;

  const FavoritesState({
    this.items = const [],
    this.favoriteIds = const {},
    this.pendingIds = const {},
    this.isLoading = false,
    this.error,
  });

  FavoritesState copyWith({
    List<FavoriteAdEntity>? items,
    Set<int>? favoriteIds,
    Set<int>? pendingIds,
    bool? isLoading,
    String? error,
  }) {
    return FavoritesState(
      items: items ?? this.items,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      pendingIds: pendingIds ?? this.pendingIds,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [items, favoriteIds, pendingIds, isLoading, error];
}