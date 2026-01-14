// lib/view/screens/details_ads/widgets/image_header.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/addetails/presentation/widgets/full_screen_gallery.dart';

class ImageHeader extends StatelessWidget {
  final List<String> images;
  final int activeIndex;
  final ValueChanged<int> onChanged;
  final String heroTagPrefix;
  final double bottomRadius;

  const ImageHeader({
    super.key,
    required this.images,
    required this.activeIndex,
    required this.onChanged,
    required this.heroTagPrefix,
    this.bottomRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(bottomRadius),
      ),
      child: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            onPageChanged: onChanged,
            itemBuilder: (_, i) => GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FullScreenGalleryView(
                      images: images,
                      initialIndex: i,
                      heroTagPrefix: heroTagPrefix,
                    ),
                  ),
                );
              },
              child: Hero(
                tag: '$heroTagPrefix-$i',
                child: CachedNetworkImage(
                  imageUrl: images[i],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // مؤشر نقاط
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (i) {
                final isActive = i == activeIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 3,
                  width: 8,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.secondary : AppColors.primary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
