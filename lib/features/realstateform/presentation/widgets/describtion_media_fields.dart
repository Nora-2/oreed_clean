// widgets/description_media_fields.dart
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_form_field.dart';
import 'package:oreed_clean/features/realstateform/presentation/widgets/SectionCard.dart';
import 'package:oreed_clean/features/realstateform/presentation/widgets/field_label.dart';
import 'package:oreed_clean/features/realstateform/presentation/widgets/image_mannager.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/hero_image_tile.dart';

class DescriptionMediaFields extends StatelessWidget {
  final TextEditingController descCtrl;
  final ImageManager imageManager;

  const DescriptionMediaFields({
    super.key,
    required this.descCtrl,
    required this.imageManager,
  });

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDescriptionField(appTrans),
          const SizedBox(height: 30),
          _buildMainImageTile(context, appTrans),
          const SizedBox(height: 30),
          _buildAddImageTile(context, appTrans),
          FieldLabel(appTrans?.text('photos.title') ?? 'صور العقار'),
          _buildImageGrid(context, appTrans),
        ],
      ),
    );
  }

  Widget _buildDescriptionField(AppTranslations? appTrans) {
    return AppTextField(
      controller: descCtrl,
      hint:
          appTrans?.text('hint.description') ?? 'اكتب تفاصيل الخدمة/المنتج...',
      min: 5,
      max: 10,
      keyboardType: TextInputType.multiline,
      label: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: appTrans?.text('field.description') ?? 'الوصف'),
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
      validator: (String? p1) => null,
    );
  }

  Widget _buildMainImageTile(BuildContext context, AppTranslations? appTrans) {
    return SizedBox(
      width: double.infinity,
      height: 160,
      child: HeroImageTile(
        file: imageManager.mainImage?.file,
        imageUrl: imageManager.mainImage?.url,
        onAdd: () => imageManager.handleMainImagePick(context),
        onChange: () => imageManager.handleMainImagePick(context),
        onRemove: () => imageManager.handleRemoveMainImage(context),
        borderColor: const Color(0xFFE5E7EB),
        accentColor: AppColors.primary,
        thumbnail: true,
        thumbSize: 110,
        showLabel: true,
        label: appTrans?.text('photos.add_image') ?? 'إضافة صورة',
        addTileRedStyle: true,
        deleteBgColor: Colors.red,
      ),
    );
  }

  Widget _buildAddImageTile(BuildContext context, AppTranslations? appTrans) {
    return SizedBox(
      width: double.infinity,
      height: 140,
      child: HeroImageTile(
        file: null,
        onAdd: () => imageManager.chooseImageSourceAndPick(context),
        onChange: () {},
        onRemove: () {},
        borderColor: const Color(0xFFE5E7EB),
        accentColor: AppColors.primary,
        thumbnail: true,
        thumbSize: 110,
        showLabel: true,
        label: appTrans?.text('photos.title') ?? 'إضافة صورة',
        addTileRedStyle: true,
        deleteBgColor: Colors.red,
      ),
    );
  }

  Widget _buildImageGrid(BuildContext context, AppTranslations? appTrans) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: imageManager.images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 16,
        mainAxisExtent: 100,
      ),
      itemBuilder: (context, index) {
        final slot = imageManager.images[index];
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: slot.file != null
                  ? Image.file(
                      slot.file!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      slot.url!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            Positioned(
              right: 6,
              top: 6,
              child: GestureDetector(
                onTap: () => imageManager.handleRemoveImage(context, index),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFE11D48),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.delete,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 6,
              bottom: 6,
              child: GestureDetector(
                onTap: () => imageManager.handleGalleryImageChange(
                  context,
                  appTrans,
                  index,
                ),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
