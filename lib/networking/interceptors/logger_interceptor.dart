import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      log('➡️ [${options.method}] ${options.path}');
      log('📝 Params: ${options.queryParameters}');
      if (options.data != null) log('📦 Data: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      log('✅ [${response.statusCode}] ${response.requestOptions.path}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      log('❌ [${err.response?.statusCode ?? 'ERR'}] ${err.requestOptions.path}');
      log('⚠️ Error: ${err.message}');
      if (err.response != null) log('📄 Response: ${err.response?.data}');
    }
    super.onError(err, handler);
  }
}
