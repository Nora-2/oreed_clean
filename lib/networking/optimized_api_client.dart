import 'package:dio/dio.dart';

class OptimizedApiClient {
  final Dio dio;
  OptimizedApiClient(this.dio);

  Future<Response> post(String path, Map<String, dynamic> data) async {
    // Use FormData for compatibility with multipart/form-data endpoints
    final form = FormData.fromMap(data);
    return dio.post(path, data: form);
  }

  // convenience wrapper if raw map expected
  Future<Response> postJson(String path, Map<String, dynamic> json) async {
    return dio.post(path, data: json, options: Options(headers: {'Content-Type': 'application/json'}));
  }
}

