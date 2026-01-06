import 'package:flutter/material.dart';
import 'package:oreed_clean/features/home/domain/entities/category_entity.dart';
import 'package:oreed_clean/features/home/presentation/widgets/category_item.dart';

class CategoriesGrid extends StatelessWidget {
  final List<CategoryEntity> categories;
  final bool isTablet;

  const CategoriesGrid({
    super.key,
    required this.categories,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 6 : 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        return CategoryItem(category: categories[index]);
      },
    );
  }
}
