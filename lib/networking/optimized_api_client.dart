// lib/networking/optimized_api_client.dart
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/networking/api_provider.dart';
import 'package:oreed_clean/networking/exception.dart';
import 'response.dart';

/// Optimized API Client with:
/// - Request caching
/// - Retry logic
/// - Request deduplication
/// - Memory optimization
/// - Better error handling
class OptimizedApiClient {
  // Use centralized base URL from ApiProvider
  // note: append path segments like '/api' or '/api/v1' when needed in callers
  // static const String baseUrl = ApiProvider.baseUrl; // use ApiProvider.baseUrl directly where needed
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const int maxRetries = 2;

  // Cache for GET requests (memory optimized)
  final Map<String, _CacheEntry> _cache = {};
  static const Duration cacheExpiry = Duration(minutes: 5);
  static const int maxCacheSize = 50; // Limit cache size

  // Request deduplication - prevent duplicate simultaneous requests
  final Map<String, Future<Response>> _pendingRequests = {};

  // Singleton pattern
  static final OptimizedApiClient _instance = OptimizedApiClient._internal();
  factory OptimizedApiClient() => _instance;
  OptimizedApiClient._internal();

  /// Build headers with token and locale
  Map<String, String> _buildHeaders({bool hasToken = false}) {
    final prefs = AppSharedPreferences();
    final headers = <String, String>{
      HttpHeaders.acceptHeader: 'application/json',
      'locale': prefs.languageCode ?? 'ar',
    };

    if (hasToken && prefs.userToken != null && prefs.userToken!.isNotEmpty) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer ${prefs.userToken}';
    }
    return headers;
  }

  /// GET request with caching and retry logic
  Future<Response<T>> get<T>(
    String url, {
    bool hasToken = false,
    bool useCache = true,
    T Function(dynamic json)? parser,
  }) async {
    final cacheKey = '${url}_$hasToken';

    // Check cache first (if enabled)
    if (useCache && _cache.containsKey(cacheKey)) {
      final entry = _cache[cacheKey]!;
      if (!entry.isExpired) {
        log('📦 Cache HIT: $url');
        return entry.response as Response<T>;
      } else {
        _cache.remove(cacheKey);
      }
    }

    // Check for pending request (deduplication)
    if (_pendingRequests.containsKey(cacheKey)) {
      log('🔄 Deduplicating request: $url');
      return _pendingRequests[cacheKey] as Future<Response<T>>;
    }

    // Create new request
    final requestFuture = _executeGet<T>(url, hasToken: hasToken, parser: parser);
    _pendingRequests[cacheKey] = requestFuture;

    try {
      final response = await requestFuture;

      // Cache successful GET responses
      if (useCache && response.status == Status.COMPLETED) {
        _addToCache(cacheKey, response);
      }

      return response;
    } finally {
      _pendingRequests.remove(cacheKey);
    }
  }

  /// Execute GET request with retry logic
  Future<Response<T>> _executeGet<T>(
    String url, {
    required bool hasToken,
    T Function(dynamic json)? parser,
  }) async {
    int retryCount = 0;

    while (retryCount <= maxRetries) {
      try {
        final uri = Uri.parse(ApiProvider.baseUrl + url);
        log('🌐 GET: $uri ${retryCount > 0 ? "(retry $retryCount)" : ""}');

        final response = await http
            .get(uri, headers: _buildHeaders(hasToken: hasToken))
            .timeout(defaultTimeout);

        return _handleResponse(response, parser);
      } on SocketException {
        if (retryCount == maxRetries) {
          throw FetchDataException("No internet connection");
        }
        retryCount++;
        await Future.delayed(Duration(seconds: retryCount)); // Exponential backoff
      } on TimeoutException {
        if (retryCount == maxRetries) {
          throw FetchDataException("Request timeout");
        }
        retryCount++;
        await Future.delayed(Duration(seconds: retryCount));
      }
    }

    throw FetchDataException("Request failed after $maxRetries retries");
  }

  /// POST request (optimized multipart handling)
  Future<Response<T>> post<T>(
    String url,
    Map body, {
    bool hasToken = false,
    bool isPut = false,
    T Function(dynamic json)? parser,
  }) async {
    try {
      final headers = _buildHeaders(hasToken: hasToken);
      final uri = Uri.parse(ApiProvider.baseUrl + url);
      final method = isPut ? 'PUT' : 'POST';

      log('🌐 $method: $uri');

      // Optimize: Only use multipart if we have files
      final hasFiles = body.values.any((v) => v is File || v is List<int>);

      if (hasFiles) {
        return await _postMultipart<T>(uri, method, headers, body, parser);
      } else {
        return await _postJson<T>(uri, method, headers, body, parser);
      }
    } on SocketException {
      throw FetchDataException("No internet connection");
    } on TimeoutException {
      throw FetchDataException("Request timeout");
    }
  }

  /// POST with JSON body (faster for non-file uploads)
  Future<Response<T>> _postJson<T>(
    Uri uri,
    String method,
    Map<String, String> headers,
    Map body,
    T Function(dynamic json)? parser,
  ) async {
    headers['Content-Type'] = 'application/json';

    final jsonBody = jsonEncode(body);

    final response = method == 'PUT'
        ? await http.put(uri, headers: headers, body: jsonBody).timeout(defaultTimeout)
        : await http.post(uri, headers: headers, body: jsonBody).timeout(defaultTimeout);

    return _handleResponse(response, parser);
  }

  /// POST with multipart form-data (for file uploads)
  Future<Response<T>> _postMultipart<T>(
    Uri uri,
    String method,
    Map<String, String> headers,
    Map body,
    T Function(dynamic json)? parser,
  ) async {
    final request = http.MultipartRequest(method, uri);
    request.headers.addAll(headers);

    for (final entry in body.entries) {
      final key = entry.key;
      final value = entry.value;
      if (value == null) continue;

      if (value is File) {
        final bytes = await value.readAsBytes();
        final filename = value.path.split(Platform.pathSeparator).last;
        request.files.add(
          http.MultipartFile.fromBytes(key, bytes, filename: filename),
        );
      } else if (value is List<int>) {
        request.files.add(
          http.MultipartFile.fromBytes(key, value, filename: key),
        );
      } else {
        request.fields[key] = value.toString();
      }
    }

    final streamedResponse = await request.send().timeout(defaultTimeout);
    final response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response, parser);
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String url, {
    bool hasToken = false,
    T Function(dynamic json)? parser,
  }) async {
    try {
      final uri = Uri.parse(ApiProvider.baseUrl + url);
      log('🌐 DELETE: $uri');

      final response = await http
          .delete(uri, headers: _buildHeaders(hasToken: hasToken))
          .timeout(defaultTimeout);

      return _handleResponse(response, parser);
    } on SocketException {
      throw FetchDataException("No internet connection");
    } on TimeoutException {
      throw FetchDataException("Request timeout");
    }
  }

  /// Handle HTTP response
  Response<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic json)? parser,
  ) {
    final statusCode = response.statusCode;

    // Parse JSON response
    dynamic jsonBody;
    try {
      jsonBody = response.body.isNotEmpty ? json.decode(response.body) : null;
    } catch (e) {
      log('❌ JSON parsing error: $e');
      jsonBody = null;
    }

    log('📥 Response [$statusCode]: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...');

    switch (statusCode) {
      case 200:
      case 201:
        if (parser != null) {
          return Response.completed(parser(jsonBody));
        } else {
          return Response.completed(jsonBody as T);
        }

      case 400:
      case 401:
      case 403:
      case 422:
        throw ErrorMessgeException(
          bodyWithErrors: jsonBody ?? {'message': 'Client error'},
        );

      case 500:
      case 502:
      case 503:
        String msg = "Server error $statusCode";
        try {
          if (jsonBody is Map) {
            msg = jsonBody['msg']?.toString() ??
                  jsonBody['message']?.toString() ??
                  msg;
          }
        } catch (_) {}
        throw FetchDataException(msg);

      default:
        throw FetchDataException("Unexpected error $statusCode");
    }
  }

  /// Add response to cache with size limit
  void _addToCache(String key, Response response) {
    // Remove oldest entries if cache is full
    if (_cache.length >= maxCacheSize) {
      final oldestKey = _cache.keys.first;
      _cache.remove(oldestKey);
    }

    _cache[key] = _CacheEntry(
      response: response,
      timestamp: DateTime.now(),
    );
  }

  /// Clear all cache
  void clearCache() {
    _cache.clear();
    log('🗑️ Cache cleared');
  }

  /// Clear specific cache entry
  void clearCacheEntry(String url) {
    _cache.removeWhere((key, _) => key.contains(url));
  }

  /// Cancel all pending requests (useful for dispose)
  void cancelPendingRequests() {
    _pendingRequests.clear();
  }
}

/// Cache entry with timestamp
class _CacheEntry {
  final Response response;
  final DateTime timestamp;

  _CacheEntry({
    required this.response,
    required this.timestamp,
  });

  bool get isExpired {
    return DateTime.now().difference(timestamp) > OptimizedApiClient.cacheExpiry;
  }
}


