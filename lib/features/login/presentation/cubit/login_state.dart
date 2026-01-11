import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

enum AuthStatus { idle, loading, success, error }

class AuthState extends Equatable {
  final bool isLoggedIn;
  final int? currentUserId;
  final String savedLocale;
  final String? errorMessage;
  final UserEntity? user;
  final AuthStatus status;

  const AuthState({
    this.isLoggedIn = false,
    this.currentUserId,
    this.savedLocale = 'ar',
    this.errorMessage,
    this.user,
    this.status = AuthStatus.idle,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    int? currentUserId,
    String? savedLocale,
    String? errorMessage,
    UserEntity? user,
    AuthStatus? status,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      currentUserId: currentUserId ?? this.currentUserId,
      savedLocale: savedLocale ?? this.savedLocale,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [isLoggedIn, currentUserId, savedLocale, errorMessage, user, status];
}