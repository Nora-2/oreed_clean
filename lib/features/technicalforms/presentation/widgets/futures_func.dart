import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/networking/api_provider.dart';

Future<bool> deleteRemoteImageApi({
  required String adId,
  required String imageId,
  context,
  mounted,
}) async {
  try {
    final token =
        AppSharedPreferences().getUserToken ?? AppSharedPreferences().userToken;
    if (token == null || token.trim().isEmpty) {
      if (mounted) {
        final appTrans = AppTranslations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              appTrans?.text('auth.login_required_action') ??
                  'Please login to perform this action',
            ),
          ),
        );
      }
      return false;
    }

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final uri = Uri.parse(
      '${ApiProvider.baseUrl}/api/v1/remove_technician_image',
    );
    final request = http.MultipartRequest('POST', uri);
    request.fields.addAll({'ad_id': adId, 'image_id': imageId});
    request.headers.addAll(headers);

    final streamed = await request.send();
    return streamed.statusCode == 200;
  } catch (e) {
    return false;
  }
}
