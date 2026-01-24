import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/features/account_type/presentation/pages/account_type_screen.dart';

import 'package:oreed_clean/features/add_ads/widgets/main_list.dart';
import 'package:oreed_clean/features/home/domain/entities/section_entity.dart';
import 'package:oreed_clean/features/home/presentation/cubit/home_cubit.dart';
import 'package:shimmer/shimmer.dart';

class HomeAddAds extends StatefulWidget {
  const HomeAddAds({
    super.key,
  });

  @override
  State<HomeAddAds> createState() => _HomeAddAdsState();
}

class _HomeAddAdsState extends State<HomeAddAds> {
  bool _hasOpenedSheet = false;

  @override
  void initState() {
    super.initState();
    _checkAuthAndOpen();
  }

  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController scroll = ScrollController();
  String _query = '';
  int? _selectedSectionId;

  @override
  void dispose() {
    _searchCtrl.dispose();
    scroll.dispose();
    super.dispose();
  }

  Future<void> _checkAuthAndOpen() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_hasOpenedSheet) return;
      _hasOpenedSheet = true;

      final prefs = AppSharedPreferences();
      await prefs.initSharedPreferencesProp();
      final userToken = prefs.getUserToken ?? '';
      final userId = prefs.getUserId ?? 0;
      bool isLoggedIn = userToken.isNotEmpty && userId != 0;

      if (!mounted) return;

      if (!isLoggedIn) {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AccountTypePage()),
        );

        await prefs.initSharedPreferencesProp();
        final newToken = prefs.getUserToken ?? '';
        if (newToken.isNotEmpty) {
          isLoggedIn = true;
        } else {
          return;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textDir = Directionality.of(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          child: BlocBuilder<MainHomeCubit, MainHomeState>(
            builder: (context, state) {
              return CustomScrollView(
                controller: scroll,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back button
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                Routes.homelayout,
                                arguments: Icons.face_2_outlined,
                                (_) => false,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffe8e8e9),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.all(6),
                              child: Icon(
                                Icons.arrow_back,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Title
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              AppTranslations.of(context)
                                      ?.text('choose_main_section_for_ad') ??
                                  'اختر القسم الرئيسي لإعلانك',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildSearchField(),
                          const SizedBox(height: 25),
                          // Section header
                          Row(
                            textDirection: textDir,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 3,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                AppTranslations.of(context)
                                        ?.text('main_section') ??
                                    'القسم الرئيسي',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                  // Content based on status
                  switch (state.status) {
                    HomeStatus.loading => _buildSliverShimmer(),
                    HomeStatus.error => SliverToBoxAdapter(
                        child: _buildErrorState(
                          state.errorMessage ??
                              (AppTranslations.of(context)
                                      ?.text('something_wrong') ??
                                  "حدث خطأ ما"),
                          () => context.read<MainHomeCubit>().fetchHomeData(),
                        ),
                      ),
                    HomeStatus.success => _buildSliverGrid(state),
                    _ => const SliverToBoxAdapter(child: SizedBox.shrink()),
                  },
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 30,
                      ),
                      child: _buildNextButton(state),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 60),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (val) => setState(() => _query = val.trim()),
        textAlign: isRTL ? TextAlign.right : TextAlign.left,
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        decoration: InputDecoration(
          hintText: AppTranslations.of(context)?.text('add_ad_search_hint') ??
              'ابحث عن سيارات، عقارات، إلكترونيات...',
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 13),
          prefixIcon: SizedBox(
            width: 20,
            height: 20,
            child: Center(
              child: SvgPicture.asset(
                'assets/svg/search.svg',
                width: 14,
                height: 14,
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSliverGrid(MainHomeState state) {
    if (state.sections.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Text(
            AppTranslations.of(context)?.text('no_sections') ?? 'لا توجد أقسام',
          ),
        ),
      );
    }

    final List<SectionEntity> filtered = _query.isEmpty
        ? state.sections
        : state.sections
            .where((s) => s.name.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    if (filtered.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Text(
            AppTranslations.of(context)?.text('no_results') ?? 'لا توجد نتائج',
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final data = filtered
                .where((category) =>
                    category.id != 4 && category.id != 6 && category.id != 7)
                .toList();

            final category = data[index];
            final isSelected = _selectedSectionId == category.id;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSectionId = category.id;
                });

                if (_selectedSectionId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppTranslations.of(context)
                                ?.text('please_select_main_section_first') ??
                            'يرجى اختيار القسم الرئيسي أولاً',
                      ),
                    ),
                  );
                  return;
                }

                final selectedCategory = state.sections
                    .firstWhere((s) => s.id == _selectedSectionId);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MainList(
                      sectionId: selectedCategory.id,
                      sections: state.sections
                          .where((item) =>
                              item.id == 7 || item.id == 4 || item.id == 6)
                          .toList(),
                    ),
                  ),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE8F0FE) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1A46C4)
                        : Colors.grey.shade300,
                    width: 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF1A46C4).withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : [],
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Image.network(
                        category.image,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      flex: 2,
                      child: Text(
                        category.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFF1A46C4)
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: filtered
              .where((category) =>
                  category.id != 4 && category.id != 6 && category.id != 7)
              .toList()
              .length,
        ),
      ),
    );
  }

  Widget _buildNextButton(MainHomeState state) {
    return CustomButton(
      text: AppTranslations.of(context)?.text('complete_sub_section') ??
          'أكمل القسم الفرعي',
      onTap: () {
        if (_selectedSectionId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppTranslations.of(context)
                        ?.text('please_select_main_section_first') ??
                    'يرجى اختيار القسم الرئيسي أولاً',
              ),
            ),
          );
          return;
        }

        final selectedCategory =
            state.sections.firstWhere((s) => s.id == _selectedSectionId);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MainList(
              sectionId: selectedCategory.id,
              sections: state.sections
                  .where((item) => item.id == 7 || item.id == 4 || item.id == 6)
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSliverShimmer() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          },
          childCount: 9,
        ),
      ),
    );
  }

  Widget _buildErrorState(String message, VoidCallback onRetry) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 40, color: Colors.grey),
            const SizedBox(height: 10),
            Text(message, style: const TextStyle(color: Colors.grey)),
            TextButton(
              onPressed: onRetry,
              child: Text(
                AppTranslations.of(context)?.text('common.retry') ??
                    "إعادة المحاولة",
              ),
            ),
          ],
        ),
      ),
    );
  }
}