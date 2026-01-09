// lib/networking/api_provider.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/networking/exception.dart';
import 'package:oreed_clean/networking/response.dart';

class ApiProvider {
  static const String baseUrl = "https://oreedo.net";

  Map<String, String> _buildHeaders({bool hasToken = false}) {
    final prefs = AppSharedPreferences();
    final headers = <String, String>{
      HttpHeaders.acceptHeader: 'application/json',
      "locale": AppSharedPreferences().languageCode ?? 'ar',
      // DO NOT set Content-Type here for multipart; the request will set it.
    };

    if (hasToken && prefs.userToken != null && prefs.userToken!.isNotEmpty) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer ${prefs.userToken}';
    }
    return headers;
  }

  Future<Response<T>> get<T>(
    String url, {
    bool hasToken = false,
    T Function(dynamic json)? parser,
  }) async {
    try {
      final uri = Uri.parse(baseUrl + url);
      final response = await http
          .get(uri, headers: _buildHeaders(hasToken: hasToken))
          .timeout(const Duration(seconds: 30));
      return _handleResponse(response, parser);
    } on SocketException {
      throw FetchDataException("No internet connection");
    }
  }

  /// Posts using multipart/form-data for better compatibility with servers
  /// that expect form-data (like Postman form-data).
  /// `body` can contain String, int, double, File, List<int> (bytes).
  Future<Response<T>> post<T>(
    String url,
    Map body, {
    bool hasToken = false,
    bool isPut = false,
    T Function(dynamic json)? parser,
  }) async {
    try {
      final headers = _buildHeaders(hasToken: hasToken);
      final uri = Uri.parse(baseUrl + url);

      // Build multipart request so text-only form-data also sent as multipart/form-data
      final method = isPut ? 'PUT' : 'POST';
      final request = http.MultipartRequest(method, uri);

      // Attach headers (leave Content-Type to MultipartRequest)
      request.headers.addAll(headers);

      // Populate fields/files
      for (final entry in body.entries) {
        final key = entry.key;
        final value = entry.value;
        if (value == null) continue;

        if (value is File) {
          // read file bytes asynchronously then create MultipartFile from bytes
          final bytes = await value.readAsBytes();
          final filename = value.path.split(Platform.pathSeparator).last;
          final filePart =
              http.MultipartFile.fromBytes(key, bytes, filename: filename);
          request.files.add(filePart);
        } else if (value is List<int>) {
          // already bytes
          final filePart =
              http.MultipartFile.fromBytes(key, value, filename: key);
          request.files.add(filePart);
        } else {
          // treat as string field
          request.fields[key] = value.toString();
        }
      }

      // Debug: print fields and files

      // Send request
      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 120));
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response, parser);
    } on SocketException {
      throw FetchDataException("No internet connection");
    }
  }

  Future<Response<T>> delete<T>(
    String url, {
    bool hasToken = false,
    T Function(dynamic json)? parser,
  }) async {
    try {
      final uri = Uri.parse(baseUrl + url);
      final response = await http
          .delete(uri, headers: _buildHeaders(hasToken: hasToken))
          .timeout(const Duration(seconds: 30));
      return _handleResponse(response, parser);
    } on SocketException {
      throw FetchDataException("No internet connection");
    }
  }

  Response<T> _handleResponse<T>(
      http.Response response, T Function(dynamic json)? parser) {
    final statusCode = response.statusCode;

    // Try decode body safely
    dynamic jsonBody;
    try {
      jsonBody = response.body.isNotEmpty ? json.decode(response.body) : null;
    } catch (_) {
      jsonBody = null;
    }

    switch (statusCode) {
      case 200:
      case 201:
        // success
        if (parser != null) {
          return Response.completed(parser(jsonBody));
        } else {
          return Response.completed(jsonBody as T);
        }

      case 400:
      case 401:
      case 403:
      case 422:
        // validation / auth / client errors - return structured error
        throw ErrorMessgeException(
            bodyWithErrors: jsonBody ?? {'message': 'Client error'});
      case 500:
        // server error - attempt to extract meaningful msg if present
        String msg = "Server error ${response.statusCode}";
        try {
          if (jsonBody is Map) {
            if (jsonBody.containsKey('msg')) {
              msg = jsonBody['msg'].toString();
            } else if (jsonBody.containsKey('message')) {
              msg = jsonBody['message'].toString();
            }
          }
        } catch (_) {
          // ignore parsing errors
        }
        throw FetchDataException(msg);
      default:
        throw FetchDataException("Server error ${response.statusCode}");
    }
  }
}
