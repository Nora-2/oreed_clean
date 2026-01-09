import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/shared_widgets/emptywidget.dart';
import 'package:oreed_clean/features/AdvancedSearch/presentation/cubit/advancedsearch_cubit.dart';
import 'package:oreed_clean/features/AdvancedSearch/presentation/widgets/section_widgets.dart';

class ResultsSection extends StatelessWidget {
  final ScrollController scrollController;

  const ResultsSection({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvancedSearchCubit, AdvancedSearchState>(
      builder: (context, state) {
        if (state.isLoading && state.searchResults.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.hasError && state.searchResults.isEmpty) {
          return Center(child: Text(state.errorMessage ?? 'An error occurred'));
        }
        if (!state.hasResults && !state.isLoading) {
          return _NoResultsWidget();
        }
        return RefreshIndicator(
          onRefresh: () => context.read<AdvancedSearchCubit>().refresh(),
          child: ListView.builder(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: state.searchResults.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) return _ResultCountWidget(count: state.totalResults);
              if (index == state.searchResults.length + 1) {
                return state.isPaginationLoading
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : const SizedBox(height: 20);
              }
              final section = state.searchResults[index - 1];
              if (section.companies.isEmpty && section.categories.isEmpty) return const SizedBox.shrink();
              return SectionCardWidget(section: section);
            },
          ),
        );
      },
    );
  }
}

/// No Results Widget
class _NoResultsWidget extends StatelessWidget {
  const _NoResultsWidget();

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);
    return Center(
      child: emptyAdsView(
        context: context,
        title: tr?.text('no_results_found') ?? 'No results found',
        subtitle: tr?.text('no_results_subtitle') ?? 'Try searching for something else.',
        image: AppIcons.emptySearch,
        visible: false,
        onAddPressed: () {},
        button: '',
      ),
    );
  }
}

/// Result Count Widget
class _ResultCountWidget extends StatelessWidget {
  final int count;
  const _ResultCountWidget({required this.count});

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Text(
        '$count ${t?.text('Listofworkers')}',
        style: const TextStyle(color: Color(0xff676768), fontWeight: FontWeight.w500, fontSize: 14),
      ),
    );
  }
}

