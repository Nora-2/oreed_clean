import 'package:dio/dio.dart';
import 'package:oreed_clean/core/network/api_constants.dart';
import 'package:oreed_clean/core/network/api_error_handler.dart';
import 'package:oreed_clean/core/network/api_result.dart';
import 'package:oreed_clean/core/network/dio_factory.dart';

class ApiService {
  final Dio _dio = DioFactory.getDio();

  // GET request
  Future<ApiResult<T>> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.apiBaseUrl}$endpoint',
        queryParameters: queryParameters,
      );
      return ApiResult.success(fromJson(response.data));
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  // POST request
  Future<ApiResult<T>> post<T>({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.apiBaseUrl}$endpoint',
        data: data,
        queryParameters: queryParameters,
      );
      return ApiResult.success(fromJson(response.data));
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  // PUT request
  Future<ApiResult<T>> put<T>({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.apiBaseUrl}$endpoint',
        data: data,
        queryParameters: queryParameters,
      );
      return ApiResult.success(fromJson(response.data));
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  // DELETE request
  Future<ApiResult<T>> delete<T>({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        '${ApiConstants.apiBaseUrl}$endpoint',
        data: data,
        queryParameters: queryParameters,
      );
      return ApiResult.success(fromJson(response.data));
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  // PATCH request
  Future<ApiResult<T>> patch<T>({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        '${ApiConstants.apiBaseUrl}$endpoint',
        data: data,
        queryParameters: queryParameters,
      );
      return ApiResult.success(fromJson(response.data));
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  // Upload file with multipart
  Future<ApiResult<T>> uploadFile<T>({
    required String endpoint,
    required FormData formData,
    void Function(int, int)? onSendProgress,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.apiBaseUrl}$endpoint',
        data: formData,
        onSendProgress: onSendProgress,
      );
      return ApiResult.success(fromJson(response.data));
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  // Download file
  Future<ApiResult<String>> downloadFile({
    required String endpoint,
    required String savePath,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      await _dio.download(
        '${ApiConstants.apiBaseUrl}$endpoint',
        savePath,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResult.success(savePath);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}