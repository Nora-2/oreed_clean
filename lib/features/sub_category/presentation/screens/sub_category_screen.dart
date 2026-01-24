import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/enmus/enum.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/shared_widgets/route_observer.dart';
import 'package:oreed_clean/core/utils/shared_widgets/shimmer.dart';
import 'package:oreed_clean/features/banners/presentation/pages/banner_screen.dart';
import 'package:oreed_clean/features/company_types_by_company/presentation/pages/company_types_company.dart';
import 'package:oreed_clean/features/companydetails/presentation/widgets/related_ads_view.dart';
import 'package:oreed_clean/features/sub_category/data/models/company_model.dart';
import 'package:oreed_clean/features/sub_category/presentation/cubit/sub_category_cubit.dart';
import 'package:oreed_clean/features/sub_category/presentation/widgets/compines_section.dart';
import 'package:oreed_clean/features/sub_category/presentation/widgets/custom_bottom_nav.dart';
import 'package:oreed_clean/features/sub_category/presentation/widgets/sub_category_list.dart';
import 'package:oreed_clean/features/sub_subcategory/presentation/screens/sub_subcategory_screen.dart';

import '../../data/models/categorymodel.dart';

class SubCategoriesScreen extends StatefulWidget {
  final int sectionId;
  final String? searchText; // Optional search text from navigation
  final bool adsOnlyMode; // Show only ads tab when true
  final String? title; // Optional title for AppBar

  const SubCategoriesScreen({
    super.key,
    required this.sectionId,
    this.searchText,
    this.adsOnlyMode = false,
    this.title,
  });

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen>
    with RouteAware {
  late AppTranslations t;
  bool _initialized = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchText ?? '';
  }

  /// ✅ Detect sectionId change
  @override
  void didUpdateWidget(covariant SubCategoriesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sectionId != oldWidget.sectionId) {
      context.read<SubCategoryCubit>().clearData();
      _loadData();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      routeObserver.subscribe(this, ModalRoute.of(context)!); // 👈 Subscribe
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadData();
      });
    }
  }

  Future<void> _loadData() async {
    final cubit = context.read<SubCategoryCubit>();
    cubit.setAdsOnlyMode(widget.adsOnlyMode); // Set ads-only mode

    if (!widget.adsOnlyMode) {
      // Fetch everything in one shot so data is loaded once and shown together
      final futures = <Future<void>>[];

      // For cars, also load sections 4/6/7 without overwriting main data
      if (widget.sectionId == 1) {
        futures.addAll([
          cubit.fetchData(widget.sectionId),
          cubit.fetchSectionCategory(4),
          cubit.fetchSectionCategory(6),
          cubit.fetchSectionCategory(7),
        ]);
      } else {
        futures.add(cubit.fetchData(widget.sectionId));
      }

      await Future.wait(futures);
    }

    cubit.fetchRelatedAds(widget.sectionId, searchText: widget.searchText);
  }

  /// ✅ Reload when user navigates back to this screen
  @override
  void didPopNext() {
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Widget _buildSearchField(String hint) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: (text) {
          if (text.trim().isNotEmpty) {
            context.read<SubCategoryCubit>().fetchRelatedAds(
                  widget.sectionId,
                  searchText: text.trim(),
                );
          }
        },
        onChanged: (text) {
          // Just update state to keep text visible, don't trigger search on every character
          setState(() {});
        },
        textAlign: isRTL ? TextAlign.right : TextAlign.left,
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          prefixIcon: SizedBox(
            width: 14,
            height: 16,
            child: Center(
              child: SvgPicture.asset(
                AppIcons.search,
                width: 14,
                height: 14,
                placeholderBuilder: (_) =>
                    const Icon(Icons.search, size: 20, color: Colors.grey),
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        ),
      ),
    );
  }

  /// Full-page shimmer for initial loading
  Widget _buildLoadingShimmer() => CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          // Search row placeholder (keep back button real for UX)
          const SliverToBoxAdapter(
            child: Row(
              children: [
                SizedBox(width: 48, height: 40),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ShimmerBox(height: 40),
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          // Banner placeholder
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: ShimmerBox(height: 140),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          // Companies grid placeholder
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (_, __) => const Column(
                  children: [
                    ShimmerBox(height: 64, width: 64),
                    SizedBox(height: 8),
                    ShimmerBox(height: 12, width: double.infinity),
                  ],
                ),
                childCount: 6,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          // Ads list skeleton (simple list items)
          SliverList.separated(
            itemCount: 4,
            itemBuilder: (_, __) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: ShimmerBox(height: 110),
            ),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      );

  Widget _buildError(BuildContext context, String? msg) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t.text('common.loadError'),
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final cubit = context.read<SubCategoryCubit>();
                cubit.fetchData(widget.sectionId);
                cubit.fetchRelatedAds(widget.sectionId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Builder(
                builder: (context) {
                  final t = AppTranslations.of(context);
                  return Text(t?.text('common.retry') ?? 'إعادة المحاولة');
                },
              ),
            ),
          ],
        ),
      );

  /// Handle navigation based on category's section type
  void _handleCategoryNavigation(CategoryModel cat) {
    final targetSectionId = cat.sectionId ?? widget.sectionId;
    final sectionType = SectionTypeExtension.fromId(targetSectionId);

    switch (sectionType) {
      case SectionType.car:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => PropertyFilterScreen(
        //       sectionId: targetSectionId,
        //       categoryId: cat.id!,
        //       title: cat.name!,
        //       subtitel: widget.title ?? '',
        //       subCategoryId: 0,
        //     ),
        //   ),
        // );
        break;

      case SectionType.property:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategoryIntroScreen(
              sectionId: targetSectionId,
              categoryId: cat.id!,
              title: cat.name!,
            ),
          ),
        );
        break;

      case SectionType.technical:
      case SectionType.normal:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => TechnicalAdsScreen(
        //       subtitle: widget.title ?? '',
        //       sectionId: targetSectionId,
        //       categoryId: cat.id!,
        //       title: cat.name ?? '',
        //     ),
        //   ),
        // );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int sectionId = widget.sectionId;
    final int userId = AppSharedPreferences().getUserIdD() ?? 0;

    t = AppTranslations.of(context)!;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<SubCategoryCubit, SubCategoryState>(
            builder: (context, state) {
              final subCategories = state.subCategories;
              final companies = state.companyTypes;
              final ads = state.adsSection;
              final isLoading = state.status == SubCategoryStatus.loading;
              final isError = state.status == SubCategoryStatus.error;

              return isLoading && subCategories.isEmpty && companies.isEmpty
                  ? _buildLoadingShimmer()
                  : isError
                      ? _buildError(context, state.error)
                      : RefreshIndicator(
                          onRefresh: () async {
                            await _loadData();
                          },
                          child: CustomScrollView(
                            physics: const BouncingScrollPhysics(),
                            slivers: [
                              // Search Bar Section
                              const SliverToBoxAdapter(
                                  child: SizedBox(height: 16)),
                              SliverToBoxAdapter(
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xffe8e8e9),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: AppColors.primary,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        widget.title!,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SliverToBoxAdapter(
                                  child: SizedBox(height: 16)),
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: _buildSearchField(
                                      t.text('search.hint_property')),
                                ),
                              ),

                              const SliverToBoxAdapter(
                                  child: SizedBox(height: 10)),

                              // Banner Section
                              SliverToBoxAdapter(
                                child:
                                    BannerSection(sectionId: widget.sectionId),
                              ),
                              const SliverToBoxAdapter(
                                  child: SizedBox(height: 30)),

                              // Companies Section
                              if (companies.isNotEmpty)
                                SliverToBoxAdapter(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.grey.withOpacity(.1),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: CompaniesSection(
                                      companies: companies
                                          .map((c) => CompanyModel(
                                                id: c.id.toString(),
                                                name: c.name,
                                                logoUrl: c.image,
                                              ))
                                          .toList(),
                                      onCompanyTap: (company) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CompanyTypesCompanyScreen(
                                              companyId: company.id,
                                              title: company.name,
                                              sectionId: widget.sectionId,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 10),
                              ),

                              // Subcategories Section
                              if (subCategories.isNotEmpty ||
                                  (widget.sectionId == 1 &&
                                      (context
                                              .read<SubCategoryCubit>()
                                              .getSubCategoriesForSection(4)
                                              .isNotEmpty ||
                                          context
                                              .read<SubCategoryCubit>()
                                              .getSubCategoriesForSection(6)
                                              .isNotEmpty ||
                                          context
                                              .read<SubCategoryCubit>()
                                              .getSubCategoriesForSection(7)
                                              .isNotEmpty)))
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Builder(
                                      builder: (context) {
                                        final cubit = context
                                            .read<SubCategoryCubit>();

                                        // Combine main subcategories with special sections (4, 6, 7) for cars
                                        List<CategoryModel> allSubCategories =
                                            subCategories
                                                .map((s) => CategoryModel(
                                                      id: s.id,
                                                      name: s.name,
                                                      image: s.image,
                                                      sectionId:
                                                          widget.sectionId,
                                                    ))
                                                .toList();

                                        // Add subcategories from sections 4, 6, 7 for cars only
                                        if (widget.sectionId == 1) {
                                          final section4Cats = cubit
                                              .getSubCategoriesForSection(4);
                                          final section6Cats = cubit
                                              .getSubCategoriesForSection(6);
                                          final section7Cats = cubit
                                              .getSubCategoriesForSection(7);

                                          allSubCategories.addAll(section4Cats
                                              .map((s) => CategoryModel(
                                                    id: s.id,
                                                    name: s.name,
                                                    image: s.image,
                                                    sectionId: 4,
                                                  )));

                                          allSubCategories.addAll(section6Cats
                                              .map((s) => CategoryModel(
                                                    id: s.id,
                                                    name: s.name,
                                                    image: s.image,
                                                    sectionId: 6,
                                                  )));

                                          allSubCategories.addAll(section7Cats
                                              .map((s) => CategoryModel(
                                                    id: s.id,
                                                    name: s.name,
                                                    image: s.image,
                                                    sectionId: 7,
                                                  )));
                                        }

                                        return SubCategoryList(
                                          subCategories: allSubCategories,
                                          onCategoryTap: (cat) =>
                                              _handleCategoryNavigation(cat),
                                        );
                                      },
                                    ),
                                  ),
                                ),

                              // Empty State
                              if (subCategories.isEmpty &&
                                  companies.isEmpty &&
                                  ads.isEmpty)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Center(
                                      child: Text(
                                        t.text('common.no_data_available'),
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                    ),
                                  ),
                                ),

                              // Related Ads Section
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: RelatedAdsView(
                                    ads: ads,
                                    isLoading:
                                        state.status == SubCategoryStatus.loading,
                                    error: state.error,
                                    onRefresh: () => context
                                        .read<SubCategoryCubit>()
                                        .refreshRelatedAds(widget.sectionId),
                                    onLoadMore: () => context
                                        .read<SubCategoryCubit>()
                                        .loadMoreRelatedAds(widget.sectionId),
                                    sectionId: sectionId,
                                    userId: userId,
                                    embedded: true, // ✅ Let parent scroll
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
            },
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar(),
      ),
    );
  }
}