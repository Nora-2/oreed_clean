import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/features/settings/presentation/cubit/moretab_cubit.dart';
import 'package:oreed_clean/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:oreed_clean/features/settings/presentation/widgets/moretabbody.dart';

class MoreTab extends StatelessWidget {
  const MoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = AppSharedPreferences();

    return Scaffold(
      backgroundColor: Colors.white,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => MoreCubit(
              repository: context.read(),
              prefs: prefs,
              notificationService: context.read(),
            )..fetchPages(),
          ),
          BlocProvider(
            create: (_) => SettingsCubit(context.read())..loadSettings(),
          ),
        ],
        child: const MoreTabBody(),
      ),
    );
  }
}
