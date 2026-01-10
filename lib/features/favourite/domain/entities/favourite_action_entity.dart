enum FavoriteAction { added, removed }

class FavoriteActionResult {
  final bool success;
  final String messageKey; // مثال: locale.favorite_removed
  final FavoriteAction? action; // added / removed

  const FavoriteActionResult({
    required this.success,
    required this.messageKey,
    this.action,
  });
}
