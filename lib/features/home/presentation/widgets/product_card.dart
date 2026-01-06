import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/core/utils/appstring/app_string.dart';
import 'package:oreed_clean/features/home/domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final bool isTablet;

  const ProductCard({
    super.key,
    required this.product,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: isTablet ? 250 : 180, // Wider card to match proportions
      margin: const EdgeInsets.only(left: 4, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), // Highly rounded corners
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end, // RTL support
        children: [
          Stack(
            children: [
              // 1. Product Image
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                  child: Image.network(
                    product.image,
                    height: isTablet ? 180 : 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: isTablet ? 180 : 150,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),

              PositionedDirectional(
                top: 10,
                end: 10,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: const BoxDecoration(
                    color: AppColors.neutral50,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    AppIcons.favourite,
                    width: 18,
                    height: 18,
                  ),
                ),
              ),
              // 3. Featured Badge (Top Right)
              PositionedDirectional(
                top: 10,
                start: 10,
                child: Row(
                  children: [
                    SvgPicture.asset(AppIcons.spacific, width: 25, height: 25),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xff8133F1), // Purple from image
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        AppTranslations.of(context)!.text(AppString.specific),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 4. Stats Overlay (Bottom Right of Image)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Appimage.timeviewcurve),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Row(
                    textDirection: TextDirection.ltr,
                    children: [
                      const Text(
                        '822',
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                      const SizedBox(width: 4),
                      SvgPicture.asset(
                        AppIcons.eyeActive,
                        width: 8,
                        height: 8,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'منذ 6 أيام',
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                      const SizedBox(width: 4),
                      SvgPicture.asset(AppIcons.loadingTime,width: 8,height: 8,)
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Product Details Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  product.name,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isTablet ? 19 : 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 3),
                // Location Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      AppIcons.locationPin,
                      width: 14,
                      height: 14,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${product.government}, ${product.city}',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // Price
                Text(
                  '${product.price.toStringAsFixed(0)} ${AppTranslations.of(context)!.text(AppString.priceCoin)}',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: isTablet ? 22 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                // Full-width Button
                SizedBox(
                  width: double.infinity,
                  height: isTablet ? 45 : 35,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    child: Text(
                      AppTranslations.of(context)!.text(AppString.viewAd),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

