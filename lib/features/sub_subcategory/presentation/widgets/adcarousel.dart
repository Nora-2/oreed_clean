import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/home/data/models/ad_model.dart';
import 'package:oreed_clean/features/sub_subcategory/presentation/widgets/adbanner_tile.dart';

class AdCarouselSlider extends StatefulWidget {
  final List<AdModel> adsList;
  const AdCarouselSlider({super.key, required this.adsList});

  @override
  State<AdCarouselSlider> createState() => _AdCarouselSliderState();
}

class _AdCarouselSliderState extends State<AdCarouselSlider> {
  // ✅ الإصدار الجديد v5
  final CarouselSliderController _controller = CarouselSliderController();
  int _current = 0;

  static const double _cardHeight = 170.0;

  @override
  Widget build(BuildContext context) {
    if (widget.adsList.isEmpty) return const SizedBox.shrink();

    final hasMultiple = widget.adsList.length > 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRect(
          child: SizedBox(
            width: double.infinity,
            height: _cardHeight,
            child: CarouselSlider.builder(
              itemCount: widget.adsList.length,
              carouselController: _controller, // ✅ النوع الجديد
              options: CarouselOptions(
                height: _cardHeight,
                viewportFraction: 1.0, // ياخد العرض كامل
                enlargeCenterPage: false,
                padEnds: false,
                clipBehavior: Clip.hardEdge,
                autoPlay: hasMultiple,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 650),
                autoPlayCurve: Curves.easeInOut,
                enableInfiniteScroll: hasMultiple,
                scrollPhysics: hasMultiple
                    ? const PageScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                onPageChanged: (i, _) => setState(() => _current = i),
              ),
              itemBuilder: (context, index, realIdx) {
                final ad = widget.adsList[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: AdBannerTile(adItem: ad, height: _cardHeight),
                );
              },
            ),
          ),
        ),

        if (hasMultiple) const SizedBox(height: 10),

        // ••• Dots Indicator •••
        if (hasMultiple)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.adsList.length, (i) {
              final bool isActive = _current == i;
              return GestureDetector(
                onTap: () => _controller.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? AppColors.secondary
                        : Colors.black.withOpacity(0.3),
                  ),
                ),
              );
            }),
          ),
      ],
    );
  }
}
