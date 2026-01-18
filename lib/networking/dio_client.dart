import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:oreed_clean/core/error/failures.dart';
import 'package:oreed_clean/networking/api_provider.dart';
import 'package:oreed_clean/networking/interceptors/auth_interceptor.dart';
import 'package:oreed_clean/networking/interceptors/logger_interceptor.dart';
import 'package:oreed_clean/networking/result.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiProvider.baseUrl, // Reuse existing base URL
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(),
      if (kDebugMode) LoggerInterceptor(),
      // Add more interceptors here (Retry, etc.)
    ]);
  }

  // Expose Dio for advanced use cases (e.g. download)
  Dio get dio => _dio;

  /// GET Request
  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    required T Function(dynamic data) converter,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return Success(converter(response.data));
    } on DioException catch (e) {
      return Error(_handleDioError(e));
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  /// POST Request
  Future<Result<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    required T Function(dynamic data) converter,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return Success(converter(response.data));
    } on DioException catch (e) {
      return Error(_handleDioError(e));
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  /// PUT Request
  Future<Result<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    required T Function(dynamic data) converter,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return Success(converter(response.data));
    } on DioException catch (e) {
      return Error(_handleDioError(e));
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  /// DELETE Request
  Future<Result<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    required T Function(dynamic data) converter,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return Success(converter(response.data));
    } on DioException catch (e) {
      return Error(_handleDioError(e));
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  Failure _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const NetworkFailure("Connection timed out");
    }

    if (error.type == DioExceptionType.connectionError ||
        error.error is SocketException) {
      return const NetworkFailure("No internet connection");
    }

    if (error.response != null) {
      final statusCode = error.response?.statusCode;
      final data = error.response?.data;

      String message = "Unknown Error";
      // Try to parse error message from server response
      if (data is Map) {
        message = data['msg'] ?? data['message'] ?? "Server Error";
      } else if (data is String) {
        message = data;
      }

      switch (statusCode) {
        case 401:
          return AuthFailure(message, statusCode);
        case 403:
          return AuthFailure("Forbidden: $message", statusCode);
        case 400:
        case 422:
          return ValidationFailure(message, statusCode);
        case 500:
        case 502:
        case 503:
          return ServerFailure("Server Error: $message", statusCode);
        default:
          return ServerFailure(message, statusCode);
      }
    }

    return UnknownFailure(error.message ?? "Unknown Dio Error");
  }
}
