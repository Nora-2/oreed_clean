import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/features/mainlayout/presentation/cubit/mainlayout_state.dart';


class HomelayoutCubit extends Cubit<HomelayoutState> {
  HomelayoutCubit() : super(const HomelayoutState(currentTabIndex: 2));

  void changeTabIndex(int index) {
    emit(state.copyWith(currentTabIndex: index));
  }
  void resetToHome() {
    emit(state.copyWith(currentTabIndex: 2));
  }

  /// Centralized Tab Handling Logic
  Future<void> handleTabTap(BuildContext context, int index) async {
    final token = AppSharedPreferences().getUserToken;
    final userType = AppSharedPreferences().userType;

    // 🔴 ALWAYS go back to Home first
    if (ModalRoute.of(context)?.settings.name != Routes.homelayout) {
      Navigator.of(context).pushNamedAndRemoveUntil(
       Routes.homelayout,
        (route) => false,
      );
    }

    // 1. Auth Check (Center Tab)
    if (token == null && index == 1) {
     Navigator.of(context).pushNamedAndRemoveUntil(
       Routes.login,
        (route) => false,
      
      );
      return;
    }

    // 2. Account Type Check
    if (index == 1 && userType != 'personal') {
      // await showAccountTypeBottomSheet(
      //   context: context,
      //   onAccountTypeSelected: (_) {
      //     changeTabIndex(1);
      //   },
      // );
    } else {
      changeTabIndex(index);
    }
  }
}