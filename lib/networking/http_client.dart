import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpClientService {
  final http.Client _client;
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  HttpClientService( {
    required http.Client client,
    required this.baseUrl,
    this.defaultHeaders = const {},
  }) : _client = client;

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, String>? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final mergedHeaders = {
      'Accept': 'application/json',
      ...defaultHeaders,
      if (headers != null) ...headers,
    };

    final response =
        await _client.post(uri, headers: mergedHeaders, body: body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonMap = json.decode(utf8.decode(response.bodyBytes));
      if (jsonMap is Map<String, dynamic>) return jsonMap;
      throw const FormatException('Invalid JSON format');
    }

    throw HttpError(statusCode: response.statusCode, body: response.body);
  }

  /// ✅ Generic GET request (same behavior as `post`)
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
  
    final uri =
        Uri.parse('$baseUrl$path').replace(queryParameters: queryParameters);
    final mergedHeaders = {
      'Accept': 'application/json',
      ...defaultHeaders,
      if (headers != null) ...headers,
    };

    final response = await _client.get(uri, headers: mergedHeaders);
  
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonMap = json.decode(utf8.decode(response.bodyBytes));
      if (jsonMap is Map<String, dynamic>) return jsonMap;
      throw const FormatException('Invalid JSON format');
    }

    throw HttpError(statusCode: response.statusCode, body: response.body);
  }
}

class HttpError implements Exception {
  final int statusCode;
  final String body;

  const HttpError({required this.statusCode, required this.body});

  @override
  String toString() => 'HttpError($statusCode): $body';
}
