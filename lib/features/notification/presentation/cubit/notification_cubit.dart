import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/features/notification/data/repositories/notification_repo.dart';
import '../../data/models/notification_model.dart';


part 'notification_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository repository;
  final AppSharedPreferences prefs;

  NotificationsCubit({
    required this.repository,
    required this.prefs,
  }) : super(const NotificationsState());

  /// Load notifications (first page)
  Future<void> loadNotifications({bool showLoading = true}) async {
    if (showLoading) {
      emit(state.copyWith(status: NotificationsStatus.loading));
    }

    try {
      final token = prefs.getUserToken;
      final locale = prefs.getLanguageCode ?? 'ar';

      if (token == null || token.isEmpty) {
        throw Exception('User token not found');
      }

      final response = await repository.getNotifications(
        token: token,
        locale: locale,
        page: 1,
        perPage: 10,
      );

      emit(state.copyWith(
        status: NotificationsStatus.success,
        notifications: response.data,
        pagination: response.pagination,
        currentPage: 1,
        hasMoreData: response.pagination.hasNextPage,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotificationsStatus.error,
        errorMessage: e.toString(),
      ));
      
    }
  }

  /// Load more notifications (pagination)
  Future<void> loadMore() async {
    if (!state.hasMoreData || state.isLoadingMore) return;

    emit(state.copyWith(status: NotificationsStatus.loadingMore));

    try {
      final token = prefs.getUserToken;
      final locale = prefs.getLanguageCode ?? 'ar';

      if (token == null || token.isEmpty) throw Exception('Token not found');

      final nextPage = state.currentPage + 1;

      final response = await repository.getNotifications(
        token: token,
        locale: locale,
        page: nextPage,
        perPage: 10,
      );

      emit(state.copyWith(
        status: NotificationsStatus.success,
        notifications: [...state.notifications, ...response.data],
        pagination: response.pagination,
        currentPage: nextPage,
        hasMoreData: response.pagination.hasNextPage,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotificationsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Refresh notifications
  Future<void> refresh() async => await loadNotifications(showLoading: false);

  /// Toggle read status (Optimistic update)
  Future<void> toggleRead(NotificationModel notification) async {
    final oldNotifications = List<NotificationModel>.from(state.notifications);
    
    try {
      final token = prefs.getUserToken;
      if (token == null) return;

      // Optimistic update
      final newNotifications = state.notifications.map((n) {
        if (n.id == notification.id) {
          return NotificationModel(
            id: n.id, title: n.title, body: n.body,
            read: n.isRead ? 0 : 1, image: n.image, createdAt: n.createdAt,
          );
        }
        return n;
      }).toList();

      emit(state.copyWith(notifications: newNotifications));

      if (!notification.isRead) {
        await repository.markAsRead(token: token, notificationId: notification.id);
      }
    } catch (e) {
      emit(state.copyWith(notifications: oldNotifications));
    }
  }

  /// Mark all as read (Optimistic update)
  Future<void> markAllAsRead() async {
    if (state.notifications.isEmpty) return;
    final oldNotifications = List<NotificationModel>.from(state.notifications);

    try {
      final token = prefs.getUserToken;
      if (token == null) return;

      final updatedList = state.notifications.map((n) => NotificationModel(
        id: n.id, title: n.title, body: n.body,
        read: 1, image: n.image, createdAt: n.createdAt,
      )).toList();

      emit(state.copyWith(notifications: updatedList));

      final success = await repository.markAllNotificationsAsRead(token: token);
      if (!success) throw Exception("Failed to sync");
    } catch (e) {
      emit(state.copyWith(notifications: oldNotifications));
    }
  }

  /// Delete notification (Optimistic update)
  Future<void> deleteNotification(NotificationModel notification) async {
    final oldNotifications = List<NotificationModel>.from(state.notifications);

    try {
      final token = prefs.getUserToken;
      if (token == null) return;

      final newList = state.notifications.where((n) => n.id != notification.id).toList();
      emit(state.copyWith(notifications: newList));

      final success = await repository.deleteNotification(token: token, notificationId: notification.id);
      if (!success) throw Exception("Delete failed");
    } catch (e) {
      emit(state.copyWith(notifications: oldNotifications));
    }
  }

  /// Delete all notifications
  Future<void> deleteAll() async {
    if (state.notifications.isEmpty) return;
    final oldNotifications = List<NotificationModel>.from(state.notifications);

    try {
      final token = prefs.getUserToken;
      if (token == null) return;

      emit(state.copyWith(notifications: []));

      final success = await repository.deleteAllNotifications(token: token);
      if (!success) throw Exception("Clear failed");
    } catch (e) {
      emit(state.copyWith(notifications: oldNotifications));
    }
  }

  /// Helper for filtered/sorted list
  List<NotificationModel> getFiltered({bool unreadOnly = false}) {
    final filtered = unreadOnly
        ? state.notifications.where((n) => !n.isRead).toList()
        : [...state.notifications];

    filtered.sort((a, b) {
      final dateA = a.createdAtDate;
      final dateB = b.createdAtDate;
      if (dateA == null || dateB == null) return 0;
      return dateB.compareTo(dateA);
    });

    return filtered;
  }
}