// utils/review_builder.dart
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/features/realstateform/data/models/properity_form_wizerd_state.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/review_section.dart';

class ReviewBuilder {
  static String _dash(String? v) => (v == null || v.trim().isEmpty) ? '-' : v;

  static String _money(String v, AppTranslations? appTrans) =>
      v.trim().isEmpty ? '-' : '$v ${appTrans?.text('currency_kwd') ?? 'د.ك'}';

  static List<ReviewSection> buildReviewSections({
    required AppTranslations? appTrans,
    required TextEditingController titleCtrl,
    required TextEditingController priceCtrl,
    required TextEditingController areaCtrl,
    required TextEditingController descCtrl,
    required String? rooms,
    required String? baths,
    required String? floor,
    required String? countryId,
    required String? stateId,
    required ImageSlot? mainImage,
    required List<ImageSlot> images,
  }) {
    final basics = ReviewSection(
      keyName: 'basics',
      title: appTrans?.text('review.basics') ?? 'الأساسيات',
      items: [
        ReviewItem(
          label: appTrans?.text('field.title') ?? 'العنوان',
          value: _dash(titleCtrl.text.trim()),
        ),
        ReviewItem(
          label: appTrans?.text('field.price') ?? 'السعر',
          value: _money(priceCtrl.text.trim(), appTrans),
        ),
      ],
    );

    final specs = ReviewSection(
      keyName: 'specs',
      title: appTrans?.text('review.specs') ?? 'المواصفات',
      items: [
        ReviewItem(
          label: appTrans?.text('field.rooms') ?? 'عدد الغرف',
          value: _dash(rooms),
        ),
        ReviewItem(
          label: appTrans?.text('field.baths') ?? 'عدد الحمامات',
          value: _dash(baths),
        ),
        ReviewItem(
          label: appTrans?.text('field.area') ?? 'المساحة',
          value: _dash(areaCtrl.text.trim()),
        ),
        ReviewItem(
          label: appTrans?.text('field.floor') ?? 'الدور',
          value: _dash(floor),
        ),
      ],
    );

    final location = ReviewSection(
      keyName: 'location',
      title: appTrans?.text('review.location') ?? 'الموقع',
      items: [
        ReviewItem(
          label: appTrans?.text('field.country') ?? 'الدولة',
          value: _dash(countryId),
        ),
        ReviewItem(
          label: appTrans?.text('field.state') ?? 'المحافظة',
          value: _dash(stateId),
        ),
      ],
    );

    final description = ReviewSection(
      keyName: 'description',
      title: appTrans?.text('review.description') ?? 'الوصف',
      items: [
        ReviewItem(
          label: appTrans?.text('field.description') ?? 'Description',
          value: _dash(descCtrl.text.trim()),
        ),
      ],
    );

    final imagesSection = ReviewSection(
      keyName: 'images',
      title: appTrans?.text('review.images') ?? 'الصور',
      items: const [],
      custom: _buildImagesReviewWidget(appTrans, mainImage, images),
    );

    return [basics, specs, location, description, imagesSection];
  }

  static Widget _buildImagesReviewWidget(
    AppTranslations? appTrans,
    ImageSlot? mainImage,
    List<ImageSlot> images,
  ) {
    final List<Widget> children = [];

    Widget box(Widget child) => ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(color: const Color(0xFFF5F6F9), child: child),
    );

    if (mainImage?.file != null || mainImage?.url != null) {
      children.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appTrans?.text('photos.main_image') ?? 'Main Image',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 120,
              width: double.infinity,
              child: box(
                mainImage?.file != null
                    ? Image.file(mainImage!.file!, fit: BoxFit.cover)
                    : Image.network(
                        mainImage!.url!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, color: Colors.grey),
                      ),
              ),
            ),
          ],
        ),
      );
      children.add(const SizedBox(height: 12));
    }

    final galleryImages = images
        .where((s) => s.file != null || s.url != null)
        .toList();
    if (galleryImages.isNotEmpty) {
      children.add(
        Text(
          appTrans?.text('photos.gallery') ?? 'Gallery',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      );
      children.add(const SizedBox(height: 6));
      final galleryWidgets = <Widget>[];
      for (final img in galleryImages) {
        if (img.file != null) {
          galleryWidgets.add(box(Image.file(img.file!, fit: BoxFit.cover)));
        } else if (img.url != null) {
          galleryWidgets.add(
            box(
              Image.network(
                img.url!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          );
        }
      }
      children.add(
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: galleryWidgets
              .map((w) => SizedBox(width: 70, height: 70, child: w))
              .toList(),
        ),
      );
      children.add(const SizedBox(height: 12));
    }

    if (children.isEmpty) {
      children.add(
        Text(
          appTrans?.text('photos.no_images') ?? 'No images',
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
