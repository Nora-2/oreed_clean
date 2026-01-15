part of 'moretab_cubit.dart';

enum MoreStatus {
  initial,
  loading,
  success,
  error,
  actionLoading,
  actionSuccess,
  actionError,
}

class MoreState extends Equatable {
  final List<PageModel> pages;
  final MoreStatus status;
  final String? errorMessage;
  final String? actionMessage; // For success messages like "Account Deleted"

  const MoreState({
    this.pages = const [],
    this.status = MoreStatus.initial,
    this.errorMessage,
    this.actionMessage,
  });

  MoreState copyWith({
    List<PageModel>? pages,
    MoreStatus? status,
    String? errorMessage,
    String? actionMessage,
  }) {
    return MoreState(
      pages: pages ?? this.pages,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      actionMessage: actionMessage ?? this.actionMessage,
    );
  }

  @override
  List<Object?> get props => [pages, status, errorMessage, actionMessage];
}
