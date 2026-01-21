// mixins/car_form_image_picker_mixin.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/image_source_sheet.dart';

mixin CarFormImagePickerMixin<T extends StatefulWidget> on State<T> {
  final ImagePicker picker = ImagePicker();

  Future<void> pickFromGallery(List<File> target) async {
    final imgs = await picker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );
    if (imgs.isEmpty) return;
    setState(() => target.addAll(imgs.map((e) => File(e.path))));
  }

  Future<void> pickFromCamera(List<File> target) async {
    final x = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );
    if (x != null) setState(() => target.add(File(x.path)));
  }

  Future<File?> pickSingleFromGallery() async {
    final x = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );
    return x != null ? File(x.path) : null;
  }

  Future<File?> pickSingleFromCamera() async {
    final x = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );
    return x != null ? File(x.path) : null;
  }

  Future<void> chooseImageSourceAndPick({
    required BuildContext context,
    required List<File> target,
    bool replaceCert = false,
  }) async {
    if (replaceCert && target.isNotEmpty) {
      target.clear();
    }

    final choice = await showImageSourceSheet(context);
    if (choice == ImageSourceChoice.camera) {
      await pickFromCamera(target);
    } else if (choice == ImageSourceChoice.gallery) {
      await pickFromGallery(target);
    }
  }

  Future<File?> chooseImageSourceAndPickSingle(BuildContext context) async {
    final choice = await showImageSourceSheet(context);
    if (choice == ImageSourceChoice.camera) {
      return await pickSingleFromCamera();
    } else if (choice == ImageSourceChoice.gallery) {
      return await pickSingleFromGallery();
    }
    return null;
  }
}
