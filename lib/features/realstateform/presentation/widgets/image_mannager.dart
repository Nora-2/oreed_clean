// utils/image_manager.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/country_entity.dart';
import 'package:oreed_clean/features/realstateform/data/models/properity_form_wizerd_state.dart';
import 'package:oreed_clean/features/realstateform/data/models/realstate_detailes_model.dart';
import 'package:oreed_clean/features/realstateform/domain/entities/realstate_detailes_entity.dart';
import 'package:oreed_clean/features/realstateform/presentation/cubit/realstateform_cubit.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/state_entity.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/image_source_sheet.dart';
import 'package:oreed_clean/networking/api_provider.dart';

// class ImageSlot {
//   final File? file;
//   final String? url;
//   final int? imageId;

//   ImageSlot({this.file, this.url, this.imageId});
// }

class ImageManager {
  final VoidCallback onStateChanged;
  final bool isEditing;
  final int? adId;

  ImageManager({
    required this.onStateChanged,
    required this.isEditing,
    this.adId,
  });

  final _picker = ImagePicker();
  final List<ImageSlot> _images = [];
  ImageSlot? _mainImage;
  static const int _maxImages = 12;

  List<CountryEntity> cachedCountries = [];
  List<StateEntity> cachedStates = [];

  List<ImageSlot> get images => _images;
  ImageSlot? get mainImage => _mainImage;

  void _limitSnack(BuildContext context) {
    final appTrans = AppTranslations.of(context);
    final message =
        appTrans?.text('error.max_images') ?? 'وصلت للحد الأقصى للصور (12)';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> pickFromGallery(
    BuildContext context, {
    int? replaceIndex,
  }) async {
    if (_images.length >= _maxImages) {
      _limitSnack(context);
      return;
    }

    final imgs = await _picker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );

    if (imgs.isEmpty) return;

    final room = _maxImages - _images.length;
    final picked = imgs
        .take(room)
        .map((e) => ImageSlot(file: File(e.path)))
        .toList();

    if (replaceIndex != null && picked.isNotEmpty) {
      _images[replaceIndex] = picked.first;
      if (picked.length > 1) _images.addAll(picked.skip(1));
    } else {
      _images.addAll(picked);
    }

    onStateChanged();
  }

  Future<void> pickFromCamera(BuildContext context, {int? replaceIndex}) async {
    if (_images.length >= _maxImages) {
      _limitSnack(context);
      return;
    }

    final x = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );

    if (x == null) return;

    final slot = ImageSlot(file: File(x.path));
    if (replaceIndex != null) {
      _images[replaceIndex] = slot;
    } else {
      _images.add(slot);
    }

    onStateChanged();
  }

  Future<void> chooseImageSourceAndPick(
    BuildContext context, {
    int? replaceIndex,
  }) async {
    final choice = await showImageSourceSheet(context);
    if (choice == ImageSourceChoice.camera) {
      await pickFromCamera(context, replaceIndex: replaceIndex);
    } else if (choice == ImageSourceChoice.gallery) {
      await pickFromGallery(context, replaceIndex: replaceIndex);
    }
  }

  Future<void> handleMainImagePick(BuildContext context) async {
    final choice = await showImageSourceSheet(context);
    if (choice == ImageSourceChoice.camera) {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (image != null) {
        _mainImage = ImageSlot(file: File(image.path));
        onStateChanged();
      }
    } else if (choice == ImageSourceChoice.gallery) {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (image != null) {
        _mainImage = ImageSlot(file: File(image.path));
        onStateChanged();
      }
    }
  }

  Future<void> handleRemoveImage(BuildContext context, int imgIndex) async {
    final slot = _images[imgIndex];

    if (slot.file != null || slot.imageId == null) {
      _images.removeAt(imgIndex);
      onStateChanged();
      return;
    }

    final appTrans = AppTranslations.of(context);
    final choice = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(appTrans?.text('confirm.delete') ?? 'Confirm'),
        content: Text(
          appTrans?.text('confirm.delete_image') ?? 'Delete this image?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'cancel'),
            child: Text(appTrans?.text('action.cancel') ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'delete'),
            child: Text(appTrans?.text('action.delete') ?? 'Delete'),
          ),
        ],
      ),
    );

    if (choice == null || choice == 'cancel') return;

    if (adId != null && slot.imageId != null) {
      final success = await _deleteRemoteImage(
        adId: adId!,
        imageId: slot.imageId!,
      );
      if (success) {
        final cubit = context.read<RealstateformCubit>();
        await cubit.fetchPropertyDetails(adId!);
      }
    }
  }

  Future<void> handleRemoveMainImage(BuildContext context) async {
    if (_mainImage == null) return;
    final slot = _mainImage!;

    if (slot.file != null || slot.imageId == null) {
      _mainImage = null;
      onStateChanged();
      return;
    }

    final appTrans = AppTranslations.of(context);
    final choice = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(appTrans?.text('confirm.delete') ?? 'Confirm'),
        content: Text(
          appTrans?.text('confirm.delete_image') ?? 'Delete this image?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'cancel'),
            child: Text(appTrans?.text('action.cancel') ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'replace'),
            child: Text(appTrans?.text('action.replace') ?? 'Replace'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'delete'),
            child: Text(appTrans?.text('action.delete') ?? 'Delete'),
          ),
        ],
      ),
    );

    if (choice == null || choice == 'cancel') return;

    if (choice == 'replace') {
      await handleMainImagePick(context);
      return;
    }

    if (adId != null && slot.imageId != null) {
      final success = await _deleteRemoteImage(
        adId: adId!,
        imageId: slot.imageId!,
      );
      if (success) {
        final cubit = context.read<RealstateformCubit>();
        await cubit.fetchPropertyDetails(adId!);
      }
    }
  }

  Future<void> handleGalleryImageChange(
    BuildContext context,
    AppTranslations? appTrans,
    int index,
  ) async {
    final choice = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(appTrans?.text('action.choose') ?? 'اختر'),
        content: Text(appTrans?.text('photos.options') ?? 'اختر إجراءً:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'replace'),
            child: Text(appTrans?.text('action.replace') ?? 'استبدال'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'set_main'),
            child: Text(appTrans?.text('photos.set_main') ?? 'تعيين كرئيسية'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: Text(appTrans?.text('action.cancel') ?? 'إلغاء'),
          ),
        ],
      ),
    );

    if (choice == 'replace') {
      await chooseImageSourceAndPick(context, replaceIndex: index);
    } else if (choice == 'set_main') {
      await _handleSetAsMain(context, index);
    }
  }

  Future<void> _handleSetAsMain(BuildContext context, int imgIndex) async {
    final slot = _images[imgIndex];
    final appTrans = AppTranslations.of(context);

    if (slot.file != null) {
      _images.removeAt(imgIndex);
      _mainImage = ImageSlot(file: slot.file, imageId: slot.imageId);
      onStateChanged();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            appTrans?.text('success.set_main') ?? 'تم تعيين الصورة كرئيسية',
          ),
        ),
      );
      return;
    }

    if (slot.url == null) return;

    try {
      final res = await http.get(Uri.parse(slot.url!));
      if (res.statusCode == 200) {
        final bytes = res.bodyBytes;
        final tmpDir = Directory.systemTemp.createTempSync('oreed_');
        String ext = 'jpg';
        try {
          final parts = slot.url!.split('?').first.split('.');
          if (parts.isNotEmpty) ext = parts.last;
          if (ext.length > 5) ext = 'jpg';
        } catch (_) {}
        final tmpFile = File('${tmpDir.path}/promoted_main.$ext');
        await tmpFile.writeAsBytes(bytes);

        _images.removeAt(imgIndex);
        _mainImage = ImageSlot(file: tmpFile, imageId: slot.imageId);
        onStateChanged();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              appTrans?.text('success.set_main') ?? 'تم تعيين الصورة كرئيسية',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            appTrans?.text('error.fetch_image') ?? 'خطأ في جلب الصورة',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<bool> _deleteRemoteImage({
    required int adId,
    required int imageId,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiProvider.baseUrl}/api/v1/remove_property_image',
      );
      final prefs = AppSharedPreferences();
      final token = prefs.getUserToken;

      final request = http.MultipartRequest('POST', uri);
      request.fields.addAll({
        'ad_id': adId.toString(),
        'image_id': imageId.toString(),
      });

      final headers = <String, String>{'Accept': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      request.headers.addAll(headers);

      final streamed = await request.send();
      final body = await streamed.stream.bytesToString();

      if (streamed.statusCode == 200) {
        try {
          final j = json.decode(body);
          return (j['status'] == true) || (j['code'] == 200);
        } catch (_) {
          return true;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  void loadDetailsImages(PropertyDetailsEntity details) {
    _images.clear();
    _mainImage = null;

    if (details.mainImage != null && details.mainImage!.isNotEmpty) {
      int? mainId;
      if (details is PropertyDetailsModel) {
        final found = details.mediaMaps.firstWhere(
          (m) => (m['original_url']?.toString() ?? '') == details.mainImage,
          orElse: () => {},
        );
        if (found.isNotEmpty && found['id'] != null) {
          mainId = (found['id'] is int)
              ? found['id'] as int
              : int.tryParse(found['id']?.toString() ?? '');
        }
      }
      _mainImage = ImageSlot(url: details.mainImage, imageId: mainId);
    }

    if (details.media.isNotEmpty) {
      if (details is PropertyDetailsModel) {
        _images.addAll(
          details.mediaMaps
              .where((m) => m['original_url']?.toString() != details.mainImage)
              .map(
                (m) => ImageSlot(
                  url: m['original_url']?.toString(),
                  imageId: (m['id'] is int)
                      ? m['id'] as int
                      : int.tryParse(m['id']?.toString() ?? ''),
                ),
              ),
        );
      } else {
        _images.addAll(
          details.media
              .where((u) => u != details.mainImage)
              .map((u) => ImageSlot(url: u)),
        );
      }
    }
  }
}
