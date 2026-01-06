import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appstring/app_string.dart';
import 'package:oreed_clean/features/home/presentation/cubit/home_cubit.dart';
import 'package:oreed_clean/features/home/presentation/widgets/bannar_cersoral.dart';
import 'package:oreed_clean/features/home/presentation/widgets/categories_grid.dart';
import 'package:oreed_clean/features/home/presentation/widgets/home_header.dart';
import 'package:oreed_clean/features/home/presentation/widgets/product_list.dart';
import 'package:oreed_clean/features/home/presentation/widgets/seaction_header.dart';

class HomeContent extends StatelessWidget {
  final HomeLoaded state;

  const HomeContent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
  final appTrans = AppTranslations.of(context);

    return Column(
      children: [
        HomeHeader(isTablet: isTablet),
    
        BannerCarousel(
          banners: state.banners,
          isTablet: isTablet,
        ),
    
        const SizedBox(height: 16),
     Padding(
       padding: const EdgeInsets.symmetric(horizontal: 8.0),
       child: Row(
                              children: [
                                Container(
                                  width: 3,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    // Orange accent
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    appTrans?.text('discover_sections') ??
                                        'اكتشف الأقسام',
                                    style:  TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
     ),
                        
        CategoriesGrid(
          categories: state.categories,
          isTablet: isTablet,
        ),
    
        const SizedBox(height: 16),
    
        SectionHeader(
          title: AppTranslations.of(context)!.text(AppString.cars),
          isTablet: isTablet,
        ),
    const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ProductsHorizontalList(
            products: state.products
                .where((p) => p.category == 'سيارات')
                .toList(),
            isTablet: isTablet,
          ),
        ),
    
        const SizedBox(height: 16),
    
        SectionHeader(
          title: AppTranslations.of(context)!.text(AppString.realEstate),
          isTablet: isTablet,
        ),
    
        ProductsHorizontalList(
          products: state.products
              .where((p) => p.category == 'عقارات')
              .toList(),
          isTablet: isTablet,
        ),
    
        const SizedBox(height: 80),
      ],
    );
  }
}
