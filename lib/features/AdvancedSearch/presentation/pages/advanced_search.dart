import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/features/AdvancedSearch/presentation/cubit/advancedsearch_cubit.dart';
import 'package:oreed_clean/features/AdvancedSearch/presentation/widgets/header_widgets.dart';
import 'package:oreed_clean/features/AdvancedSearch/presentation/widgets/result_widgets.dart';
import 'package:oreed_clean/features/AdvancedSearch/presentation/widgets/searchbar.dart';

class AdvancedSearchScreen extends StatefulWidget {
  final String initialSearchQuery;

  const AdvancedSearchScreen({super.key, required this.initialSearchQuery});

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    _searchController.text = widget.initialSearchQuery;

    // Trigger initial search
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdvancedSearchCubit>().search(widget.initialSearchQuery);
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<AdvancedSearchCubit>();
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      if (cubit.state.hasNextPage && !cubit.state.isLoading && !cubit.state.isPaginationLoading) {
        cubit.loadNextPage();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      FocusScope.of(context).unfocus();
      context.read<AdvancedSearchCubit>().search(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackButtonWidget(),
            TitleWidget(title: t?.text('Listofworkers') ?? t?.text('search_results') ?? 'Search Results'),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SearchBarwidget(controller: _searchController, onSearch: _performSearch),
            ),
            const SizedBox(height: 16),
            Expanded(child: ResultsSection(scrollController: _scrollController)),
          ],
        ),
      ),
    );
  }
}


