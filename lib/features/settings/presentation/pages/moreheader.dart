import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/core/utils/shared_widgets/emptywidget.dart';
import 'package:oreed_clean/core/utils/textstyle/apptext_style.dart';
import 'package:oreed_clean/features/companyprofile/presentation/cubit/companyprofile_cubit.dart';
import 'package:oreed_clean/features/settings/presentation/widgets/more_header_errorand_loading.dart';

class MoreHeader extends StatefulWidget {
  const MoreHeader({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  final VoidCallback onLogin;
  final VoidCallback onRegister;

  @override
  State<MoreHeader> createState() => _MoreHeaderState();
}

class _MoreHeaderState extends State<MoreHeader> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prefs = AppSharedPreferences();
      if (prefs.companyId != null) {
        context.read<CompanyprofileCubit>().fetchCompanyProfileAndAds(
          prefs.companyId!,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);
    final prefs = AppSharedPreferences();
    final isLoggedIn = prefs.userId != null;
    final isCompany = prefs.userType != 'personal';
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    if (!isLoggedIn) {
      return _guestHeader(context, t);
    }

    if (!isCompany) {
      return _personalHeader(context, t, prefs, isRTL);
    }

    return BlocBuilder<CompanyprofileCubit, CompanyprofileState>(
      builder: (context, state) {
        if (state.status == CompanyProfileStatus.loading &&
            state.profile == null) {
          return const HeaderLoading();
        }

        if (state.status == CompanyProfileStatus.error &&
            state.profile == null) {
          return HeaderError(
            message:
                state.errorMessage ??
                t?.text('loading_error_company_profile') ??
                'Error loading data',
            onRetry: () {
              context.read<CompanyprofileCubit>().fetchCompanyProfileAndAds(
                prefs.companyId!,
              );
            },
          );
        }

        final profile = state.profile;
        if (profile == null) {
          return SizedBox(
            height: 175,
            child: Center(
              child: emptyAdsView(
                context: context,
                title: t?.text('company_not_found') ?? 'Company not found',
                subtitle: '',
                image: AppIcons.emptyCompany,
                visible: false,
                button: 'button',
                onAddPressed: () {},
              ),
            ),
          );
        }

        return _companyHeader(context, t, prefs, profile, isRTL);
      },
    );
  }

  // ================= HEADERS =================

  Widget _companyHeader(
    BuildContext context,
    AppTranslations? t,
    AppSharedPreferences prefs,
    profile,
    bool isRTL,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _headerFrame(
          isRTL: isRTL,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
              Row(
                children: [
                  Text(
                    prefs.userName ?? '',
                    style: AppTextStyles.heading2.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 5),
              _locationRow(profile.stateName, profile.cityName, isRTL),
              const SizedBox(height: 5),
              _accountTypeRow(t, true, isRTL),
            ],
          ),
        ),
        _profileImage(profile.imageUrl),
      ],
    );
  }

  Widget _personalHeader(
    BuildContext context,
    AppTranslations? t,
    AppSharedPreferences prefs,
    bool isRTL,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _headerFrame(
          isRTL: isRTL,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Row(
                children: [
                  Text(
                    prefs.userName ?? '',
                    style: AppTextStyles.heading2.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 5),
              _accountTypeRow(t, false, isRTL),
              const SizedBox(height: 5),
              _phoneRow(prefs.userPhone ?? '', isRTL),
            ],
          ),
        ),
        _assetProfileImage(Appimage.logoIcon),
      ],
    );
  }

  Widget _guestHeader(BuildContext context, AppTranslations? t) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 150,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Appimage.frame),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            t?.text('guest_header_message') ??
                'Create an account to manage your ads',
            textAlign: TextAlign.center,
            style: AppTextStyles.heading2.copyWith(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _authButton(
                  text: t?.text("login") ?? 'Login',
                  onPressed: widget.onLogin,
                  outlined: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _authButton(
                  text: t?.text("register") ?? 'Register',
                  onPressed: widget.onRegister,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= SMALL WIDGETS =================

  Widget _headerFrame({required Widget child, required bool isRTL}) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 40),
      padding: isRTL
          ? const EdgeInsets.only(right: 30)
          : const EdgeInsets.only(left: 30),
      height: 160,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Appimage.frame),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: child,
    );
  }

  Widget _profileImage(String? url) {
    return PositionedDirectional(
      start: 28,
      top: 0,
      bottom: 110,
      child: CircleAvatar(
        radius: 55,
        backgroundColor: Colors.white,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: url ?? '',
            width: 82,
            height: 85,
            fit: BoxFit.cover,
            placeholder: (_, __) =>
                const CircularProgressIndicator(strokeWidth: 2),
            errorWidget: (_, __, ___) =>
                Image.asset(Appimage.companyTest, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget _assetProfileImage(String asset) {
    return PositionedDirectional(
      start: 28,
      top: 0,
      bottom: 120,
      child: CircleAvatar(
        radius: 55,
        backgroundColor: Colors.white,
        child: ClipOval(child: Image.asset(asset, fit: BoxFit.cover)),
      ),
    );
  }

  Widget _locationRow(String state, String city, bool isRTL) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      textDirection: isRTL ? TextDirection.ltr : TextDirection.rtl,
      children: [
        Text(
          '$state , $city',
          style: AppTextStyles.titleMedium.copyWith(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 5),
        SvgPicture.asset(AppIcons.locationCountry, color: Colors.white),
      ],
    );
  }

  Widget _accountTypeRow(AppTranslations? t, bool isCompany, bool isRTL) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      textDirection: isRTL ? TextDirection.ltr : TextDirection.rtl,
      children: [
        Text(
          isCompany
              ? t?.text('account_type_agency') ?? 'Agency'
              : t?.text('account_type_personal') ?? 'Personal',
          style: AppTextStyles.titleMedium.copyWith(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 5),
        SvgPicture.asset(AppIcons.building),
      ],
    );
  }

  Widget _phoneRow(String phone, bool isRTL) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      textDirection: isRTL ? TextDirection.ltr : TextDirection.rtl,
      children: [
        Text(
          phone,
          style: AppTextStyles.titleMedium.copyWith(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 5),
        SvgPicture.asset(AppIcons.callUs, color: Colors.white),
      ],
    );
  }

  Widget _authButton({
    required String text,
    required VoidCallback onPressed,
    bool outlined = false,
  }) {
    return SizedBox(
      height: 45,
      child: outlined
          ? OutlinedButton(onPressed: onPressed, child: Text(text))
          : ElevatedButton(onPressed: onPressed, child: Text(text)),
    );
  }
}
