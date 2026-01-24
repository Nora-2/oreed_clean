import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/features/anythingform/presentation/screen/any_thing_form.dart';
import 'package:oreed_clean/features/carform/presentation/pages/car_form_refactor.dart';
import 'package:oreed_clean/features/home/domain/entities/section_entity.dart';
import 'package:oreed_clean/features/mainlayout/presentation/cubit/mainlayout_cubit.dart';
import 'package:oreed_clean/features/sub_category/domain/entities/sub_category_entity.dart';
import 'package:oreed_clean/features/sub_category/presentation/cubit/sub_category_cubit.dart';
import 'package:oreed_clean/features/technicalforms/presentation/pages/technican_form_ui.dart';
import 'package:shimmer/shimmer.dart';
import 'sup_category.dart';

class MainList extends StatefulWidget {
  final int sectionId;
  final List<SectionEntity> sections;

  const MainList({super.key, required this.sectionId, required this.sections});

  @override
  State<MainList> createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  // To track selection
  SubCategoryEntity? _selectedCategory;
  int? _selectedCategoryFromSectionId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final cubit = context.read<SubCategoryCubit>();

    // Fetch for main section
    await cubit.fetchSectionCategory(widget.sectionId);

    // Fetch subcategories for special sections (4, 6, 7) only for cars (sectionId == 1)
    if (widget.sectionId == 1) {
      for (final section in widget.sections) {
        if (section.id == 4 || section.id == 6 || section.id == 7) {
          await cubit.fetchSectionCategory(section.id);
        }
      }
    }
  }

  void _onNextPressed() {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppTranslations.of(context)?.text('please_select_appropriate_type') ??
                'يرجى اختيار القسم الفرعي أولاً',
          ),
        ),
      );
      return;
    }

    // Use the captured section ID or fallback to widget.sectionId
    final targetSectionId = _selectedCategoryFromSectionId ?? widget.sectionId;

    if (targetSectionId == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SupCategoryList(
            categoryId: _selectedCategory!.id,
            sectionId: targetSectionId,
          ),
        ),
      );
    } else if (targetSectionId == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TechnicianFormUI(
            categoryId: _selectedCategory!.id,
            sectionID: targetSectionId,
          ),
        ),
      );
    } else if (targetSectionId == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CarFormUI(
            sectionId: targetSectionId,
            categoryId: _selectedCategory!.id,
            supCategoryId: _selectedCategory!.id == 12 ? 1 : 2,
          ),
        ),
      );
    } else {
      // For sections 4, 6, 7 and any other sections
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnythingForm(
            categoryId: _selectedCategory!.id,
            sectionId: targetSectionId,
            supCategoryId: _selectedCategory!.id,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);
    String tr(String key, String fallback) => appTrans?.text(key) ?? fallback;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: BlocBuilder<SubCategoryCubit, SubCategoryState>(
          builder: (context, state) {
            // Prepare list of sections to check status/data
            final sectionsToDisplay = [
              (
                id: widget.sectionId,
                name: appTrans?.text('section_${widget.sectionId}') ?? 'Section'
              ),
              if (widget.sectionId == 1)
                ...widget.sections
                    .where((s) => s.id == 4 || s.id == 6 || s.id == 7)
                    .map((s) => (id: s.id, name: s.name))
                    .toList(),
            ];

            // Check loading status
            bool isLoading = false;
            for (final section in sectionsToDisplay) {
              if (context.read<SubCategoryCubit>().getStatusForSection(section.id) ==
                  SubCategoryStatus.loading) {
                isLoading = true;
                break;
              }
            }

            // Collect Data
            List<SubCategoryEntity> allCategories = [];
            for (final section in sectionsToDisplay) {
              final sectionCats = context
                  .read<SubCategoryCubit>()
                  .getSubCategoriesForSection(section.id);
              allCategories.addAll(sectionCats);
            }
            final isRTL = Directionality.of(context) == TextDirection.rtl;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // --- Header ---
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        // Back Button
                        GestureDetector(
                          onTap: () {
                            context.read<HomelayoutCubit>().changeTabIndex(0);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              Routes.homelayout,
                              (route) => false,
                              arguments: 1,
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
                        Text(
                          tr('choose_sub_category_for_ad',
                              'اختر القسم الفرعي لإعلانك'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Search
                        _buildSearchField(
                          tr('search_for_sub_category', 'ابحث عن القسم الفرعي'),
                        ),
                        const SizedBox(height: 25),
                        // Label
                        Row(
                          textDirection: isRTL
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                          mainAxisAlignment: isRTL
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.end,
                          children: [
                            Text(
                              tr('sub_category', 'القسم الفرعي '),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 3,
                              height: 18,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),

                // --- Grid Content ---
                if (isLoading && allCategories.isEmpty)
                  _buildSliverShimmer()
                else if (allCategories.isEmpty)
                  SliverToBoxAdapter(
                    child: _buildEmptyState(tr),
                  )
                else
                  _buildSliverGrid(allCategories, sectionsToDisplay, state),

                // --- Bottom Padding for button ---
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      ),
      // Floating Button Area
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 50),
        child: CustomButton(
          text: tr('complete_ad_details', 'أكمل تفاصيل الأعلان'),
          onTap: _onNextPressed,
        ),
      ),
    );
  }

  String tr(String key, String fallback) {
    final appTrans = AppTranslations.of(context);
    return appTrans?.text(key) ?? fallback;
  }

  Widget _buildSearchField(String hint) {
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
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 13),
          prefixIcon: SizedBox(
            width: 20,
            height: 20,
            child: Center(
              child: SvgPicture.asset(
                'assets/svg/search.svg',
                width: 14,
                height: 14,
                placeholderBuilder: (_) =>
                    const Icon(Icons.search, size: 20, color: Colors.grey),
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

  Widget _buildSliverGrid(
    List<SubCategoryEntity> allCategories,
    List<({int id, String name})> sectionsToDisplay,
    SubCategoryState state,
  ) {
    final filtered = _query.isEmpty
        ? allCategories
        : allCategories
            .where((c) => c.name.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    if (filtered.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(tr('no_search_results', "لا توجد نتائج بحث")),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.2,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final category = filtered[index];
            final isSelected = _selectedCategory?.id == category.id;

            return GestureDetector(
              onTap: () {
                // Find source section ID for this category
                int? sourceSectionId;
                for (final section in sectionsToDisplay) {
                  final sectionCats = context
                      .read<SubCategoryCubit>()
                      .getSubCategoriesForSection(section.id);
                  if (sectionCats.contains(category)) {
                    sourceSectionId = section.id;
                    break;
                  }
                }

                setState(() {
                  _selectedCategory = category;
                  _selectedCategoryFromSectionId = sourceSectionId;
                });
                _onNextPressed();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE8F0FE) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
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
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      flex: 2,
                      child: Text(
                        category.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
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
          childCount: filtered.length,
        ),
      ),
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

  Widget _buildEmptyState(String Function(String, String) tr) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: .1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.folder_open, size: 60, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Text(
            tr('no_categories_available', 'لا توجد أقسام متاحة حالياً'),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}