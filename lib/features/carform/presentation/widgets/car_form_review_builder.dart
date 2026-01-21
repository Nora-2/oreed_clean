// builders/car_form_review_builder.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/features/carform/data/models/brand.dart';
import 'package:oreed_clean/features/carform/data/models/carmodel.dart';
import 'package:oreed_clean/features/carform/presentation/widgets/car_form_helpers.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/review_section.dart';
import '../widgets/car_form_image_review.dart';

class CarFormReviewBuilder {
  static List<ReviewSection> buildReviewSections({
    required AppTranslations? t,
    required TextEditingController titleCtrl,
    required TextEditingController priceCtrl,
    required TextEditingController kmCtrl,
    required Brand? brand,
    required CarModel? model,
    required String? condition,
    required String? colorName,
    required String? yearSelected,
    required String? engineCc,
    required String? fuel,
    required String? gear,
    required String? paint,
    required String? governorateId,
    required String? cityId,
    required File? mainImage,
    required String? mainImageUrl,
    required List<String> galleryUrls,
    required List<File> galleryImages,
    required List<String> certImageUrls,
    required List<File> certImages,
  }) {
    final basics = ReviewSection(
      keyName: 'basics',
      title: t?.text('review.basics') ?? 'Basics',
      items: [
        ReviewItem(
          label: t?.text('field.title') ?? 'Title',
          value: CarFormHelpers.dashIfEmpty(titleCtrl.text),
        ),
        ReviewItem(
          label: t?.text('field.brand') ?? 'Brand',
          value: CarFormHelpers.dashIfEmpty(brand?.name),
        ),
        ReviewItem(
          label: t?.text('field.model') ?? 'Model',
          value: CarFormHelpers.dashIfEmpty(model?.name),
        ),
        ReviewItem(
          label: t?.text('field.price') ?? 'Price',
          value: CarFormHelpers.formatMoney(priceCtrl.text.trim(), t),
        ),
        ReviewItem(
          label: t?.text('field.condition') ?? 'Condition',
          value: CarFormHelpers.dashIfEmpty(condition),
        ),
      ],
    );

    final specs = ReviewSection(
      keyName: 'specs',
      title: t?.text('review.specs') ?? 'Specifications',
      items: [
        ReviewItem(
          label: t?.text('field.color') ?? 'Color',
          value: CarFormHelpers.dashIfEmpty(colorName),
        ),
        ReviewItem(
          label: t?.text('field.year') ?? 'Manufacture Year',
          value: CarFormHelpers.dashIfEmpty(yearSelected),
        ),
        ReviewItem(
          label: t?.text('field.engine_size') ?? 'Engine CC',
          value: CarFormHelpers.dashIfEmpty(engineCc),
        ),
        ReviewItem(
          label: t?.text('field.fuel') ?? 'Fuel Type',
          value: CarFormHelpers.dashIfEmpty(fuel),
        ),
        ReviewItem(
          label: t?.text('field.gear') ?? 'Transmission',
          value: CarFormHelpers.dashIfEmpty(gear),
        ),
        ReviewItem(
          label: t?.text('field.paint') ?? 'Paint Condition',
          value: CarFormHelpers.dashIfEmpty(paint),
        ),
        ReviewItem(
          label: t?.text('field.km') ?? 'Kilometers (KM)',
          value: CarFormHelpers.dashIfEmpty(kmCtrl.text.trim()),
        ),
      ],
    );

    final location = ReviewSection(
      keyName: 'location',
      title: t?.text('review.location') ?? 'Location',
      items: [
        ReviewItem(
          label: t?.text('field.state') ?? 'State/Province',
          value: CarFormHelpers.dashIfEmpty(governorateId),
        ),
        ReviewItem(
          label: t?.text('field.city') ?? 'City/Region',
          value: CarFormHelpers.dashIfEmpty(cityId),
        ),
      ],
    );

    final imagesSection = ReviewSection(
      keyName: 'images',
      title: t?.text('review.images') ?? 'Photos',
      items: const [],
      custom: CarFormImageReview(
        mainImage: mainImage,
        mainImageUrl: mainImageUrl,
        galleryUrls: galleryUrls,
        galleryImages: galleryImages,
        certImageUrls: certImageUrls,
        certImages: certImages,
      ),
    );

    return [basics, specs, location, imagesSection];
  }
}
