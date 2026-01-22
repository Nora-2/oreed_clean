import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/state_manager.dart';

class AnythingImagePickerHandler {
  final AnythingFormStateManager stateManager;
  final VoidCallback onUpdate;
  final _picker = ImagePicker();

  AnythingImagePickerHandler({
    required this.stateManager,
    required this.onUpdate,
  });

  Future<void> pickMainFromGallery() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );
    if (image != null) {
      stateManager.mainImageFile = File(image.path);
      stateManager.mainImageUrl = null;
      onUpdate();
    }
  }

  Future<void> pickMainFromCamera() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );
    if (image != null) {
      stateManager.mainImageFile = File(image.path);
      stateManager.mainImageUrl = null;
      onUpdate();
    }
  }

  Future<void> pickGalleryFromGallery() async {
    final images = await _picker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );
    if (images.isNotEmpty) {
      stateManager.galleryLocal.addAll(images.map((e) => File(e.path)));
      onUpdate();
    }
  }

  Future<void> pickGalleryFromCamera() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );
    if (image != null) {
      stateManager.galleryLocal.add(File(image.path));
      onUpdate();
    }
  }

  void removeMainImage() {
    stateManager.mainImageFile = null;
    onUpdate();
  }

  void removeLocalGalleryAt(int i) {
    stateManager.galleryLocal.removeAt(i);
    onUpdate();
  }
}
