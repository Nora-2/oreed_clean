import 'package:dio/dio.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final prefs = AppSharedPreferences();

    // Add Locale
    options.headers['locale'] = prefs.languageCode ?? 'ar';
    options.headers['Accept'] = 'application/json';

    // Add Token if available and not explicitly skipped
    if (options.extra['requiresAuth'] != false) {
      final token = prefs.userToken;
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    super.onRequest(options, handler);
  }
}
