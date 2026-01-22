// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/enmus/enum.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/bottomsheets/option_sheet_register_list.dart';
import 'package:oreed_clean/core/utils/option_item_register.dart';
import 'package:oreed_clean/core/utils/shared_widgets/circelback.dart';
import 'package:oreed_clean/core/utils/shared_widgets/emptywidget.dart';
import 'package:oreed_clean/features/company_types_by_company/presentation/cubit/company_types_by_company_cubit.dart';
import 'package:oreed_clean/features/company_types_by_company/presentation/widgets/animated_company_grid.dart';
import 'package:oreed_clean/features/company_types_by_company/presentation/widgets/search_bar.dart';
import 'package:oreed_clean/features/company_types_by_company/presentation/widgets/select_sheet_field_ads.dart';
import 'package:oreed_clean/features/companydetails/presentation/widgets/segmented_pill_toggel.dart';
import 'package:oreed_clean/features/location_selector/presentation/cubit/location_selector_cubit.dart';

class CompanyTypesCompanyScreen extends StatefulWidget {
  static const String routeName = "/CompanyTypesCompany";
  final String companyId;
  final int sectionId;
  final String title;

  const CompanyTypesCompanyScreen({
    super.key,
    required this.companyId,
    this.title = 'أنواع الشركات',
    required this.sectionId,
  });

  @override
  State<CompanyTypesCompanyScreen> createState() =>
      _CompanyTypesCompanyScreenState();
}

class _CompanyTypesCompanyScreenState extends State<CompanyTypesCompanyScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  final Color _border = const Color(0xFFE5E7EB);
  final Color _textMuted = const Color(0xFF6B7280);

  String? _stateLabel;
  String? _cityLabel;
  final Map<String, dynamic> _filterData = {};

  ViewMode _viewMode = ViewMode.grid;

  @override
  void initState() {
    super.initState();
    // Initial data fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyTypesByCompanyCubit>().fetchCompanyTypes(
        widget.companyId,
        _filterData,
      );
      context.read<LocationSelectorCubit>().fetchStates();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await context.read<CompanyTypesByCompanyCubit>().fetchCompanyTypes(
      widget.companyId,
      _filterData,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // --- Header Section ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      CircleBack(
                        background_color: Color(0xffe8e8e9),
                        context: context,
                      ),
                      const SizedBox(height: 10),
                      _buildHeader(t),
                      const SizedBox(height: 10),
                      _buildSearchBar(t),
                      const SizedBox(height: 20),
                      _buildFilters(t),
                    ],
                  ),
                ),
              ),

              // --- Main Content Section (Cubit-Driven) ---
              BlocBuilder<
                CompanyTypesByCompanyCubit,
                CompanyTypesByCompanyState
              >(
                builder: (context, state) {
                  if (state.status == CompanyTypesCompanyStatus.loading) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state.status == CompanyTypesCompanyStatus.error) {
                    return _buildErrorView(t);
                  }

                  // Local Filtering for search bar
                  final query = _searchCtrl.text.trim().toLowerCase();
                  final items = query.isEmpty
                      ? state.companyTypes
                      : state.companyTypes
                            .where((e) => e.name.toLowerCase().contains(query))
                            .toList();

                  if (items.isEmpty) {
                    return _buildEmptyView(t, query);
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    sliver: _buildCompanyGrid(items),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppTranslations? t) {
    return Row(
      children: [
        Text(
          '${t?.text('company_types.companies_of') ?? 'شركات'} ${widget.title}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        SegmentedPillToggle(
          value: _viewMode,
          onChanged: (ViewMode value) => setState(() => _viewMode = value),
        ),
      ],
    );
  }

  Widget _buildSearchBar(AppTranslations? t) {
    return SizedBox(
      height: 45,
      child: SearchBarcompanytype(
        controller: _searchCtrl,
        hintText:
            t?.text('company_types.searchHint') ?? 'ابحث عن نوع الشركة...',
        onChanged: (_) => setState(() {}),
        borderColor: _border,
      ),
    );
  }

  Widget _buildFilters(AppTranslations? t) {
    return BlocBuilder<LocationSelectorCubit, LocationSelectorState>(
      builder: (context, locState) {
        return Row(
          children: [
            // Governorate Select
            Expanded(
              child: SelectSheetFieldads(
                label: const Text(''),
                redius: 45,
                prefixIcon: _buildIcon(AppIcons.locationCountry),
                hint: _stateLabel ?? (t?.text("governorate") ?? 'المحافظة'),
                onTap: () async {
                  if (locState.states.isEmpty) {
                    await context.read<LocationSelectorCubit>().fetchStates();
                  }

                  final options = locState.states
                      .map(
                        (s) => OptionItemregister(
                          label: s.name,
                          icon: AppIcons.global,
                          colorTag: 1,
                        ),
                      )
                      .toList();

                  final picked = await showAppOptionSheetregister(
                    context: context,
                    title:
                        t?.text('select.select_governorate') ?? 'اختر المحافظة',
                    options: options,
                    current: _stateLabel,
                    hint:
                        t?.text('select.search_governorate') ??
                        'ابحث عن المحافظة',
                    subtitle:
                        t?.text('select.select_governorate_subtitle') ??
                        'اختر محافظتك لعرض الإعلانات والخدمات.',

                    tagColor: (tag) => const Color(0xFF2563EB),
                  );

                  if (picked != null) {
                    setState(() {
                      _stateLabel = picked;
                      _cityLabel = null;
                    });
                    final state = locState.states.firstWhere(
                      (e) => e.name == picked,
                    );
                    _filterData['state_id'] = state.id;
                    _filterData.remove('city_id');

                    // Fetch cities and refresh main list
                    context.read<LocationSelectorCubit>().fetchCities(state.id);
                    _refresh();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),

            // City Select
            Expanded(
              child: SelectSheetFieldads(
                label: const Text(''),
                redius: 45,
                prefixIcon: _buildIcon(AppIcons.location),
                hint: _cityLabel ?? (t?.text('city') ?? 'المدينة'),
                onTap: () async {
                  if (_stateLabel == null) {
                    _showMsg(
                      t?.text('error.select_governorate_first') ??
                          'يرجى اختيار المحافظة أولاً',
                    );
                    return;
                  }

                  final options = locState.cities
                      .map(
                        (c) => OptionItemregister(
                          label: c.name,
                          icon: AppIcons.location,
                          colorTag: 2,
                        ),
                      )
                      .toList();

                  final picked = await showAppOptionSheetregister(
                    context: context,
                    title: t?.text('select.select_city') ?? 'اختر المدينة',
                    options: options,
                    current: _cityLabel,
                    hint: t?.text('select.search_city') ?? 'ابحث عن المدينة',
                    subtitle:
                        t?.text('select.select_city_subtitle') ??
                        'اختر المدينة التابعة للمحافظة المختارة.',

                    tagColor: (tag) => const Color(0xFF2563EB),
                  );

                  if (picked != null) {
                    setState(() => _cityLabel = picked);
                    final city = locState.cities.firstWhere(
                      (e) => e.name == picked,
                    );
                    _filterData['city_id'] = city.id;
                    _refresh();
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIcon(String path) {
    return SizedBox(
      width: 20,
      height: 20,
      child: Center(child: SvgPicture.asset(path, width: 20, height: 20)),
    );
  }

  Widget _buildCompanyGrid(List items) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _viewMode == ViewMode.list ? 2 : 3,
        childAspectRatio: _viewMode == ViewMode.list ? 1.2 : 1,
        crossAxisSpacing: 15,
        mainAxisSpacing: 12,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final data = items[index];
        return AnimatedCompanyGridCard(
          title: data.name,
          imageUrl: data.image,
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.companydetails,
              arguments: {'sectionId': widget.sectionId, 'companyId': data.id},
            );
          },
        );
      }, childCount: items.length),
    );
  }

  Widget _buildErrorView(AppTranslations? t) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t?.text('common.loadError') ?? 'Error loading data',
              style: TextStyle(color: _textMuted),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _refresh,
              child: Text(t?.text('common.retry') ?? 'Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(AppTranslations? t, String query) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: emptyAdsView(
          visible: false,
          context: context,
          image: AppIcons.emptyCompany,
          title: query.isEmpty
              ? (t?.text('company_types.no_available') ?? 'لا توجد شركات متاحة')
              : (t?.text('company_types.no_results') ?? 'لا توجد نتائج للبحث'),
          onAddPressed: () => Navigator.pushNamed(context, Routes.homelayout),
          button: '',
          subtitle: '',
        ),
      ),
    );
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
