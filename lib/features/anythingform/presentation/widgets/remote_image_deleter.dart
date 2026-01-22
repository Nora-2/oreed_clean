import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/features/anythingform/domain/entities/anything_details_entity.dart';
import 'package:oreed_clean/features/anythingform/presentation/cubit/create_anything_cubit.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/state_manager.dart';
import 'package:oreed_clean/networking/api_provider.dart';

class AnythingRemoteImageDeleter {
  final AnythingFormStateManager stateManager;
  final VoidCallback onUpdate;

  AnythingRemoteImageDeleter({
    required this.stateManager,
    required this.onUpdate,
  });

  Future<bool> deleteRemoteImageApi({
    required String adId,
    required String sectionId,
    required String imageId,
  }) async {
    try {
      final token =
          AppSharedPreferences().getUserToken ??
          AppSharedPreferences().userToken;
      if (token == null || token.trim().isEmpty) {
        return false;
      }

      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final uri = Uri.parse(
        ApiProvider.baseUrl + '/api/v1/remove_anything_image',
      );
      final request = http.MultipartRequest('POST', uri);
      request.fields.addAll({
        'ad_id': adId,
        'section_id': sectionId,
        'image_id': imageId,
      });
      request.headers.addAll(headers);

      final streamed = await request.send();
      return streamed.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> confirmAndDelete(
    BuildContext context,
    MediaItem mediaItem,
    int adId,
    int sectionId,
  ) async {
    AppTranslations? appTrans = AppTranslations.of(context);
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(appTrans?.text('common.confirm') ?? 'Confirm'),
        content: Text(
          appTrans?.text('photos.confirm_delete') ??
              'Are you sure you want to delete this image?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(appTrans?.text('common.no') ?? 'No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(appTrans?.text('common.yes') ?? 'Yes'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    stateManager.deletingRemote.add(mediaItem.id);
    onUpdate();

    final success = await deleteRemoteImageApi(
      adId: adId.toString(),
      sectionId: sectionId.toString(),
      imageId: mediaItem.id.toString(),
    );

    stateManager.deletingRemote.remove(mediaItem.id);
    onUpdate();

    if (success) {
      await _refreshDetailsAfterDelete(context, adId, sectionId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              appTrans?.text('photos.image_deleted') ?? 'Image deleted',
            ),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              appTrans?.text('photos.delete_failed') ??
                  'Failed to delete image',
            ),
          ),
        );
      }
    }
  }

  Future<void> _refreshDetailsAfterDelete(
    BuildContext context,
    int adId,
    int sectionId,
  ) async {
    AppTranslations? appTrans = AppTranslations.of(context);
    try {
      final cubit = context.read<CreateAnythingCubit>();
      await cubit.loadDetails(adId, sectionId);

      final details = cubit.state.loadedDetails;
      if (details != null && context.mounted) {
        stateManager.galleryRemote
          ..clear()
          ..addAll(details.media);
        if (stateManager.mainImageFile == null) {
          stateManager.mainImageUrl = details.mainImage;
        }
        onUpdate();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${appTrans?.text('ad_details.error_occurred') ?? 'Error'}: ${e.toString()}',
            ),
          ),
        );
      }
    }
  }
}
