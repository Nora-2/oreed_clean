import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/features/notification/presentation/pages/notification_services.dart';
import 'package:oreed_clean/features/settings/data/models/page_model.dart';
import 'package:oreed_clean/features/settings/domain/repositories/more_repo.dart';

part 'moretab_state.dart';

class MoreCubit extends Cubit<MoreState> {
  final MoreRepository repository;
  final AppSharedPreferences prefs;
  final NotificationService notificationService;

  MoreCubit({
    required this.repository,
    required this.prefs,
    required this.notificationService,
  }) : super(const MoreState());

  Future<void> fetchPages() async {
    emit(state.copyWith(status: MoreStatus.loading));
    try {
      await prefs.initSharedPreferencesProp();
      final pages = await repository.fetchPages();
      emit(state.copyWith(status: MoreStatus.success, pages: pages));
    } catch (e) {
      emit(
        state.copyWith(status: MoreStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> logOut() async {
    emit(state.copyWith(status: MoreStatus.actionLoading));
    try {
      await notificationService.unsubscribeFromAllUserTypeTopics();
      prefs.clearPrefs();
      emit(
        state.copyWith(
          status: MoreStatus.actionSuccess,
          actionMessage: 'loggedOut',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MoreStatus.actionError,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(status: MoreStatus.actionLoading));
    try {
      final resp = await repository.deleteAccount();
      final bool ok = resp['status'] == true;
      final msg = (resp['message'] ?? resp['msg'] ?? '').toString();

      if (ok) {
        // Clear prefs after successful deletion
        await notificationService.unsubscribeFromAllUserTypeTopics();
        prefs.clearPrefs();
        emit(
          state.copyWith(status: MoreStatus.actionSuccess, actionMessage: msg),
        );
      } else {
        emit(state.copyWith(status: MoreStatus.actionError, errorMessage: msg));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: MoreStatus.actionError,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
