part of 'notification_cubit.dart';


enum NotificationsStatus { initial, loading, success, error, loadingMore }

class NotificationsState extends Equatable {
  final NotificationsStatus status;
  final List<NotificationModel> notifications;
  final String? errorMessage;
  final PaginationModel? pagination;
  final int currentPage;
  final bool hasMoreData;

  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.errorMessage,
    this.pagination,
    this.currentPage = 1,
    this.hasMoreData = true,
  });

  // Helper getters for the UI
  int get unreadCount => notifications.where((n) => !n.isRead).length;
  bool get isLoading => status == NotificationsStatus.loading;
  bool get isLoadingMore => status == NotificationsStatus.loadingMore;
  bool get hasError => status == NotificationsStatus.error;
  bool get isEmpty => notifications.isEmpty;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationModel>? notifications,
    String? errorMessage,
    PaginationModel? pagination,
    int? currentPage,
    bool? hasMoreData,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage ?? this.errorMessage,
      pagination: pagination ?? this.pagination,
      currentPage: currentPage ?? this.currentPage,
      hasMoreData: hasMoreData ?? this.hasMoreData,
    );
  }

  @override
  List<Object?> get props => [
        status,
        notifications,
        errorMessage,
        pagination,
        currentPage,
        hasMoreData,
      ];
}