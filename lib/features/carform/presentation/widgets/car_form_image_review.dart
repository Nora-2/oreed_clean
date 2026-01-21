import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';

class CarFormImageReview extends StatelessWidget {
  final File? mainImage;
  final String? mainImageUrl;
  final List<String> galleryUrls;
  final List<File> galleryImages;
  final List<String> certImageUrls;
  final List<File> certImages;

  const CarFormImageReview({
    super.key,
    this.mainImage,
    this.mainImageUrl,
    this.galleryUrls = const [],
    this.galleryImages = const [],
    this.certImageUrls = const [],
    this.certImages = const [],
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    Widget box(Widget child) => ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(color: const Color(0xFFF5F6F9), child: child),
        );
    if (mainImage != null || mainImageUrl != null) {
      children.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              AppTranslations.of(context)?.text('review.main_image') ??
                  'Main image',
              style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: box(mainImage != null
                ? Image.file(mainImage!, fit: BoxFit.cover)
                : CachedNetworkImage(
                    imageUrl: mainImageUrl!,
                    fit: BoxFit.contain,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image, color: Colors.grey),
                  )),
          )
        ],
      ));
      children.add(const SizedBox(height: 12));
    }
    if (galleryUrls.isNotEmpty || galleryImages.isNotEmpty) {
      children.add(Text(
          AppTranslations.of(context)?.text('review.gallery_photos') ??
              'Gallery Photos',
          style: const TextStyle(fontWeight: FontWeight.w700)));
      children.add(const SizedBox(height: 6));
      final galleryWidgets = <Widget>[];
      for (final u in galleryUrls) {
        galleryWidgets.add(box(Image.network(u, fit: BoxFit.cover)));
      }
      for (final f in galleryImages) {
        galleryWidgets.add(box(Image.file(f, fit: BoxFit.cover)));
      }
      children.add(Wrap(
        spacing: 8,
        runSpacing: 8,
        children: galleryWidgets
            .map((w) => SizedBox(width: 70, height: 70, child: w))
            .toList(),
      ));
      children.add(const SizedBox(height: 12));
    }
    if (certImageUrls.isNotEmpty || certImages.isNotEmpty) {
      children.add(Text(
          AppTranslations.of(context)?.text('photos.certificate') ??
              'Certificate / Documents',
          style: const TextStyle(fontWeight: FontWeight.w700)));
      children.add(const SizedBox(height: 6));
      final certWidgets = <Widget>[];
      for (final u in certImageUrls) {
        certWidgets.add(box(Image.network(u, fit: BoxFit.cover)));
      }
      for (final f in certImages) {
        certWidgets.add(box(Image.file(f, fit: BoxFit.cover)));
      }
      children.add(Wrap(
        spacing: 8,
        runSpacing: 8,
        children: certWidgets
            .map((w) => SizedBox(width: 70, height: 70, child: w))
            .toList(),
      ));
    }
    if (children.isEmpty) {
      children.add(Text(
          AppTranslations.of(context)?.text('error.no_images') ?? 'No images',
          style: const TextStyle(color: Colors.grey)));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }
}
