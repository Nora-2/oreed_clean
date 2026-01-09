part of 'advancedsearch_cubit.dart';
class AdvancedSearchState extends Equatable {
  final bool isLoading;
  final bool isPaginationLoading;
  final String? errorMessage;
  final String? currentSearchQuery;
  final List<SearchSection> searchResults;
  final PaginationInfo? pagination;

  const AdvancedSearchState({
    this.isLoading = false,
    this.isPaginationLoading = false,
    this.errorMessage,
    this.currentSearchQuery,
    this.searchResults = const [],
    this.pagination,
  });

  // Helpers copied from your original getters
  bool get hasError => errorMessage != null;
  bool get hasResults => searchResults.any((section) => section.hasResults);
  bool get hasNextPage => pagination?.hasNextPage ?? false;
  int get currentPage => pagination?.currentPage ?? 1;
  int get totalResults => pagination?.total ?? 0;

  AdvancedSearchState copyWith({
    bool? isLoading,
    bool? isPaginationLoading,
    String? errorMessage,
    String? currentSearchQuery,
    List<SearchSection>? searchResults,
    PaginationInfo? pagination,
  }) {
    return AdvancedSearchState(
      isLoading: isLoading ?? this.isLoading,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
      errorMessage: errorMessage, // We allow nulling this out
      currentSearchQuery: currentSearchQuery ?? this.currentSearchQuery,
      searchResults: searchResults ?? this.searchResults,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isPaginationLoading,
        errorMessage,
        currentSearchQuery,
        searchResults,
        pagination
      ];
}