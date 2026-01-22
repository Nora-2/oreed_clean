import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Added
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/shared_widgets/shimmer.dart';
import 'package:oreed_clean/features/banners/domain/entities/banner_entity.dart'; // Ensure this is imported
import 'package:oreed_clean/features/banners/presentation/cubit/banners_cubit.dart'; // Path to your Cubit
import 'package:oreed_clean/features/banners/presentation/cubit/banners_state.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerSection extends StatefulWidget {
  final int? sectionId;

  const BannerSection({super.key, required this.sectionId});

  @override
  State<BannerSection> createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    // The Cubit internal logic handles whether to use cache or fetch from API
    context.read<BannerCubit>().fetchBanners(widget.sectionId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerCubit, BannerState>(
      builder: (context, state) {
        // Look up section-specific banners from the Cubit's state map
        final sectionBanners = state.sectionBanners[widget.sectionId] ?? [];

        // If we are loading and have no data yet, show skeleton
        if (state.status == BannerStatus.loading && sectionBanners.isEmpty) {
          return const _BannerSkeleton(height: 140);
        }

        // If error and no cached data, show error text
        if (state.status == BannerStatus.error && sectionBanners.isEmpty) {
          return Center(
            child: Text(state.errorMessage ?? 'خطأ في تحميل البنرات'),
          );
        }

        // Success or showing cached data
        if (sectionBanners.isEmpty) return const SizedBox.shrink();

        final hasMultiple = sectionBanners.length > 1;

        return Column(
          children: [
            CarouselSlider.builder(
              itemCount: sectionBanners.length,
              carouselController: _controller,
              itemBuilder: (context, index, realIndex) {
                final banner = sectionBanners[index];
                final bool isSelected = _current == index;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.symmetric(
                    vertical: isSelected ? 0 : 5,
                    horizontal: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isSelected ? Colors.orange : Colors.transparent,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _BannerItem(
                    banner: banner,
                    onTap: () => _onBannerTap(context, banner),
                  ),
                );
              },
              options: CarouselOptions(
                height: 160,
                viewportFraction: 1,
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                autoPlay: hasMultiple,
                autoPlayInterval: const Duration(seconds: 4),
                onPageChanged: (i, _) => setState(() => _current = i),
              ),
            ),
            if (hasMultiple) const SizedBox(height: 10),
            if (hasMultiple)
              _DotsIndicator(
                count: sectionBanners.length,
                currentIndex: _current,
                onDotTap: (i) => _controller.animateToPage(i),
              ),
          ],
        );
      },
    );
  }

  Future<void> _onBannerTap(BuildContext context, BannerEntity banner) async {
    final type = banner.type;
    try {
      switch (type) {
        case 'link':
          final raw = banner.valueSectionId;
          if (raw == null) return;
          final uri = Uri.tryParse(raw);
          if (uri != null && await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
          break;
        case 'phone':
          final phone = banner.valueSectionId?.trim();
          if (phone == null || phone.isEmpty) return;
          _showPhoneActionsBottomSheet(context, phone);
          break;
        case 'ads_id':
          // Navigation logic here...
          break;
        case 'company_id':
          final companyId = int.tryParse(banner.companyId);
          final sectionId = int.tryParse(banner.valueSectionId ?? '');
          if (companyId == null || sectionId == null) {
            debugPrint('Invalid company id or section id');
            return;
          }
          Navigator.of(context).pushNamed(
            Routes.companydetails,
            arguments: {'sectionId': sectionId, 'companyId': companyId},
          );
          break;
        default:
          debugPrint('Unhandled banner type: $type');
      }
    } catch (e) {
      debugPrint('Banner tap error: $e');
    }
  }

  void _showPhoneActionsBottomSheet(BuildContext context, String phone) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      backgroundColor: Colors.white,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: AppColors.secondary, width: 5),
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 100,
                    height: 5,
                    margin: const EdgeInsets.only(top: 12, bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const Text(
                  'تواصل مع الشركة',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _ActionTile(
                        label: 'اتصال',
                        color: AppColors.primary,
                        iconPath: AppIcons.phone,
                        onTap: () => _callNumber(phone),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionTile(
                        label: 'واتساب',
                        color: const Color(0xff3AA517),
                        iconPath: AppIcons.whatsapp,
                        onTap: () => _openWhatsApp(phone),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _callNumber(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _openWhatsApp(String phone) async {
    final clean = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('https://wa.me/$clean');
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

// Helper Widget for the bottom sheet buttons to clean up code
class _ActionTile extends StatelessWidget {
  final String label;
  final Color color;
  final String iconPath;
  final VoidCallback onTap;

  const _ActionTile({
    required this.label,
    required this.color,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerItem extends StatelessWidget {
  final BannerEntity banner;
  final VoidCallback onTap;

  const _BannerItem({required this.banner, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(19),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: CachedNetworkImage(
          imageUrl: banner.image,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          placeholder: (context, url) => ShimmerBox(
            width: double.infinity,
            height: double.infinity,
            borderRadius: BorderRadius.circular(19),
          ),
          errorWidget: (context, url, error) =>
              const Icon(Icons.broken_image, size: 50, color: Colors.grey),
        ),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final ValueChanged<int> onDotTap;

  const _DotsIndicator({
    required this.count,
    required this.currentIndex,
    required this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == currentIndex;
        return GestureDetector(
          onTap: () => onDotTap(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 5,
            width: 12,
            decoration: BoxDecoration(
              color: active
                  ? AppColors.secondary
                  : AppColors.secondary.withOpacity(.5),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }),
    );
  }
}

class _BannerSkeleton extends StatelessWidget {
  final double height;
  const _BannerSkeleton({required this.height});

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      height: height,
      width: double.infinity,
      borderRadius: BorderRadius.circular(22),
    );
  }
}
