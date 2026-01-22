import 'dart:io';
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/anythingform/domain/entities/anything_details_entity.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/hero_image_tile.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/image_source_sheet.dart';

class AnythingImagesSection extends StatelessWidget {
  final File? mainImageFile;
  final String? mainImageUrl;
  final List<MediaItem> galleryRemote;
  final List<File> galleryLocal;
  final Set<int> deletingRemote;

  final Future<void> Function(ImageSourceChoice) onPickMainImage;
  final Future<void> Function(ImageSourceChoice) onPickGalleryImage;
  final VoidCallback onRemoveMainImage;
  final Function(int index) onRemoveLocalGalleryImage;
  final Function(MediaItem item) onConfirmDeleteRemoteImage;

  const AnythingImagesSection({
    super.key,
    required this.mainImageFile,
    required this.mainImageUrl,
    required this.galleryRemote,
    required this.galleryLocal,
    required this.deletingRemote,
    required this.onPickMainImage,
    required this.onPickGalleryImage,
    required this.onRemoveMainImage,
    required this.onRemoveLocalGalleryImage,
    required this.onConfirmDeleteRemoteImage,
  });

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);
    return Column(
      children: [
        _buildMainImageTile(context, appTrans),
        const SizedBox(height: 20),
        _buildGalleryAddTile(context, appTrans),
        const SizedBox(height: 30),
        _buildGalleryGrid(),
      ],
    );
  }

  Widget _buildMainImageTile(BuildContext context, AppTranslations? appTrans) {
    return SizedBox(
      height: 150,
      child: mainImageFile != null
          ? HeroImageTile(
              file: mainImageFile,
              onAdd: () async {
                final choice = await showImageSourceSheet(context);
                if (choice != null) await onPickMainImage(choice);
              },
              onChange: () async {
                final choice = await showImageSourceSheet(context);
                if (choice != null) await onPickMainImage(choice);
              },
              onRemove: onRemoveMainImage,
              borderColor: const Color(0xFFE5E7EB),
              accentColor: AppColors.primary,
              thumbnail: true,
              thumbSize: 110,
              showLabel: true,
              label: appTrans?.text('photos.main_image') ?? 'الصورة الرئيسية',
              addTileRedStyle: false,
              deleteBgColor: const Color(0xFFE11D48),
            )
          : (mainImageUrl != null
              ? Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          mainImageUrl!,
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
                        onTap: () async {
                          final choice = await showImageSourceSheet(context);
                          if (choice != null) await onPickMainImage(choice);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0EA5E9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          appTrans?.text('photos.main_image') ??
                              'الصورة الرئيسية',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : HeroImageTile(
                  file: null,
                  onAdd: () async {
                    final choice = await showImageSourceSheet(context);
                    if (choice != null) await onPickMainImage(choice);
                  },
                  onChange: () {},
                  onRemove: () {},
                  borderColor: const Color(0xFFE5E7EB),
                  accentColor: AppColors.secondary,
                  thumbnail: true,
                  thumbSize: 110,
                  showLabel: true,
                  label: appTrans?.text('photos.add_main_image') ??
                      'إضافة الصورة الرئيسية',
                  addTileRedStyle: true,
                  deleteBgColor: const Color(0xFFE11D48),
                )),
    );
  }

  Widget _buildGalleryAddTile(BuildContext context, AppTranslations? appTrans) {
    return SizedBox(
      height: 150,
      child: HeroImageTile(
        file: null,
        onAdd: () async {
          final choice = await showImageSourceSheet(context);
          if (choice != null) await onPickGalleryImage(choice);
        },
        onChange: () async {
          final choice = await showImageSourceSheet(context);
          if (choice != null) await onPickGalleryImage(choice);
        },
        onRemove: () {},
        borderColor: const Color(0xFFE5E7EB),
        accentColor: AppColors.primary,
        thumbnail: true,
        thumbSize: 110,
        showLabel: true,
        label: appTrans?.text('photos.add_gallery') ?? 'إضافة صور المعرض',
        addTileRedStyle: true,
        deleteBgColor: const Color(0xFFE11D48),
      ),
    );
  }

  Widget _buildGalleryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: galleryRemote.length + galleryLocal.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        mainAxisExtent: 100,
      ),
      itemBuilder: (context, i) {
        if (i < galleryRemote.length) {
          final mediaItem = galleryRemote[i];
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  mediaItem.url,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 6,
                top: 6,
                child: deletingRemote.contains(mediaItem.id)
                    ? Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () => onConfirmDeleteRemoteImage(mediaItem),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFE11D48),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ],
          );
        } else {
          final localIndex = i - galleryRemote.length;
          final f = galleryLocal[localIndex];
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  f,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 6,
                top: 6,
                child: GestureDetector(
                  onTap: () => onRemoveLocalGalleryImage(localIndex),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE11D48),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
