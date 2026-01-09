import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oreed_clean/features/notification/data/models/notification_model.dart';
import 'package:oreed_clean/networking/api_provider.dart';

/// Abstract class defining the contract for notifications remote data source
abstract class NotificationsRemoteDataSource {
  Future<NotificationsResponse> getNotifications({
    required String token,
    required String locale,
    int page,
    int perPage,
  });

  Future<bool> markAsRead({
    required String token,
    required int notificationId,
  });

  Future<bool> deleteNotification({
    required String token,
    required int notificationId,
  });

  Future<bool> deleteAllNotifications({
    required String token,
  });

  Future<bool> markAllNotificationsAsRead({
    required String token,
  });

  void dispose();
}

/// Concrete implementation of the NotificationsRemoteDataSource
class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final http.Client client;

  NotificationsRemoteDataSourceImpl({http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<NotificationsResponse> getNotifications({
    required String token,
    required String locale,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiProvider.baseUrl}/api/get_notifications_by_user_id?paginate=enabled&per_page=$perPage&page=$page',
      );

      final response = await client.get(
        uri,
        headers: {
          'locale': locale,
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return NotificationsResponse.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load notifications: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }

  @override
  Future<bool> markAsRead({
    required String token,
    required int notificationId,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiProvider.baseUrl}/api/mark_notification_as_read/$notificationId',
      );

      final response = await client.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return jsonData['status'] as bool? ?? false;
      } else {
        throw Exception('Failed to mark as read: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error marking notification as read: $e');
    }
  }

  @override
  Future<bool> deleteNotification({
    required String token,
    required int notificationId,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiProvider.baseUrl}/api/delete_notification_by_id/$notificationId',
      );

      final response = await client.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return jsonData['status'] as bool? ?? false;
      } else {
        throw Exception('Failed to delete notification: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting notification: $e');
    }
  }

  @override
  Future<bool> deleteAllNotifications({
    required String token,
  }) async {
    try {
      final uri = Uri.parse('${ApiProvider.baseUrl}/api/delete_all_notifications_by_user');

      final response = await client.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return jsonData['status'] as bool? ?? false;
      } else {
        throw Exception('Failed bulk delete: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting all notifications: $e');
    }
  }

  @override
  Future<bool> markAllNotificationsAsRead({
    required String token,
  }) async {
    try {
      final uri = Uri.parse('${ApiProvider.baseUrl}/api/mark_all_notification_as_read_by_user');

      final response = await client.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return jsonData['status'] as bool? ?? false;
      } else {
        throw Exception('Failed bulk mark-as-read: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error marking all notifications as read: $e');
    }
  }

  @override
  void dispose() {
    client.close();
  }
}
