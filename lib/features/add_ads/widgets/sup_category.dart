import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/shared_widgets/emptywidget.dart';
import 'package:oreed_clean/features/add_ads/widgets/category_grid_tile.dart';
import 'package:oreed_clean/features/carform/presentation/pages/car_form_refactor.dart';
import 'package:oreed_clean/features/realstateform/presentation/pages/realstate_form.dart';
import 'package:oreed_clean/features/sub_subcategory/domain/cubit/sub_subcategory_cubit.dart';
import 'package:oreed_clean/features/sub_subcategory/domain/entities/sub_subcategory_entity.dart';

import '../../sub_category/data/models/categorymodel.dart';

class SupCategoryList extends StatefulWidget {
  final int categoryId;
  final int sectionId;

  const SupCategoryList({
    super.key,
    required this.categoryId,
    required this.sectionId,
  });

  @override
  State<SupCategoryList> createState() => _SupCategoryListState();
}

class _SupCategoryListState extends State<SupCategoryList> {
  String _query = '';
  final SearchController _searchController = SearchController();

  @override
  void initState() {
    super.initState();
    // Fetch data after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubSubcategoryCubit>().fetchSubSubcategories(
            widget.categoryId,
          );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await context.read<SubSubcategoryCubit>().fetchSubSubcategories(
          widget.categoryId,
        );
  }

  void _onCategoryPressed(SubSubcategoryEntity category) {
    if (widget.sectionId == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CarFormUI(
            sectionId: widget.sectionId,
            categoryId: widget.categoryId,
            supCategoryId: category.id,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RealEstateFormUI(
            sectionId: widget.sectionId,
            categoryId: widget.categoryId,
            supCategoryId: category.id,
          ),
        ),
      );
    }
  }

  Widget _buildSearchField(String hint) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _query = val.trim()),
        textAlign: isRTL ? TextAlign.right : TextAlign.left,
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: SizedBox(
            width: 20,
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);

    String tr(String key, String fallback) => appTrans?.text(key) ?? fallback;

    final titleText = tr('sub_sections', 'Sub sections');
    final searchHint = tr('search_category_hint', 'Search for a category...');
    final errorLabel = tr('error', 'Error');
    final unknownLabel = tr('unknown', 'Unknown');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),

            // Back Button
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffe8e8e9),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(6),
                child: Icon(Icons.arrow_back, color: AppColors.primary),
              ),
            ),

            const SizedBox(height: 10),
            
            // Title
            Text(
              titleText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 15),
            
            // Search Field
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(height: 45, child: _buildSearchField(searchHint)),
            ),

            // Body Section with BlocBuilder
            Expanded(
              child: BlocBuilder<SubSubcategoryCubit, SubSubcategoryState>(
                builder: (context, state) {
                  // Loading State
                  if (state.status == SubSubcategoryStatus.loading &&
                      state.subcategories.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Error State
                  if (state.status == SubSubcategoryStatus.error) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$errorLabel: ${state.errorMessage ?? unknownLabel}',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _refresh,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: Text(tr('retry', 'إعادة المحاولة')),
                          ),
                        ],
                      ),
                    );
                  }

                  // Filter categories based on search query
                  final all = state.subcategories;
                  final categories = _query.isEmpty
                      ? all
                      : all
                          .where(
                            (c) => (c.name ).toLowerCase().contains(
                                  _query.toLowerCase(),
                                ),
                          )
                          .toList();

                  // Empty State
                  if (categories.isEmpty) {
                    return Center(
                      child: emptyAdsView(
                        visible: false,
                        context: context,
                        button: tr('explore_ads', 'استكشاف الإعلانات'),
                        image: AppIcons.emptyAds,
                        title: tr('no_categories_available', 
                            'لا توجد أقسام متاحة حاليًا'),
                        subtitle: tr('no_categories_subtitle',
                            'لا توجد أقسام مطابقة لاختياراتك حاليًا. جرّب تغيير البحث أو المحاولة لاحقًا.'),
                        onAddPressed: () {
                          Navigator.pushNamed(context, Routes.homelayout);
                        },
                      ),
                    );
                  }

                  // Success State - Grid View
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: categories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.1,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return CategoryGridTile(
                          item: CategoryModel(
                            id: category.id,
                            name: category.name,
                            image: category.image,
                          ),
                          onTap: () => _onCategoryPressed(category),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}