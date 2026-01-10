import 'package:flutter/material.dart';
import 'package:oreed_clean/features/home/domain/entities/section_entity.dart';
import 'package:oreed_clean/features/home/presentation/widgets/category_item.dart';


class CategoryGrid extends StatelessWidget {
  final List<SectionEntity> categories;

  const CategoryGrid({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    // Filter out categories with IDs 4, 6, and 7
    final filteredCategories = categories
        .where((category) =>
            category.id != 4 && category.id != 6 && category.id != 7)
        .toList();

    return OrientationBuilder(
      builder: (context, orientation) {
        final width = MediaQuery.of(context).size.width;

        final cross = width > 600 ? 5 : 3;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 8),
          itemCount: filteredCategories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cross,
            childAspectRatio: 1.5,
            crossAxisSpacing: 4,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (_, index) {
            final category = filteredCategories[index];
            return CategoryItem(
              category: category,
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => SubCategoriesScreen(
                //       sectionId: category.id,
                //       title: category.name,
                //     ),
                //   ),
                // );
              },
            );
          },
        );
      },
    );
  }
}
