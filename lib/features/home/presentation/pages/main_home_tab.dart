import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/shared_widgets/route_observer.dart';
import 'package:oreed_clean/features/home/presentation/cubit/home_cubit.dart';
import 'package:oreed_clean/features/home/presentation/widgets/home_back.dart';

class MainHomeTab extends StatefulWidget {
  const MainHomeTab({super.key});

  @override
  State<MainHomeTab> createState() => _MainHomeTabState();
}

class _MainHomeTabState extends State<MainHomeTab> with RouteAware {
  ModalRoute<dynamic>? _route;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MainHomeCubit>().fetchHomeData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (_route != route && route != null) {
      if (_route != null) routeObserver.unsubscribe(this);
      _route = route;
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    context.read<MainHomeCubit>().fetchHomeData();
  }

  @override
  void dispose() {
    if (_route != null) routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<MainHomeCubit>().fetchHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = AppSharedPreferences();
    final displayName =
        (prefs.userNameAr?.trim().isNotEmpty == true
                ? prefs.userNameAr!
                : prefs.userName?.trim().isNotEmpty == true
                    ? prefs.userName!
                    : AppTranslations.of(context)?.text('guest_name') ?? 'ضيف')
            .split(' ')
            .first;

    return BlocBuilder<MainHomeCubit, MainHomeState>(
      builder: (context, state) {
        return HomeScaffold(
          state: state,
          displayName: displayName,
          onRefresh: _onRefresh,
        );
      },
    );
  }
}
