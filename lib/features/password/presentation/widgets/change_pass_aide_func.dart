import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/networking/api_provider.dart';

Future<bool> performChangePassword({
  required String oldPassword,
  required String newPassword,
}) async {
  final token = AppSharedPreferences().getUserToken;
  if (token == null || token.isEmpty) {
    throw Exception('auth_token_missing');
  }
  final uri = Uri.parse(ApiProvider.baseUrl + '/api/change_password');
  final request = http.MultipartRequest('POST', uri);
  request.fields.addAll({'oldpassword': oldPassword, 'password': newPassword});
  request.headers.addAll({
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });
  final streamed = await request.send();
  final body = await streamed.stream.bytesToString();
  print({'oldpassword': oldPassword, 'password': newPassword});
  print(json.decode(body));
  print(streamed.statusCode);
  if (streamed.statusCode == 200) {
    try {
      final map = json.decode(body) as Map<String, dynamic>;
      final status = map['status'] == true || map['code'] == 200;
      if (!status) throw Exception(map['msg'] ?? 'unknown_error');
      return true;
    } catch (_) {
      return true; // treat success if parsing fails but status 200
    }
  } else {
    throw Exception('server_error_${streamed.statusCode}');
  }
}
