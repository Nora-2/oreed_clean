import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/home/domain/entities/banner_entity.dart';

class BannerCarousel extends StatefulWidget {
  final List<BannerEntity> banners;
  final bool isTablet;

  const BannerCarousel({
    super.key,
    required this.banners,
    required this.isTablet,
  });

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;

  double get _height => widget.isTablet ? 220 : 180;

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    final hasMultiple = widget.banners.length > 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ===== Carousel =====
        ClipRect(
          child: SizedBox(
            width: double.infinity,
            height: _height,
            child: CarouselSlider.builder(
              itemCount: widget.banners.length,
              carouselController: _controller,
              options: CarouselOptions(
                height: _height,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                padEnds: false,
                clipBehavior: Clip.hardEdge,
                autoPlay: hasMultiple,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration:
                    const Duration(milliseconds: 650),
                autoPlayCurve: Curves.easeInOut,
                enableInfiniteScroll: hasMultiple,
                scrollPhysics: hasMultiple
                    ? const PageScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                onPageChanged: (index, _) {
                  setState(() => _currentIndex = index);
                },
              ),
              itemBuilder: (context, index, _) {
                final banner = widget.banners[index];
                return _BannerItem(
                  imageUrl: banner.image,
                );
              },
            ),
          ),
        ),

        if (hasMultiple) const SizedBox(height: 10),

        // ===== Dots Indicator =====
        if (hasMultiple)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.banners.length, (index) {
              final isActive = _currentIndex == index;
              return GestureDetector(
                onTap: () => _controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                ),
                
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 6,
                  width:  11, 
      decoration: BoxDecoration(
        color:isActive? AppColors.secondary:AppColors.secondary.withOpacity(.5), // نفس لون الصورة
        borderRadius: BorderRadius.circular(20),
      ),
                ),
              );
            }),
          ),
      ],
    );
  }
}
class _BannerItem extends StatelessWidget {
  final String imageUrl;

  const _BannerItem({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.secondary),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => Container(
          width: double.infinity,
          color: Colors.grey.shade200,
          child: const Icon(Icons.image, size: 40),
        ),
      ),
    );
  }
}
