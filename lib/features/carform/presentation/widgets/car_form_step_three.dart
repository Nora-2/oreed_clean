import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_form_field.dart';
import 'package:oreed_clean/features/realstateform/presentation/widgets/SectionCard.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/hero_image_tile.dart';

class CarFormStepThree extends StatelessWidget {
  final TextEditingController descCtrl;
  final File? mainImage;
  final String? mainImageUrl;
  final List<String> galleryUrls;
  final List<int> galleryIds;
  final List<File> galleryImages;
  final List<String> certImageUrls;
  final List<int> certImageIds;
  final List<File> certImages;
  final String? carDocumentsPlaceholder;
  
  final VoidCallback onMainImagePick;
  final VoidCallback onMainImageRemove;
  
  final VoidCallback onGalleryPick;
  final void Function(int index) onGalleryLocalRemove;
  final void Function(int index, int id) onGalleryRemoteRemove;

  final VoidCallback onCertPick;
  final VoidCallback onCertRemove;
  final VoidCallback onCertRemoteRemove; // Removes the single remote cert image

  const CarFormStepThree({
    super.key,
    required this.descCtrl,
    this.mainImage,
    this.mainImageUrl,
    required this.galleryUrls,
    required this.galleryIds,
    required this.galleryImages,
    required this.certImageUrls,
    required this.certImageIds,
    required this.certImages,
    this.carDocumentsPlaceholder,
    required this.onMainImagePick,
    required this.onMainImageRemove,
    required this.onGalleryPick,
    required this.onGalleryLocalRemove,
    required this.onGalleryRemoteRemove,
    required this.onCertPick,
    required this.onCertRemove,
    required this.onCertRemoteRemove,
  });

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);
    final _blue = AppColors.primary;

    return Column(
      children: [
        const SizedBox(height: 30),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: descCtrl,
                hint: appTrans?.text('hint.description') ??
                    'Enter details of your product/service...',
                min: 5,
                max: 10,
                keyboardType: TextInputType.multiline,
                label: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: appTrans?.text('field.description') ??
                            'Product Description',
                      ),
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                validator: (String? p1) {
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 160,
                height: 160,
                child: HeroImageTile(
                  file: mainImage,
                  imageUrl: mainImageUrl,
                  onAdd: onMainImagePick,
                  onChange: onMainImagePick,
                  onRemove: onMainImageRemove,
                  borderColor: const Color(0xFFE5E7EB),
                  accentColor: _blue,
                  thumbnail: true,
                  thumbSize: 110,
                  showLabel: true,
                  label: appTrans?.text('photos.main_image') ?? 'Add Main Image',
                  addTileRedStyle: true,
                  deleteBgColor: const Color(0xFFE11D48),
                ),
              ),

              SizedBox(
                width: 160,
                height: 180,
                child: HeroImageTile(
                  file: null,
                  onAdd: onGalleryPick,
                  onChange: () {},
                  onRemove: () {},
                  borderColor: const Color(0xFFE5E7EB),
                  accentColor: AppColors.accentLight,
                  thumbnail: true,
                  thumbSize: 110,
                  showLabel: true,
                  label: appTrans?.text('photos.title'),
                  addTileRedStyle: true,
                  deleteBgColor: AppColors.accentLight,
                ),
              ),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: galleryUrls.length + galleryImages.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 130,
                ),
                itemBuilder: (context, index) {
                  // Show remote gallery images first
                  if (index < galleryUrls.length) {
                    final url = galleryUrls[index];
                    final imageId =
                        (index < galleryIds.length) ? galleryIds[index] : null;
                    final isFirstImage = index == 0;

                    return SizedBox(
                      width: double.infinity,
                      child: HeroImageTile(
                        key: ValueKey('remote_$imageId'),
                        file: null,
                        imageUrl: url,
                        onAdd: () {},
                        onChange: () {},
                        onRemove: () {
                          if (imageId != null) {
                            onGalleryRemoteRemove(index, imageId);
                          }
                        },
                        borderColor: const Color(0xFFE5E7EB),
                        accentColor: AppColors.accentLight,
                        thumbnail: true,
                        thumbSize: 110,
                        showLabel: true,
                        labelWidget: isFirstImage
                            ? Text.rich(TextSpan(children: [
                                TextSpan(
                                    text: appTrans?.text('photos.main') ??
                                        'الرئيسية ',
                                    style: const TextStyle(
                                        color: AppColors.accentLight,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12)),
                                TextSpan(
                                    text: appTrans?.text('photos.front') ??
                                        '(الواجهة)',
                                    style: const TextStyle(
                                        color: AppColors.accentLight,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12))
                              ]))
                            : null,
                        label: isFirstImage
                            ? null
                            : (appTrans?.text('photos.image_label') ??
                                'الصورة ${index + 1}'),
                        addTileRedStyle: false,
                        deleteBgColor: AppColors.accentLight,
                      ),
                    );
                  }

                  // Show local images after remote gallery
                  final localIndex = index - galleryUrls.length;
                  final isFirstOverall = galleryUrls.isEmpty && localIndex == 0;

                  return HeroImageTile(
                    key: ValueKey('local_$localIndex'),
                    file: galleryImages[localIndex],
                    onAdd: () {},
                    onChange: () {},
                    onRemove: () => onGalleryLocalRemove(localIndex),
                    borderColor: const Color(0xFFE5E7EB),
                    accentColor: _blue,
                    thumbnail: true,
                    thumbSize: 110,
                    showLabel: true,
                    labelWidget: isFirstOverall
                        ? Text.rich(TextSpan(children: [
                            TextSpan(
                                text:
                                    appTrans?.text('photos.main') ?? 'الرئيسية ',
                                style: const TextStyle(
                                    color: AppColors.accentLight,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12)),
                            TextSpan(
                                text:
                                    appTrans?.text('photos.front') ?? '(الواجهة)',
                                style: const TextStyle(
                                    color: AppColors.accentLight,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12))
                          ]))
                        : null,
                    label: isFirstOverall
                        ? null
                        : (appTrans?.text('photos.image_label') ??
                            'الصورة ${index + 1}'),
                    addTileRedStyle: false,
                    deleteBgColor: const Color(0xFFE11D48),
                  );
                },
              ),
              const SizedBox(height: 16),
              // ===== شهادة الفحص (صورة واحدة فقط) =====
              _buildCertificateImageSection(context, appTrans),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCertificateImageSection(
      BuildContext context, AppTranslations? appTrans) {
    // Check if we have an existing URL from server (edit mode)
    final bool hasExistingImage = certImageUrls.isNotEmpty;
    final bool hasLocalImage = certImages.isNotEmpty;
    final _blue = AppColors.primary;

    // Display the image if exists, otherwise show add button
    if (hasExistingImage) {
      final url = certImageUrls.first;
      // final id = certImageIds.isNotEmpty ? certImageIds.first : null;

      return HeroImageTile(
        file: null,
        imageUrl: url,
        onAdd: () {},
        onChange: onCertPick, // Allow replacing
        onRemove: onCertRemoteRemove,
        borderColor: const Color(0xFFE5E7EB),
        accentColor: _blue,
        thumbnail: true,
        thumbSize: 110,
        showLabel: true,
        label: appTrans?.text('photos.certificate') ?? 'شهادة الفحص',
        addTileRedStyle: false,
        deleteBgColor: const Color(0xFFE11D48),
      );
    } else if (hasLocalImage) {
      return HeroImageTile(
        file: certImages.first,
        onAdd: () {},
        onChange: onCertPick,
        onRemove: onCertRemove,
        borderColor: const Color(0xFFE5E7EB),
        accentColor: _blue,
        thumbnail: true,
        thumbSize: 110,
        showLabel: true,
        label: appTrans?.text('photos.certificate') ?? 'شهادة الفحص',
        addTileRedStyle: false,
        deleteBgColor: const Color(0xFFE11D48),
      );
    } else {
      // Show add button
      return HeroImageTile(
        file: null,
        onAdd: onCertPick,
        onChange: () {},
        onRemove: () {},
        imageUrl: carDocumentsPlaceholder,
        borderColor: const Color(0xFFE5E7EB),
        accentColor: _blue,
        thumbnail: true,
        thumbSize: 110,
        showLabel: true,
        label: appTrans?.text('photos.certificate') ?? 'Inspection Certificate',
        choosen: appTrans?.text('photos.certificate_optional') ??
            '  ( Optional inspection certificate image )',
        addTileRedStyle: true,
        deleteBgColor: const Color(0xFFE11D48),
      );
    }
  }
}
