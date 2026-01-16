import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/features/account_type/presentation/pages/account_type_screen.dart';
import 'package:oreed_clean/features/addetails/presentation/pages/ad_detailes_screen.dart';
import 'package:oreed_clean/features/banners/presentation/cubit/banners_cubit.dart';
import 'package:oreed_clean/features/comapany_register/presentation/cubit/comapany_register_cubit.dart';
import 'package:oreed_clean/features/comapany_register/presentation/pages/comapny_register_screen.dart';
import 'package:oreed_clean/features/company_types_by_company/presentation/cubit/company_types_by_company_cubit.dart';
import 'package:oreed_clean/features/company_types_by_company/presentation/pages/company_types_company.dart';
import 'package:oreed_clean/features/companydetails/presentation/pages/company_details_screen.dart';
import 'package:oreed_clean/features/companyprofile/presentation/cubit/companyprofile_cubit.dart';
import 'package:oreed_clean/features/companyprofile/presentation/pages/company_profile_screen.dart';
import 'package:oreed_clean/features/favourite/presentation/cubit/favourite_cubit.dart';
import 'package:oreed_clean/features/favourite/presentation/pages/favourite_screen.dart';
import 'package:oreed_clean/features/home/presentation/cubit/home_cubit.dart';
import 'package:oreed_clean/features/home/presentation/pages/main_home_tab.dart';
import 'package:oreed_clean/features/location_selector/presentation/cubit/location_selector_cubit.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_cubit.dart';
import 'package:oreed_clean/features/login/presentation/pages/login_screen.dart';
import 'package:oreed_clean/features/mainlayout/presentation/cubit/mainlayout_cubit.dart';
import 'package:oreed_clean/features/mainlayout/presentation/pages/mainlayout.dart';
import 'package:oreed_clean/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:oreed_clean/features/notification/presentation/pages/notification_screen.dart';
import 'package:oreed_clean/features/on_boarding/presentation/pages/onboarding_screen.dart';
import 'package:oreed_clean/features/password/presentation/pages/change_password_screen.dart';
import 'package:oreed_clean/features/password/presentation/pages/resetpass_screen.dart';
import 'package:oreed_clean/features/personal_register/presentation/cubit/personal_register_cubit.dart';
import 'package:oreed_clean/features/personal_register/presentation/pages/personal_register_screen.dart';
import 'package:oreed_clean/features/settings/presentation/pages/contactus.dart';
import 'package:oreed_clean/features/splash/presentation/splash_screen.dart';
import 'package:oreed_clean/features/verification/presentation/pages/verification_screen.dart';
import 'package:oreed_clean/injection_container.dart';
import 'package:oreed_clean/features/chooseplane/presentation/cubit/chooseplane_cubit.dart';
import 'package:oreed_clean/features/chooseplane/presentation/pages/chooseplan_screen.dart';
import 'package:oreed_clean/features/password/presentation/pages/newpass_withotp_screen.dart';
import 'package:oreed_clean/features/verification/presentation/cubit/verificationscreen_cubit.dart';
import 'package:oreed_clean/features/AdvancedSearch/presentation/cubit/advancedsearch_cubit.dart';
import 'package:oreed_clean/features/AdvancedSearch/presentation/pages/advanced_search.dart';
import 'package:oreed_clean/features/verification/presentation/pages/payment_webview.dart';
import 'routes.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<AuthCubit>(),
            child: LoginScreen(),
          ),
        );
      case Routes.resetpass:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<AuthCubit>(),
            child: ResetPasswordScreen(),
          ),
        );
      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => OnboardingPage());
      case Routes.contacus:
        return MaterialPageRoute(builder: (_) => MsgContactUs());
      case Routes.changepass:
        return MaterialPageRoute(builder: (_) => ChangePasswordScreen());
      case Routes.accounttype:
        return MaterialPageRoute(builder: (_) => AccountTypePage());
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case Routes.home:
        return MaterialPageRoute(
          builder: (_) {
            // 1. Get the BannerCubit first
            final bannerCubit = sl<BannerCubit>();

            return MultiBlocProvider(
              providers: [
                // 2. Provide BannerCubit so BannerSection can see it
                BlocProvider.value(value: bannerCubit),
                BlocProvider(
                  create: (_) => sl<FavoritesCubit>()..loadFavorites(),
                ),
                BlocProvider(
                  create: (context) => MainHomeCubit(
                    sl(),
                    sl(),
                    bannerCubit, // Use the same instance
                  )..fetchHomeData(),
                ),
              ],
              child: const MainHomeTab(),
            );
          },
        );
      case Routes.companyregister:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              // Provides registration logic
              BlocProvider(create: (context) => sl<CompanyRegisterCubit>()),
              // Provides login logic (since the screen has a login tab)
              BlocProvider(create: (context) => sl<AuthCubit>()),
            ],
            child: const CompanyRegisterScreen(),
          ),
        );
      case Routes.personalregister:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              // Provides registration logic
              BlocProvider(create: (context) => sl<PersonalRegisterCubit>()),
              // Provides login logic (since the screen has a login tab)
              BlocProvider(create: (context) => sl<AuthCubit>()),
            ],
            child: const PersonalRegistrationScreen(),
          ),
        );
      case Routes.homelayout:
        final int? initialIndex = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider<HomelayoutCubit>(
            create: (_) =>
                sl<
                  HomelayoutCubit
                >(), // Changed to use sl since we registered it
            child: Homelayout(initialIndex: initialIndex),
          ),
        );

      case Routes.notification:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<NotificationsCubit>(
            create: (_) => sl<NotificationsCubit>(),
            child: NotificationsScreen(),
          ),
        );
      case Routes.companyprfilelite:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider<CompanyprofileCubit>(
            create: (_) => sl<CompanyprofileCubit>(),
            child: CompanyProfileLiteScreen(companyId: args['companyId']),
          ),
        );
      case Routes.choosePlanScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<PackagesCubit>(),
            child: ChoosePlanScreen(
              type: args['type'],
              title: args['title'],
              icon: args['icon'],
              introText: args['introText'],
              accentColor: args['accentColor'],
            ),
          ),
        );

      case Routes.verificationScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<VerificationCubit>(),
            child: VerificationScreen(
              phone: args['phone'],
              isForget: args['isForget'] ?? false,
              isRegister: args['isRegister'] ?? false,
              isCompany: args['isCompany'] ?? false,
            ),
          ),
        );

      case Routes.newPasswordWithOtpScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => NewPasswordWithOtpScreen(phone: args['phone']),
        );
      case Routes.favourite:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<FavoritesCubit>()..loadFavorites(),
            child: const FavoritesScreen(),
          ),
        );
      case Routes.payment:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => PaymentWebView(
            url: args['url'],
            title: args['title'],
            successMatcher: args['successMatcher'],
            cancelMatcher: args['cancelMatcher'],
          ),
        );
      case Routes.companydetails:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => CompanyDetailsScreen(
            companyId: args['companyId'],
            sectionId: args['sectionId'],
            searchText: args['searchText'],
          ),
        );
      case Routes.addetails:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => DetailsAdsScreen(
            adId: args['adId'],
            sectionId: args['sectionId'],
            workerId: args['workerId'],
          ),
        );
      // Inside your app_router.dart or similar
      case Routes.companyTypesCompany:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => sl<CompanyTypesByCompanyCubit>(),
              ),
              BlocProvider(create: (context) => sl<LocationSelectorCubit>()),
            ],
            child: CompanyTypesCompanyScreen(
              companyId: args['companyId'],
              sectionId: args['sectionId'],
              title: args['title'] ?? '',
            ),
          ),
        );
      case Routes.advancedSearch:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<AdvancedSearchCubit>(),
            child: AdvancedSearchScreen(
              initialSearchQuery: args['initialSearchQuery'] ?? '',
            ),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: \\${settings.name}')),
          ),
        );
    }
  }
}
