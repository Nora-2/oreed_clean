import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/features/account_type/presentation/pages/account_type_screen.dart';
import 'package:oreed_clean/features/banners/presentation/cubit/banners_cubit.dart';
import 'package:oreed_clean/features/comapany_register/presentation/cubit/comapany_register_cubit.dart';
import 'package:oreed_clean/features/comapany_register/presentation/pages/comapny_register_screen.dart';
import 'package:oreed_clean/features/favourite/presentation/cubit/favourite_cubit.dart';
import 'package:oreed_clean/features/home/presentation/cubit/home_cubit.dart';
import 'package:oreed_clean/features/home/presentation/pages/main_home_tab.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_cubit.dart';
import 'package:oreed_clean/features/login/presentation/pages/login_screen.dart';
import 'package:oreed_clean/features/mainlayout/presentation/cubit/mainlayout_cubit.dart';
import 'package:oreed_clean/features/mainlayout/presentation/pages/mainlayout.dart';
import 'package:oreed_clean/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:oreed_clean/features/notification/presentation/pages/notification_screen.dart';
import 'package:oreed_clean/features/on_boarding/presentation/pages/onboarding_screen.dart';
import 'package:oreed_clean/features/personal_register/presentation/cubit/personal_register_cubit.dart';
import 'package:oreed_clean/features/personal_register/presentation/pages/personal_register_screen.dart';
import 'package:oreed_clean/features/splash/presentation/splash_screen.dart';
import 'package:oreed_clean/injection_container.dart';
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
      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => OnboardingPage());
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
              BlocProvider(
                create: (context) => sl<CompanyRegisterCubit>(),
              ),
              // Provides login logic (since the screen has a login tab)
              BlocProvider(
                create: (context) => sl<AuthCubit>(),
              ),
            ],
            child: const CompanyRegisterScreen (),
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
        return MaterialPageRoute(
          builder: (_) => BlocProvider<HomelayoutCubit>(
            create: (_) => HomelayoutCubit(),
            child: const Homelayout(),
          ),
        );

      case Routes.notification:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<NotificationsCubit>(
            create: (_) => sl<NotificationsCubit>(),
            child: NotificationsScreen(),
          ),
        );
    }
    return null;
  }
}
