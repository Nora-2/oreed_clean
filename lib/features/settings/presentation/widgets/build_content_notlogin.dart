import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/features/comapany_register/presentation/pages/company_form_ui.dart';
import 'package:oreed_clean/features/settings/presentation/cubit/moretab_cubit.dart';
import 'package:oreed_clean/features/settings/presentation/widgets/row_with_arrow.dart';
import 'package:oreed_clean/features/settings/presentation/widgets/show_change_lang_botyom_sheet.dart';
import 'package:share_plus/share_plus.dart';

class BodyContentNotLogin extends StatelessWidget {
  const BodyContentNotLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);
    final cubit = context.read<MoreCubit>();
    final prefs = cubit.prefs; // Accessing prefs through cubit
    final isLoggedIn = prefs.userId != null;

    return BlocBuilder<MoreCubit, MoreState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _buildSectionHeader(appTrans?.text("settings") ?? 'Settings'),
            const SizedBox(height: 10),

            if (isLoggedIn) ...[
              RowWithArrow(
                hasArrow: true,
                title: appTrans?.text("my_ads") ?? 'My Ads',
                icon: AppIcons.volumeWithBack,
                onPressed: () => _handleProfileNavigation(context, cubit),
              ),
              RowWithArrow(
                hasArrow: true,
                title: appTrans?.text("favorites") ?? "Favorite Ads",
                icon: AppIcons.heartBack,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.favourite);
                },
              ),
            ],

            // Language
            RowWithArrow(
              hasArrow: true,
              title: appTrans?.text("language") ?? "Language",
              icon: AppIcons.globe,
              onPressed: () => showChangeLanguageBottomSheet(context),
            ),

            const SizedBox(height: 15),
            RowWithArrow(
              hasArrow: true,
              title: appTrans?.text("Share App") ?? "Share App",
              icon: AppIcons.shareBack,
              onPressed: () => _shareApp(context),
            ),

            if (prefs.getUserToken != null)
              RowWithArrow(
                hasArrow: true,
                title: appTrans?.text("password") ?? 'Password',
                icon: AppIcons.lock,
                onPressed: () =>
                    Navigator.pushNamed(context, Routes.changepass),
              ),

            const SizedBox(height: 15),
            RowWithArrow(
              hasArrow: true,
              title: appTrans?.text("contact_us") ?? "Contact Us",
              icon: AppIcons.callUs,
              onPressed: () => Navigator.of(context).pushNamed(Routes.contacus),
            ),

            const SizedBox(height: 15),

            // Data Loading States
            if (state.status == MoreStatus.loading)
              const _LoadingWidget()
            else if (state.errorMessage != null)
              _ErrorWidget(message: state.errorMessage!)
            else if (state.pages.isEmpty)
              _NoDataWidget(message: appTrans?.text("noData") ?? "No data")
            else
              ...state.pages.map((page) {
                return RowWithArrow(
                  hasArrow: true,
                  title:
                      page.title ??
                      appTrans?.text("privacy") ??
                      'Privacy Policy',
                  icon: AppIcons.shieldBack,
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      Routes.dynamicPage,
                      arguments: {'pageModel': page},
                    );
                  },
                );
              }),

            const SizedBox(height: 15),
            if (isLoggedIn)
              RowWithArrow(
                hasArrow: true,
                title: appTrans?.text("signOut") ?? "Sign Out",
                icon: 'assets/svg/exitback.svg',
                onPressed: () => _showSignOutDialog(context, cubit),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.secondary,
          ),
          height: 20,
          width: 3,
        ),
        const SizedBox(width: 5),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 14.5,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  void _handleProfileNavigation(BuildContext context, MoreCubit cubit) {
    final prefs = cubit.prefs;
    if (prefs.userType == 'personal') {
      Navigator.of(context).pushNamed(Routes.personalads);
    } else {
      if (prefs.getCompanyId == null) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const CompanyFormUI()));
      } else {
        Navigator.of(context).pushNamed(
          Routes.companyprfilelite,
          arguments: {'companyId': prefs.getCompanyId!},
        );
      }
    }
  }

  void _showSignOutDialog(BuildContext context, MoreCubit cubit) {
    final appTrans = AppTranslations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(appTrans!.text("signOut")),
        content: Text(appTrans.text("signOutQuestion")),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(appTrans.text("close")),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              cubit.logOut(); // Call the cubit action
            },
            child: Text(appTrans.text("confirm")),
          ),
        ],
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  const _ErrorWidget({required this.message});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(message, style: const TextStyle(color: Colors.red)),
    );
  }
}

class _NoDataWidget extends StatelessWidget {
  final String message;
  const _NoDataWidget({required this.message});
  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.grey),
    );
  }
}

void _shareApp(BuildContext context) {
  const googlePlayUrl =
      'https://play.google.com/store/apps/details?id=com.tabarak.oreed&pcampaignid=web_share';
  const appStoreUrl = 'https://apps.apple.com/kw/app/oreed/id1536317929?l=ar';

  final t = AppTranslations.of(context);
  final msg =
      '${t?.text("shareAppMessage")}\n\n'
      '${t?.text("downloadGooglePlay")}: $googlePlayUrl\n\n'
      '${t?.text("downloadAppStore")}: $appStoreUrl';

  Share.share(msg);
}
