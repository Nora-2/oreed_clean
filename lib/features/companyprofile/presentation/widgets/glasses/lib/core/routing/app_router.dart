import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glasses/core/routing/routes.dart';
import 'package:glasses/core/utils/widgets/mainlayout.dart';
import 'package:glasses/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:glasses/features/onboarding/presentation/pages/on_boarding_screen.dart';
import 'package:glasses/features/spalsh/presentation/pages/spalshscreen.dart';

class AppRouter {
  AppRouter() {}

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(), 
        );
      case Routes.layout:
        return MaterialPageRoute(
          builder: (_) => const MainLayout (), 
        );
      case Routes.onboarding:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                OnboardingCubit(), // Create a new cubit for onboarding
            child: const OnboardingScreen(),
          ),
        );
    }
    return null;
  }
}
