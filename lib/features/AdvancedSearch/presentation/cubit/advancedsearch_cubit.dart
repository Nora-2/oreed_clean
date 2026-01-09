import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/features/AdvancedSearch/data/models/advanced_search_model.dart';
import 'package:oreed_clean/features/AdvancedSearch/data/repositories/advanced_search_repo.dart';

part 'advancedsearch_state.dart';


class AdvancedSearchCubit extends Cubit<AdvancedSearchState> {
  final AdvancedSearchRepository _repository;

  AdvancedSearchCubit({AdvancedSearchRepository? repository})
      : _repository = repository ?? AdvancedSearchRepository(),
        super(const AdvancedSearchState());

  /// Perform a new search
  Future<void> search(String searchText, {int perPage = 10}) async {
    if (searchText.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Please enter a search term'));
      return;
    }

    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
      currentSearchQuery: searchText,
      searchResults: [],
      pagination: null,
    ));

    try {
      final response = await _repository.advancedSearch(
        searchText: searchText,
        page: 1,
        perPage: perPage,
      );

      if (response.status) {
        log('✅ Search completed: ${response.data.length} sections found');
        emit(state.copyWith(
          isLoading: false,
          searchResults: response.data,
          pagination: response.pagination,
        ));
      } else {
        log('⚠️ Search failed: ${response.msg}');
        emit(state.copyWith(isLoading: false, errorMessage: response.msg));
      }
    } catch (e, stackTrace) {
      log('❌ Search error: $e');
      log('Stack trace: $stackTrace');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to perform search: ${e.toString()}',
      ));
    }
  }

  /// Load next page of results
  Future<void> loadNextPage() async {
    if (!state.hasNextPage || state.isLoading || state.isPaginationLoading || state.currentSearchQuery == null) {
      return;
    }

    emit(state.copyWith(isPaginationLoading: true));

    try {
      final nextPage = state.currentPage + 1;
      final response = await _repository.advancedSearch(
        searchText: state.currentSearchQuery!,
        page: nextPage,
        perPage: state.pagination?.perPage ?? 10,
      );

      if (response.status) {
        // Create a mutable copy of the current results to merge
        final List<SearchSection> updatedResults = List.from(state.searchResults);

        for (var newSection in response.data) {
          final existingIndex = updatedResults.indexWhere((s) => s.name == newSection.name);
          
          if (existingIndex != -1) {
            final existing = updatedResults[existingIndex];
            updatedResults[existingIndex] = SearchSection(
              name: existing.name,
              companyCount: existing.companyCount + newSection.companyCount,
              categoryCount: existing.categoryCount + newSection.categoryCount,
              companies: [...existing.companies, ...newSection.companies],
              categories: [...existing.categories, ...newSection.categories],
              sectionId: existing.sectionId,
            );
          } else {
            updatedResults.add(newSection);
          }
        }

        log('✅ Loaded page $nextPage');
        emit(state.copyWith(
          isPaginationLoading: false,
          searchResults: updatedResults,
          pagination: response.pagination,
        ));
      } else {
        log('⚠️ Load next page failed: ${response.msg}');
        emit(state.copyWith(isPaginationLoading: false, errorMessage: response.msg));
      }
    } catch (e) {
      log('❌ Load next page error: $e');
      emit(state.copyWith(
        isPaginationLoading: false,
        errorMessage: 'Failed to load more results: ${e.toString()}',
      ));
    }
  }

  /// Refresh current search
  Future<void> refresh() async {
    if (state.currentSearchQuery != null) {
      await search(state.currentSearchQuery!);
    }
  }

  /// Clear search results
  void clearSearch() {
    emit(const AdvancedSearchState());
  }

  /// Reset error state
  void resetError() {
    emit(state.copyWith(errorMessage: null));
  }
}