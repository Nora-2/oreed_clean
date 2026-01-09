import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:oreed_clean/features/notification/data/repositories/notification_repo.dart';
import 'package:oreed_clean/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:oreed_clean/features/notification/presentation/widgets/notification_header.dart';
import 'package:oreed_clean/features/notification/presentation/widgets/notification_list.dart';
import 'package:oreed_clean/features/notification/presentation/widgets/notification_title_row.dart';
import 'package:oreed_clean/features/notification/presentation/widgets/segmented_tabs.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  final ScrollController _allScrollController = ScrollController();
  final ScrollController _unreadScrollController = ScrollController();

  NotificationsCubit? _cubit;
  bool _booting = true;
  bool _redirected = false;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _allScrollController.addListener(() => _onScroll(_allScrollController));
    _unreadScrollController.addListener(
      () => _onScroll(_unreadScrollController),
    );
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final prefs = AppSharedPreferences();
    await prefs.initSharedPreferencesProp();
    final token = prefs.getUserToken;

    if (token == null || token.isEmpty) {
      if (!_redirected && mounted) {
        _redirected = true;
        Navigator.of(context).pushReplacementNamed(Routes.login);
      }
      return;
    }

    _cubit = NotificationsCubit(
      repository: NotificationsRepository(
        remoteDataSource: NotificationsRemoteDataSourceImpl(),
      ),
      prefs: prefs,
    );

    if (mounted) {
      setState(() => _booting = false);
      _cubit!.loadNotifications();
    }
  }

  void _onScroll(ScrollController controller) {
    if (controller.position.pixels >=
        controller.position.maxScrollExtent - 200) {
      _cubit?.loadMore();
    }
  }

  @override
  void dispose() {
    _tab.dispose();
    _allScrollController.dispose();
    _unreadScrollController.dispose();
    _cubit?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_booting) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_redirected || _cubit == null) return const SizedBox.shrink();

    final tr = AppTranslations.of(context);

    return BlocProvider.value(
      value: _cubit!,
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    BuildHeader(context: context, tr: tr, state: state,cubit: _cubit,),
                    const SizedBox(height: 16),
                    TitleRow(cubit: _cubit, tr: tr, state: state),
                    const SizedBox(height: 16),
                    SegmentedTabs(
                      controller: _tab,
                      allLabel: tr?.text('all') ?? 'All',
                      unreadLabel: tr?.text('unread') ?? 'Unread',
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tab,
                        children: [
                          NotificationsList(
                            state: state,
                            items: _cubit!.getFiltered(unreadOnly: false),
                            onRefresh: () => _cubit!.refresh(),
                            onToggleRead: (n) => _cubit!.toggleRead(n),
                            onDelete: (n) => _cubit!.deleteNotification(n),
                            scrollController: _allScrollController,
                          ),
                          NotificationsList(
                            state: state,
                            items: _cubit!.getFiltered(unreadOnly: true),
                            onRefresh: () => _cubit!.refresh(),
                            onToggleRead: (n) => _cubit!.toggleRead(n),
                            onDelete: (n) => _cubit!.deleteNotification(n),
                            scrollController: _unreadScrollController,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
