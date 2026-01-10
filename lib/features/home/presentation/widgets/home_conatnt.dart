import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/features/banners/presentation/pages/banner_screen.dart';
import 'package:oreed_clean/features/home/presentation/cubit/home_cubit.dart';
import 'package:oreed_clean/features/home/presentation/widgets/category_section.dart';
import 'package:oreed_clean/features/home/presentation/widgets/error_state.dart';
import 'package:oreed_clean/features/home/presentation/widgets/greating_section.dart';
import 'package:oreed_clean/features/home/presentation/widgets/home_load_shimmer.dart';
import 'package:oreed_clean/features/home/presentation/widgets/related_ads_group.dart';
import 'package:oreed_clean/features/home/presentation/widgets/seaction_header.dart';
import 'package:oreed_clean/features/home/presentation/widgets/search_field.dart';
import 'package:oreed_clean/features/home/presentation/widgets/top_bar.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MainHomeCubit>().state;
    final appTrans = AppTranslations.of(context);
    final prefs = AppSharedPreferences();

    final displayName =
        (prefs.userNameAr?.trim().isNotEmpty == true
                ? prefs.userNameAr!
                : prefs.userName?.trim().isNotEmpty == true
                    ? prefs.userName!
                    : appTrans?.text('guest_name') ?? 'ضيف')
            .split(' ')
            .first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopBar(),
              const SizedBox(height: 2),
              GreetingSection(displayName: displayName),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: HomeSearchField(),
              ),
              const SizedBox(height: 20),
              const BannerSection(sectionId: null),
            ],
          ),
        ),

        const SizedBox(height: 24),

        if (state.status == HomeStatus.loading)
          const LoadingShimmer(isTablet: false)
        else if (state.status == HomeStatus.error)
          ErrorState(
            errorMessage: state.errorMessage,
            onRetry: () => context.read<MainHomeCubit>().fetchHomeData(),
          )
        else if (state.status == HomeStatus.success) ...[
          const SectionsTitle(),
          const SizedBox(height: 16),
          CategorySection(categories: state.sections),
          const SizedBox(height: 10),
          const RelatedAdsGroup(),
          const SizedBox(height: 80),
        ],
      ],
    );
  }
}
