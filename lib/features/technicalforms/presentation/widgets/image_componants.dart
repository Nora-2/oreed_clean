import 'dart:io';
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/hero_image_tile.dart';

class MainImageTileWidget extends StatelessWidget {
  final File? mainImageFile;
  final String? mainImageUrl;
  final VoidCallback onImagePicked;
  final VoidCallback onRemove;
  final AppTranslations? appTrans;

  const MainImageTileWidget({
    super.key,
    required this.mainImageFile,
    required this.mainImageUrl,
    required this.onImagePicked,
    required this.onRemove,
    this.appTrans,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: mainImageFile != null
          ? HeroImageTile(
              file: mainImageFile,
              onAdd: onImagePicked,
              onChange: onImagePicked,
              onRemove: onRemove,
              borderColor: const Color(0xFFE5E7EB),
              accentColor: AppColors.primary,
              thumbnail: true,
              thumbSize: 110,
              showLabel: true,
              label: appTrans?.text('photos.main_image') ?? 'Main image',
              addTileRedStyle: false,
              deleteBgColor: const Color(0xFFE11D48),
            )
          : (mainImageUrl != null
                ? _RemoteImagePreview(
                    imageUrl: mainImageUrl!,
                    onEdit: onImagePicked,
                  )
                : HeroImageTile(
                    file: null,
                    onAdd: onImagePicked,
                    onChange: () {},
                    onRemove: () {},
                    borderColor: const Color(0xFFE5E7EB),
                    accentColor: AppColors.secondary,
                    thumbnail: true,
                    thumbSize: 110,
                    showLabel: true,
                    label: appTrans?.text('add_image') ?? 'Add image',
                    addTileRedStyle: true,
                    deleteBgColor: const Color(0xFFE11D48),
                  )),
    );
  }
}

class _RemoteImagePreview extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onEdit;

  const _RemoteImagePreview({required this.imageUrl, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFF0EA5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, size: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class GalleryAddTile extends StatelessWidget {
  final VoidCallback onAdd;
  final AppTranslations? appTrans;

  const GalleryAddTile({super.key, required this.onAdd, this.appTrans});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: HeroImageTile(
        file: null,
        onAdd: onAdd,
        onChange: onAdd,
        onRemove: () {},
        borderColor: const Color(0xFFE5E7EB),
        accentColor: AppColors.primary,
        thumbnail: true,
        thumbSize: 110,
        showLabel: true,
        label: appTrans?.text('photos.add_gallery') ?? 'Add gallery images',
        addTileRedStyle: true,
        deleteBgColor: const Color(0xFFE11D48),
      ),
    );
  }
}
