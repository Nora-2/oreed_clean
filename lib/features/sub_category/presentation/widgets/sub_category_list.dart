import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/sub_category/presentation/widgets/sub_category_card.dart';
import '../../data/models/categorymodel.dart';

class SubCategoryList extends StatelessWidget {
  final List<CategoryModel> subCategories;
  final String title;
  final void Function(CategoryModel cat)? onCategoryTap;
  final bool showTitle;

  const SubCategoryList({
    super.key,
    required this.subCategories,
    this.title = 'الفئات',
    this.onCategoryTap,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    if (subCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    final t = AppTranslations.of(context);
    final String displayTitle = (title == 'الفئات')
        ? (t?.text('subcategories.title') ?? 'الفئات')
        : title;
    return LayoutBuilder(builder: (context, constraints) {
// عرض تقريبي للكارت

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 4, bottom: 8),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.secondary),
                    height: 20,
                    width: 3,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    displayTitle,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.black,
                          fontSize: 18,
                        ),
                  ),
                ],
              ),
            ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // 4 عناصر في الصف كما في الصورة
              crossAxisSpacing: 5, // مسافة بين الكروت
              mainAxisSpacing: 8,
              mainAxisExtent: 90,
              // زيادة الارتفاع قليلاً لاستيعاب الصورة والنص
            ),
            itemCount: subCategories.length,
            itemBuilder: (_, i) {
              final cat = subCategories[i];
              return SubCategoryCard(
                category: cat,
                onTap: onCategoryTap == null ? null : () => onCategoryTap!(cat),
              );
            },
          ),
        ],
      );
    });
  }
}
