
import 'package:oreed_clean/features/notification/data/datasources/notification_remote_data_source.dart';

import '../models/notification_model.dart';

/// Repository for managing notifications
class NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepository({
    required this.remoteDataSource,
  });

  /// Get notifications with pagination
  Future<NotificationsResponse> getNotifications({
    required String token,
    required String locale,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      return await remoteDataSource.getNotifications(
        token: token,
        locale: locale,
        page: page,
        perPage: perPage,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Mark notification as read
  Future<bool> markAsRead({
    required String token,
    required int notificationId,
  }) async {
    try {
      return await remoteDataSource.markAsRead(
        token: token,
        notificationId: notificationId,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Delete notification
  Future<bool> deleteNotification({
    required String token,
    required int notificationId,
  }) async {
    try {
      return await remoteDataSource.deleteNotification(
        token: token,
        notificationId: notificationId,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Delete all notifications
  Future<bool> deleteAllNotifications({
    required String token,
  }) async {
    try {
      return await remoteDataSource.deleteAllNotifications(token: token);
    } catch (e) {
      rethrow;
    }
  }

  /// Mark all notifications as read
  Future<bool> markAllNotificationsAsRead({
    required String token,
  }) async {
    try {
      return await remoteDataSource.markAllNotificationsAsRead(token: token);
    } catch (e) {
      rethrow;
    }
  }

  void dispose() {
    remoteDataSource.dispose();
  }
}
