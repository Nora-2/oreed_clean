import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/shared_widgets/route_observer.dart';
import 'package:oreed_clean/core/utils/shared_widgets/shimmer.dart';
import 'package:oreed_clean/features/companydetails/presentation/widgets/related_ads_view.dart';
import 'package:oreed_clean/features/sub_category/presentation/widgets/custom_bottom_nav.dart';
import 'package:oreed_clean/features/sub_subcategory/domain/cubit/sub_subcategory_cubit.dart';
import 'package:oreed_clean/features/sub_subcategory/presentation/widgets/adcarousel.dart';
import '../../../sub_category/data/models/categorymodel.dart';
import '../../../sub_category/presentation/widgets/sub_category_list.dart';

class SubCategoryIntroScreen extends StatefulWidget {
  final int categoryId;
  final int sectionId;
  final String title;
  final String? searchText;

  const SubCategoryIntroScreen({
    super.key,
    required this.categoryId,
    required this.sectionId,
    required this.title,
    this.searchText,
  });

  @override
  State<SubCategoryIntroScreen> createState() => _SubCategoryIntroScreenState();
}

class _SubCategoryIntroScreenState extends State<SubCategoryIntroScreen>
    with RouteAware {
  final TextEditingController _searchController = TextEditingController();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchText ?? '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      routeObserver.subscribe(this, ModalRoute.of(context)!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadData();
      });
    }
  }

  /// Load initial data
  void _loadData() {
    final cubit = context.read<SubSubcategoryCubit>();

    // Only fetch subcategories if not coming from search
    if (widget.searchText == null) {
      cubit.fetchSubSubcategories(widget.categoryId);
    }

    cubit.fetchAds(
      sectionId: widget.sectionId,
      subCategoryId: widget.categoryId,
      searchText: widget.searchText,
    );
  }

  /// Refresh data
  Future<void> _onRefresh() async {
    final cubit = context.read<SubSubcategoryCubit>();

    if (widget.searchText == null) {
      await cubit.fetchSubSubcategories(widget.categoryId);
    }

    await cubit.fetchAds(
      sectionId: widget.sectionId,
      subCategoryId: widget.categoryId,
      searchText: widget.searchText,
    );
  }

  /// Perform search with query
  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    context.read<SubSubcategoryCubit>().fetchAds(
          sectionId: widget.sectionId,
          subCategoryId: widget.categoryId,
          searchText: query.trim(),
        );
  }

  @override
  void didPopNext() {
    final cubit = context.read<SubSubcategoryCubit>();

    if (widget.searchText == null) {
      cubit.fetchSubSubcategories(widget.categoryId);
    }

    cubit.fetchAds(
      sectionId: widget.sectionId,
      subCategoryId: widget.categoryId,
      searchText: widget.searchText,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  /// Build search bar widget
  Widget _buildSearchField(String hint) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (text) {
          _searchController.text = text;
        },
        onSubmitted: (text) {
          _performSearch(text);
        },
        textAlign: isRTL ? TextAlign.right : TextAlign.left,
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: GestureDetector(
            onTap: () async {},
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xffE8E8E9),
                borderRadius: BorderRadius.circular(30),
              ),
              child: SvgPicture.asset(AppIcons.filter),
            ),
          ),
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          prefixIcon: SizedBox(
            width: 14,
            height: 20,
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
              const EdgeInsets.symmetric(horizontal: 5, vertical: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);
    final int sectionId = widget.sectionId;
    final int userId = AppSharedPreferences().getUserIdD() ?? 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<SubSubcategoryCubit, SubSubcategoryState>(
        builder: (context, state) {
          // Loading State
          if (state.status == SubSubcategoryStatus.loading &&
              state.subcategories.isEmpty &&
              state.ads.isEmpty) {
            return _SubCategoryIntroShimmerLoading(
              searchText: widget.searchText,
            );
          }

          // Error State
          if (state.status == SubSubcategoryStatus.error) {
            final t = AppTranslations.of(context);
            return SafeArea(
              child: Center(
                child: ElevatedButton(
                  onPressed: _onRefresh,
                  child: Text(t?.text('tryAgain') ?? 'حاول مرة أخرى'),
                ),
              ),
            );
          }

          final subcategories = state.subcategories;
          final ads = state.ads;

          // Success State
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Search Bar Section
                const SliverToBoxAdapter(child: SizedBox(height: 36)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffe8e8e9),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.arrow_back,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: _buildSearchField(
                      t?.text('search.hint_property') ?? 'ابحث عن ما تريد',
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Banner Section (Optional)
                if (ads.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          AdCarouselSlider(adsList: []),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                // Subcategories Section (hide when coming from search)
                if (subcategories.isNotEmpty && widget.searchText == null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SubCategoryList(
                            subCategories: subcategories
                                .map(
                                  (s) => CategoryModel(
                                    id: s.id,
                                    name: s.name,
                                    image: s.image,
                                  ),
                                )
                                .toList(),
                            showTitle: false,
                            onCategoryTap: (cat) async {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => PropertyFilterScreen(
                              //       sectionId: widget.sectionId,
                              //       subCategoryId: cat.id!,
                              //       subtitel: widget.title,
                              //       title: cat.name!,
                              //       categoryId: widget.categoryId,
                              //     ),
                              //   ),
                              // );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // Related Ads Section
                SliverToBoxAdapter(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: RelatedAdsView(
                      ads: ads,
                      isLoading: state.status == SubSubcategoryStatus.loading,
                      error: state.errorMessage,
                      onRefresh: _onRefresh,
                      onLoadMore: () async {
                        await context.read<SubSubcategoryCubit>().fetchAds(
                              sectionId: widget.sectionId,
                              subCategoryId: widget.categoryId,
                              searchText: widget.searchText,
                            );
                      },
                      sectionId: sectionId,
                      userId: userId,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

// ===================== Shimmer Loading Widget =====================
class _SubCategoryIntroShimmerLoading extends StatelessWidget {
  final String? searchText;

  const _SubCategoryIntroShimmerLoading({this.searchText});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          // Top spacing
          const SliverToBoxAdapter(child: SizedBox(height: 36)),

          // Search Bar Shimmer
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  // Back button shimmer
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const ShimmerBox(
                      width: 48,
                      height: 48,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Search bar shimmer
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.2)),
                      ),
                      child: const ShimmerBox(
                        height: 48,
                        width: double.infinity,
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Banner Shimmer with Dots
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const ShimmerBox(
                        height: 200,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Dots indicator shimmer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        child: const ShimmerBox(
                          width: 8,
                          height: 8,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Subcategories Shimmer (hide when coming from search)
          if (searchText == null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section Title
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerBox(
                          height: 20,
                          width: 120,
                        ),
                        ShimmerBox(
                          height: 16,
                          width: 60,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Grid of subcategories
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                child: ShimmerBox(
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: ShimmerBox(
                                  width: double.infinity,
                                  height: 10,
                                ),
                              ),
                              SizedBox(height: 4),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: ShimmerBox(
                                  width: double.infinity,
                                  height: 10,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

          // Related Ads Section Header
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerBox(
                    height: 24,
                    width: 150,
                  ),
                  Row(
                    children: [
                      ShimmerBox(
                        width: 32,
                        height: 32,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      SizedBox(width: 8),
                      ShimmerBox(
                        width: 32,
                        height: 32,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Related Ads Grid Shimmer
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _AdCardShimmer();
                },
                childCount: 6,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

// Separate widget for ad card shimmer for better reusability
class _AdCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image shimmer with badge overlay
          Stack(
            children: [
              const ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                child: ShimmerBox(
                  height: 150,
                  width: double.infinity,
                ),
              ),
              // Views badge shimmer
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const ShimmerBox(
                    width: 40,
                    height: 12,
                  ),
                ),
              ),
            ],
          ),

          // Content shimmer
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title shimmer (2 lines)
                  const ShimmerBox(
                    height: 18,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 6),
                  const ShimmerBox(
                    height: 18,
                    width: 140,
                  ),

                  const Spacer(),

                  // Price row shimmer
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const ShimmerBox(
                          width: 20,
                          height: 20,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const ShimmerBox(
                        height: 20,
                        width: 90,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Location row shimmer
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const ShimmerBox(
                          width: 16,
                          height: 16,
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const ShimmerBox(
                        height: 14,
                        width: 100,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Date row shimmer
                  Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const ShimmerBox(
                          width: 14,
                          height: 14,
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const ShimmerBox(
                        height: 12,
                        width: 80,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}