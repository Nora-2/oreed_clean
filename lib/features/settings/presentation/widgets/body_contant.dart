import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/features/comapany_register/presentation/pages/company_form_ui.dart';
import 'package:oreed_clean/features/settings/data/models/page_model.dart';
import 'package:oreed_clean/features/settings/presentation/cubit/moretab_cubit.dart';
import 'package:oreed_clean/features/settings/presentation/widgets/row_with_arrow.dart';
import 'package:oreed_clean/features/settings/presentation/widgets/show_change_lang_botyom_sheet.dart';
import 'package:share_plus/share_plus.dart';

class BodyContent extends StatelessWidget {
  const BodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);
    final prefs = AppSharedPreferences();
    final isLoggedIn = prefs.userId != null;
    final cubit = context.read<MoreCubit>();
    return BlocConsumer<MoreCubit, MoreState>(
      listener: (context, state) {
        if (state.status == MoreStatus.actionSuccess &&
            state.actionMessage == 'loggedOut') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.login,
            (_) => false,
          );
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sectionTitle(t?.text("preferences") ?? 'Preferences'),

            if (isLoggedIn)
              RowWithArrow(
                hasArrow: true,
                title: t?.text("my_ads") ?? 'My Ads',
                icon: AppIcons.volumeWithBack,
                onPressed: () => _handleProfileNavigation(context, cubit),
              ),

            if (isLoggedIn)
              RowWithArrow(
                hasArrow: true,
                title: t?.text("favorites") ?? "Favorite Ads",
                icon: AppIcons.heartBack,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.favourite);
                },
              ),

            RowWithArrow(
              hasArrow: true,
              title: t?.text("language") ?? "Language",
              icon: AppIcons.globe,
              onPressed: () => showChangeLanguageBottomSheet(context),
            ),

            const SizedBox(height: 30),

            _sectionTitle(t?.text("app_settings_title") ?? 'App Settings'),

            RowWithArrow(
              hasArrow: true,
              title: t?.text("Share App") ?? "Share App",
              icon: AppIcons.shareBack,
              onPressed: () => _shareApp(context),
            ),

            if (prefs.getUserToken != null)
              RowWithArrow(
                hasArrow: true,
                title: t?.text("password") ?? 'Password',
                icon: AppIcons.lock,
                onPressed: () =>
                    Navigator.pushNamed(context, Routes.changepass),
              ),

            const SizedBox(height: 30),

            _sectionTitle(t?.text("support_help") ?? 'Support & Help'),

            RowWithArrow(
              hasArrow: true,
              title: t?.text("contact_us") ?? "Contact Us",
              icon: AppIcons.callUs,
              onPressed: () => Navigator.pushNamed(context, Routes.contacus),
            ),

            _buildDynamicPages(state, context, t),

            if (isLoggedIn)
              RowWithArrow(
                hasArrow: true,
                title: t?.text("signOut") ?? "Sign Out",
                icon: AppIcons.exit,
                onPressed: () => _confirmLogout(context),
              ),
          ],
        );
      },
    );
  }

  // ---------------- UI HELPERS ----------------

  Widget _sectionTitle(String title) {
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

  Widget _buildDynamicPages(
    MoreState state,
    BuildContext context,
    AppTranslations? t,
  ) {
    if (state.status == MoreStatus.loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (state.status == MoreStatus.error) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          state.errorMessage ?? 'Error loading data',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (state.pages.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          t?.text("noData") ?? "No data",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.grey),
        ),
      );
    }

    return Column(
      children: state.pages
          .map(
            (PageModel page) => RowWithArrow(
              hasArrow: true,
              title: page.title,
              icon: AppIcons.shieldBack,

              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamed(Routes.dynamicPage, arguments: {'pageModel': page});
              },
            ),
          )
          .toList(),
    );
  }

  // ---------------- ACTIONS ----------------

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<MoreCubit>().logOut();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
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

  void _shareApp(BuildContext context) {
    const googlePlayUrl =
        'https://play.google.com/store/apps/details?id=com.tabarak.oreed';
    const appStoreUrl = 'https://apps.apple.com/kw/app/oreed/id1536317929';

    final t = AppTranslations.of(context);
    final msg =
        '${t?.text("shareAppMessage")}\n\n'
        '${t?.text("downloadGooglePlay")}: $googlePlayUrl\n\n'
        '${t?.text("downloadAppStore")}: $appStoreUrl';

    Share.share(msg);
  }
}
