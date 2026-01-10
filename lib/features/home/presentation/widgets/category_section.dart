import 'package:flutter/material.dart';
import 'package:oreed_clean/features/home/domain/entities/section_entity.dart';
import 'package:oreed_clean/features/home/presentation/widgets/category_grid.dart';


/// 📦 Static category grid
class CategorySection extends StatelessWidget {
  const CategorySection({super.key, required this.categories});

  final List<SectionEntity> categories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: CategoryGrid(categories: categories),
    );
  }
}
