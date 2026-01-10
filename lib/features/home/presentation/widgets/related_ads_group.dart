import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Added
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/home/presentation/cubit/home_cubit.dart';
import 'package:oreed_clean/features/home/presentation/widgets/related_ad_section.dart';

class RelatedAdsGroup extends StatefulWidget {
  const RelatedAdsGroup({super.key});

  @override
  State<RelatedAdsGroup> createState() => _RelatedAdsGroupState();
}

class _RelatedAdsGroupState extends State<RelatedAdsGroup> {
  @override
  void initState() {
    super.initState();
    // 🔹 Trigger fetching ads
    context.read<MainHomeCubit>().fetchRelatedAds();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);

    return BlocBuilder<MainHomeCubit, MainHomeState>(
      builder: (context, state) {
        // 🔸 Error state
        if (state.relatedAdsStatus == HomeStatus.error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.relatedAdsError ??
                        tr?.text('failed_load_ads') ??
                        'Failed to load ads, please try again.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => context.read<MainHomeCubit>().fetchRelatedAds(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                    label: Text(
                      tr?.text('retry') ?? 'Retry',
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // 🔸 Success state check
        final hasAnyAds = state.relatedAdsCars.isNotEmpty ||
            state.relatedAdsRealEstate.isNotEmpty ||
            state.relatedAdsTechnical.isNotEmpty ||
            state.relatedAdsPhones.isNotEmpty;

        // If no ads are returned after loading finishes
        if (state.relatedAdsStatus == HomeStatus.success && !hasAnyAds) {
          return const _EmptyAdsState();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.relatedAdsCars.isNotEmpty)
              _buildSectionContainer(
                child: RelatedAdsSection(
                  title: tr?.text('cars') ?? 'Cars',
                  items: state.relatedAdsCars,
                  sectionId: 1,
                ),
              ),
            if (state.relatedAdsRealEstate.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSectionContainer(
                child: RelatedAdsSection(
                  title: tr?.text('real_estate') ?? 'Real estate',
                  items: state.relatedAdsRealEstate,
                  sectionId: 2,
                ),
              ),
            ],
            if (state.relatedAdsTechnical.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSectionContainer(
                child: RelatedAdsSection(
                  title: tr?.text('technicians') ?? 'Technicians',
                  items: state.relatedAdsTechnical,
                  sectionId: 3,
                ),
              ),
            ],
            if (state.relatedAdsPhones.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSectionContainer(
                child: RelatedAdsSection(
                  title: tr?.text('phones') ?? 'هواتف',
                  items: state.relatedAdsPhones,
                  sectionId: 12,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  // Helper to keep UI clean
  Widget _buildSectionContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xffE8E8E9).withOpacity(.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: child,
      ),
    );
  }
}

/// 🎨 Beautiful empty state when no ads are available
class _EmptyAdsState extends StatelessWidget {
  const _EmptyAdsState();

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.store_outlined,
                size: 80,
                color: AppColors.primary.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              tr?.text('no_ads_available') ?? 'No Ads Available',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              tr?.text('no_ads_description') ??
                  'There are currently no ads to display.\nCheck back later for new listings!',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () => context.read<MainHomeCubit>().fetchRelatedAds(),
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(tr?.text('refresh') ?? 'Refresh'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary, width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}