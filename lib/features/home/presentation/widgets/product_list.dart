import 'package:flutter/material.dart';
import 'package:oreed_clean/features/home/domain/entities/product_entity.dart';
import 'package:oreed_clean/features/home/presentation/widgets/product_card.dart';

class ProductsHorizontalList extends StatelessWidget {
  final List<ProductEntity> products;
  final bool isTablet;

  const ProductsHorizontalList({
    super.key,
    required this.products,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (_, i) => ProductCard(
          product: products[i],
          isTablet: isTablet,
        ),
      ),
    );
  }
}
