import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/shared_widgets/shimmer.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/image_preview.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/place_holder.dart';

class HeroImageTile extends StatelessWidget {
  const HeroImageTile({
    super.key,
    required this.file,
    this.imageUrl,
    required this.onAdd,
    required this.onChange,
    required this.onRemove,
    required this.borderColor,
    required this.accentColor,
    this.aspectRatio = 16 / 9,
    this.placeholderHeight = 125,

    // وضع الثمبنيل (صغير) + خيارات التسمية والحذف
    this.thumbnail = false,
    this.thumbSize = 76,
    this.showLabel = false,
    this.label,
    this.choosen,
    this.labelWidget, // 👈 جديد: تمكين ويدجت مخصص لليبل
    this.addTileRedStyle =
        false, // يخلي بلايسهولدر الإضافة بنفس شكل الصورة (إطار/نص أحمر)
    this.deleteBgColor = const Color(0xFFE11D48), // أحمر
  });

  final File? file;
  final String? imageUrl;
  final VoidCallback onAdd;
  final VoidCallback onChange;
  final VoidCallback onRemove;
  final Color borderColor;
  final Color accentColor;
  final double aspectRatio;
  final double placeholderHeight;

  // thumbnail mode + label
  final bool thumbnail;
  final double thumbSize;
  final bool showLabel;
  final String? label;
  final String? choosen;
  final Widget? labelWidget; // 👈 جديد
  final bool addTileRedStyle;
  final Color deleteBgColor;

  @override
  Widget build(BuildContext context) {
    if (thumbnail) {
      return _buildLabeledThumbnail(context);
    }

    // الوضع القديم (الكارد الكبيرة) — بدون أي تغيير سلوكي
    final radius = BorderRadius.circular(16);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: (file == null && imageUrl == null)
          ? AddPlaceholder(
              key: const ValueKey('placeholder'),
              height: placeholderHeight,
              radius: radius,
              borderColor: borderColor,
              accentColor: accentColor,
              onTap: onAdd,
            )
          : ImagePreview(
              key: const ValueKey('image'),
              file: file,
              imageUrl: imageUrl,
              radius: radius,
              aspectRatio: aspectRatio,
              borderColor: borderColor.withOpacity(.5),
              accentColor: accentColor,
              onChange: onChange,
              onRemove: onRemove,
            ),
    );
  }

  /// ثـمبنيل بمسمّى (يشبه الصورة المرفقة)
  Widget _buildLabeledThumbnail(BuildContext context) {
    final tile = _buildThumbnailTile(context); // صورة أو بلايسهولدر
    if (!showLabel) return tile;

    // Ensure finite constraints to avoid RenderFlex/BoxConstraints errors
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [tile],
    );
  }

  /// جسم الثمبنيل نفسه
  Widget _buildThumbnailTile(BuildContext context) {
    final t = AppTranslations.of(context);
    final isError = addTileRedStyle;

    if (file == null && imageUrl == null) {
      return InkWell(
        onTap: onAdd,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            // 1. The Floating Label with Red Asterisk
            label: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: label ?? (t?.text('photos.add_image') ?? 'Add Image'),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text: choosen ?? ' *',
                    style: choosen != null
                        ? TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          )
                        : const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ],
              ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            // Keeps label on border

            // 2. Borders
            contentPadding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isError ? Colors.grey.shade300 : Colors.grey.shade300,
                width: isError ? 1.2 : 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(AppIcons.uploadIcon, height: 32),
              const SizedBox(height: 12),
              Text(
                t?.text('photos.drag_drop_hint') ??
                    'Select file or JPG, PNG .. and drop it here',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                t?.text('photos.size_limit_hint') ??
                    'Max 10MB, JPG, PNG or PDF',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Selected image (either local file or network)
    return SizedBox(
      height: 130,
      width: 160,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: (imageUrl != null)
                  ? CachedNetworkImage(
                      width: double.infinity,
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const ShimmerBox(
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    )
                  : Image.file(
                      width: double.infinity,
                      file!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          // Delete Button
          Positioned(
            top: 8,
            right: 8,
            child: InkWell(
              onTap: onRemove,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  color: deleteBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.delete, color: Colors.white, size: 18),
              ),
            ),
          ),

          // Change Button
        ],
      ),
    );
  }
}
