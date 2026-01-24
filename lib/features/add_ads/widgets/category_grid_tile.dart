import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/core/utils/shared_widgets/shimmer.dart';

import '../../sub_category/data/models/categorymodel.dart';

class CategoryRowTile extends StatelessWidget {
  const CategoryRowTile({
    super.key,
    required this.item,
    this.onTap,
    this.margin = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  });

  final CategoryModel item;
  final VoidCallback? onTap;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
   
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.primary.withOpacity(0.08),
        child: Container(
          height: 68,
          margin: margin,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8ECF1), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              _Thumb(src: item.image), // 👈 الصورة من غير مربع

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  item.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),

              const Icon(
                Icons.chevron_left, // 👈 نفس اللي في الاسكرين
                size: 28,
                color: Color(0xFF90A3B0),
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({this.src});

  final String? src;

  @override
  Widget build(BuildContext context) {
    final s = src ?? '';
    if (s.isEmpty) {
      return Icon(
        Icons.image_rounded,
        size: 44,
        color: AppColors.primary.withOpacity(0.6),
      );
    }

    return SizedBox(
      width: 44,
      height: 44,
      child: CachedNetworkImage(
        imageUrl: s,
        fit: BoxFit.contain,
        placeholder: (_, __) => const _ThumbLoader(),
        errorWidget: (_, __, ___) => Icon(
          Icons.broken_image_rounded,
          size: 44,
          color: AppColors.primary.withOpacity(0.6),
        ),
      ),
    );
  }
}

class _ThumbLoader extends StatelessWidget {
  const _ThumbLoader();

  @override
  Widget build(BuildContext context) {
    return const ShimmerBox(
      width: double.infinity,
      height: double.infinity,
      borderRadius:BorderRadius.all(Radius.circular(12)),
    );
  }
}

class CategoryGridTile extends StatelessWidget {
  const CategoryGridTile({
    super.key,
    required this.item,
    this.onTap,
    this.isSelected = false,
  });

  final CategoryModel item;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F0FE) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2.5 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: _GridThumb(src: item.image),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 2,
              child: Text(
                item.name ?? '',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFF475569),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridThumb extends StatelessWidget {
  const _GridThumb({this.src});

  final String? src;

  @override
  Widget build(BuildContext context) {
    final s = src ?? '';

    if (s.isEmpty) {
      return Image.asset(Appimage.company);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: s,
        fit: BoxFit.contain,
        placeholder: (_, __) => ShimmerBox(
          width: double.infinity,
          height: double.infinity,
          borderRadius:BorderRadius.all(Radius.circular(10)),
        ),
        errorWidget: (_, __, ___) => Icon(
          Icons.broken_image_rounded,
          size: 36,
          color: AppColors.primary.withOpacity(0.6),
        ),
      ),
    );
  }
}
