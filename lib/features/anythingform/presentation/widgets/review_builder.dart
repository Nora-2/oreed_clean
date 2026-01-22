import 'dart:io';
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/state_manager.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/review_section.dart';

class AnythingReviewBuilder {
  final AnythingFormStateManager stateManager;

  AnythingReviewBuilder({required this.stateManager});

  List<ReviewSection> buildSections(AppTranslations? appTrans) {
    final sections = <ReviewSection>[
      _buildBasicSection(appTrans),
      _buildDetailsSection(appTrans),
      _buildLocationSection(appTrans),
    ];

    final mainImageSection = _buildMainImageSection(appTrans);
    if (mainImageSection != null) sections.add(mainImageSection);

    final gallerySection = _buildGallerySection(appTrans);
    if (gallerySection != null) sections.add(gallerySection);

    return sections;
  }

  ReviewSection _buildBasicSection(AppTranslations? appTrans) {
    return ReviewSection(
      keyName: 'basic',
      title: appTrans?.text('review.basics') ?? 'الأساسيات',
      items: [
        ReviewItem(
          label: appTrans?.text('field.title') ?? 'الاسم',
          value: _dash(stateManager.titleCtrl.text),
        ),
        ReviewItem(
          label: appTrans?.text('field.price') ?? 'السعر',
          value: _money(stateManager.priceCtrl.text, appTrans),
        ),
      ],
    );
  }

  ReviewSection _buildDetailsSection(AppTranslations? appTrans) {
    return ReviewSection(
      keyName: 'details',
      title: appTrans?.text('review.details') ?? 'التفاصيل',
      items: [
        ReviewItem(
          label: appTrans?.text('field.description') ?? 'الوصف',
          value: _dash(stateManager.descCtrl.text),
        ),
      ],
    );
  }

  ReviewSection _buildLocationSection(AppTranslations? appTrans) {
    return ReviewSection(
      keyName: 'location',
      title: appTrans?.text('review.location') ?? 'الموقع',
      items: [
        ReviewItem(
          label: appTrans?.text('field.state') ?? 'المحافظة',
          value: _dash(stateManager.selectedCountryName),
        ),
        ReviewItem(
          label: appTrans?.text('field.city') ?? 'المدينة',
          value: _dash(stateManager.selectedStateName),
        ),
      ],
    );
  }

  ReviewSection? _buildMainImageSection(AppTranslations? appTrans) {
    final List<File> mainImageForReview = [];
    if (stateManager.mainImageFile != null) {
      mainImageForReview.add(stateManager.mainImageFile!);
    }

    if (mainImageForReview.isNotEmpty) {
      return ReviewSection(
        keyName: 'main_photo',
        title: appTrans?.text('photos.main_image') ?? 'الصورة الرئيسية',
        items: const [],
        images: mainImageForReview,
      );
    } else if (stateManager.mainImageUrl != null) {
      return ReviewSection(
        keyName: 'main_photo_info',
        title: appTrans?.text('photos.main_image') ?? 'الصورة الرئيسية',
        items: [
          ReviewItem(
            label: appTrans?.text('photos.current_image') ?? 'الصورة الحالية',
            value:
                appTrans?.text('photos.image_exists') ?? 'موجودة على الخادم',
            icon: Icons.check_circle,
          ),
        ],
      );
    }
    return null;
  }

  ReviewSection? _buildGallerySection(AppTranslations? appTrans) {
    final List<File> galleryImagesForReview = [...stateManager.galleryLocal];

    if (galleryImagesForReview.isNotEmpty) {
      return ReviewSection(
        keyName: 'gallery_photos',
        title: appTrans?.text('photos.gallery') ?? 'صور المعرض',
        items: const [],
        images: galleryImagesForReview,
      );
    } else if (stateManager.galleryRemote.isNotEmpty) {
      return ReviewSection(
        keyName: 'gallery_info',
        title: appTrans?.text('photos.gallery') ?? 'صور المعرض',
        items: [
          ReviewItem(
            label: appTrans?.text('photos.current_images') ?? 'الصور الحالية',
            value:
                '${stateManager.galleryRemote.length} ${appTrans?.text('photos.images_on_server') ?? 'صورة على الخادم'}',
            icon: Icons.photo_library,
          ),
        ],
      );
    }
    return null;
  }

  String _dash(String? v) => (v == null || v.trim().isEmpty) ? '-' : v;
  
  String _money(String v, AppTranslations? appTrans) =>
      v.trim().isEmpty ? '-' : '$v ${appTrans?.text('currency') ?? 'د.ك'}';
}
