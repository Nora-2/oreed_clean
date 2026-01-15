import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

class AnimatedCompanyGridCard extends StatelessWidget {
  const AnimatedCompanyGridCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.onTap,
  });

  final String title;
  final String imageUrl;
  final VoidCallback? onTap;

  static const double _borderRadius = 10.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(_borderRadius),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔹 Image Container with Light Blue Tint
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFA3BCFD).withOpacity(.1),
                borderRadius: BorderRadius.circular(_borderRadius),
                border: Border.all(color: AppColors.grey.withOpacity(.3)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_borderRadius),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.fill, // Ensures the full logo is visible
                  placeholder: (context, url) => const Center(
                    child: Icon(
                      Icons.business,
                      size: 30,
                      color: Colors.black12,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(
                      Icons.business,
                      size: 30,
                      color: Colors.black12,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 Title Styled to match CompanyCard
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A4A4A),
              height: 1.2,
              fontFamily: 'Almarai',
            ),
          ),
        ],
      ),
    );
  }
}
