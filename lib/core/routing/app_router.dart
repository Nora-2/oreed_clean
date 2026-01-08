
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/features/home/presentation/cubit/home_cubit.dart';
import 'package:oreed_clean/features/home/presentation/pages/home_screen.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_cubit.dart';
import 'package:oreed_clean/features/login/presentation/pages/login_screen.dart';
import 'package:oreed_clean/features/on_boarding/presentation/pages/onboarding_screen.dart';
import 'package:oreed_clean/injection_container.dart';
import 'routes.dart';
class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
     
      case Routes.login:
       return MaterialPageRoute(
          builder: (_) =>  BlocProvider(
        create: (context) => sl<AuthCubit>(),
        child: LoginScreen(),
      ),
        );
         case Routes.onboarding:
       return MaterialPageRoute(
          builder: (_) =>   OnboardingPage(),
      
        );
       case Routes.home:
       return MaterialPageRoute(
          builder: (_) =>  BlocProvider(
        create: (context) => sl<HomeCubit>()..loadHomeData(),
        child: HomeScreen(),
      ),
        );   
    }
    return null;
  }
}
