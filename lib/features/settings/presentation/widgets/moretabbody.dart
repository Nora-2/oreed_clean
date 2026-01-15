import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/features/companyprofile/presentation/cubit/companyprofile_cubit.dart';
import 'package:oreed_clean/features/settings/data/models/appsetting_model.dart';
import 'package:oreed_clean/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:oreed_clean/features/settings/presentation/pages/moreheader.dart';
import 'package:oreed_clean/features/settings/presentation/widgets/body_contant.dart';
import 'package:oreed_clean/features/settings/presentation/widgets/build_content_notlogin.dart';
import 'package:oreed_clean/features/settings/presentation/widgets/subscribtion_states.dart';
import 'package:oreed_clean/features/settings/presentation/widgets/subscription_card.dart';

class MoreTabBody extends StatelessWidget {
  const MoreTabBody({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = AppSharedPreferences();
    final isLoggedIn = prefs.userId != null;
    final isCompany = prefs.userType != 'personal';

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MoreHeader(
              onLogin: () =>
                  Navigator.pushNamed(context, Routes.login),
              onRegister: () =>
                  Navigator.pushNamed(context, Routes.accounttype),
            ),

            if (isCompany && isLoggedIn)
              BlocBuilder<CompanyprofileCubit, CompanyprofileState>(
                builder: (context, state) {
                  final company = state.profile;
                  if (company == null) {
                    return const SizedBox.shrink();
                  }

                  final status = SubscriptionStatus.fromDateString(
                    company.adsExpiredAt,
                  );

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SubscriptionCard(
                      subscriptionStatus: status,
                      governorate: company.stateName,
                      city: company.cityName,
                      companyId: company.id.toString(),
                      userId: company.userId,
                    ),
                  );
                },
              ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  isLoggedIn
                      ? const BodyContent()
                      : const BodyContentNotLogin(),

                  const SizedBox(height: 10),

                  BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      if (state.settings == null) {
                        return const SizedBox.shrink();
                      }
                      return _buildSocialMediaPill(
                        state.settings!,
                        context.read<SettingsCubit>(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSocialMediaPill(
  AppSettingsModel s,
  SettingsCubit cubit,
) {
  return Center(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (s.facebook?.isNotEmpty == true)
          _socialIcon(
            AppIcons.facebook,
            () => cubit.openUrl(s.facebook!),
          ),

        if (s.twitter?.isNotEmpty == true) ...[
          const SizedBox(width: 8),
          _socialIcon(
            AppIcons.insta,
            () => cubit.openUrl(s.twitter!),
          ),
        ],

        if (s.linkedin?.isNotEmpty == true) ...[
          const SizedBox(width: 8),
          _socialIcon(
            AppIcons.tiktok,
            () => cubit.openUrl(s.linkedin!),
          ),
        ],
      ],
    ),
  );
}


Widget _socialIcon(String icon, VoidCallback onTap, {bool isSvg = true}) {
  return GestureDetector(
    onTap: onTap,
    child: isSvg
        ? SvgPicture.asset(
            icon,
            width: 30,
            height: 30,
            placeholderBuilder: (context) => const SizedBox(
              width: 24,
              height: 24,
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        : Image.asset(
            icon,
            width: 30,
            height: 30,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.image_outlined,
              size: 24,
              color: Colors.grey,
            ),
          ),
  );
}

}
