
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/shared_widgets/shimmer.dart';
import 'package:oreed_clean/features/forms/presentation/widgets/chip_icon.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({
    super.key,
    this.file,
    this.imageUrl,
    required this.radius,
    required this.aspectRatio,
    required this.borderColor,
    required this.accentColor,
    required this.onChange,
    required this.onRemove,
  });

  final File? file;
  final String? imageUrl;
  final BorderRadius radius;
  final double aspectRatio;
  final Color borderColor;
  final Color accentColor;
  final VoidCallback onChange;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);
    return Material(
      borderRadius: radius,
      elevation: 0,
      child: InkWell(
        onTap: onChange,
        borderRadius: radius,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: aspectRatio,
                  child: (imageUrl != null)
                      ? CachedNetworkImage(
                          imageUrl: imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const ShimmerBox(
                            width: double.infinity,
                            height: double.infinity,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image,
                                size: 50, color: Colors.grey),
                          ),
                        )
                      : Image.file(
                          file!,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: true,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(.30),
                            Colors.transparent,
                          ],
                          stops: const [0, 0.45],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.25),
                          borderRadius: BorderRadius.circular(999),
                          border:
                              Border.all(color: Colors.white.withOpacity(.25)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ChipIcon(
                              icon: Icons.edit_outlined,
                              tooltip: t?.text('action.change') ?? 'Change',
                              onTap: onChange,
                            ),
                            const SizedBox(width: 6),
                            ChipIcon(
                              icon: Icons.delete_outline_rounded,
                              tooltip: t?.text('action.delete') ?? 'Delete',
                              onTap: onRemove,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black.withOpacity(.05)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.image, size: 16, color: accentColor),
                        const SizedBox(width: 6),
                        Text(
                          t?.text('photos.image_added') ?? 'Image added',
                          style: TextStyle(
                            color: Colors.black.withOpacity(.8),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
