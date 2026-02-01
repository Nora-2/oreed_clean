import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_state.dart';
import '../../domain/usecases/login_usecase.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final AppSharedPreferences _prefs = AppSharedPreferences();

  AuthCubit(this.loginUseCase) : super(const AuthState()) {
    init();
  }

  // ====== Initialization ======
  Future<void> init() async {
    final lang = _prefs.languageCode ?? 'ar';
    final userId = _prefs.userId;
    final loggedIn = _prefs.isLoggedIn;

    emit(
      state.copyWith(
        savedLocale: lang,
        currentUserId: userId,
        isLoggedIn: loggedIn,
      ),
    );
    log("AuthCubit Initialized: userId: $userId, isLoggedIn: $loggedIn");
  }

  // ====== Actions ======

  Future<void> changeLocale(String langCode) async {
    await _prefs.saveAppLang(langCode);
    emit(state.copyWith(savedLocale: langCode));
  }

  Future<void> login({
    required String phone,
    required String password,
    required String fcmToken,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

    final result = await loginUseCase(
      phone: phone,
      password: password,
      fcmToken: fcmToken,
    );

    await result.when(
      success: (user) async {
        // 1. Save to SharedPreferences
        await _prefs.saveUserId(user.id);
        await _prefs.saveUserName(user.name);
        await _prefs.saveUserType(user.accountType);
        await _prefs.saveUserToken(user.token ?? '');
        await _prefs.saveuserPhone(user.phone);
        await _prefs.saveLoggedIn(true);

        // 2. Emit Success State
        emit(
          state.copyWith(
            status: AuthStatus.success,
            user: user,
            isLoggedIn: true,
            currentUserId: user.id,
          ),
        );

        log("✅ Login success -> userId: ${user.id}");
      },
      failure: (errorHandler) {
        // 3. Emit Error State using the message from the API error handler
        final message = errorHandler.apiErrorModel.message;

        log("❌ Login failed: $message");

        emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: message,
            isLoggedIn: false,
          ),
        );
      },
    );
  }

  Future<void> signOut() async {
    _prefs.clearPrefs();
    emit(const AuthState(status: AuthStatus.idle, isLoggedIn: false));
  }
}
