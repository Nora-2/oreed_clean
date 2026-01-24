import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/shimmer.dart' as local_shimmer;

class CompanyCardsubcategory extends StatelessWidget {
  const CompanyCardsubcategory({
    super.key,
    required this.title,
    required this.len,
    this.imageUrl,
    this.assetImage,
    this.onTap,
  });

  final String title;
  final int len;
  final String? imageUrl;
  final String? assetImage;
  final VoidCallback? onTap;

  // القيمة المستخدمة لتدوير الحواف لتطابق الصورة
  static const double _borderRadius = 10.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(_borderRadius),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔹 حاوية الصورة الخلفية (الخلفية الرمادية الفاتحة)
          Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFA3BCFD).withOpacity(.08),
              borderRadius: BorderRadius.circular(_borderRadius),
              border: Border.all(color: AppColors.grey.withOpacity(.25)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_borderRadius),
              child: _CompanyImage(
                imageUrl: imageUrl,
                assetImage: assetImage,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 النص (العنوان)
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1, // غالباً سطر واحد في هذا التصميم
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600, // خط عريض قليلاً ليناسب العناوين
              color: Color(0xFF4A4A4A), // لون رمادي غامق مريح للعين
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanyImage extends StatelessWidget {
  const _CompanyImage({this.imageUrl, this.assetImage});

  final String? imageUrl;
  final String? assetImage;

  @override
  Widget build(BuildContext context) {
    Widget placeholder = const Center(
      child: Icon(Icons.business, size: 34, color: Colors.black12),
    );

    Widget buildImage(ImageProvider provider) {
      return DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: provider,
            fit: BoxFit.fill,              // ✅ يملا
            alignment: Alignment.center,    // ✅ وسط
          ),
        ),
      );
    }

    if (assetImage != null && assetImage!.isNotEmpty) {
      return buildImage(AssetImage(assetImage!));
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        imageBuilder: (context, imageProvider) => buildImage(imageProvider),
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => placeholder,
      );
    }

    return placeholder;
  }
}

/// Shimmer loading widget for CompanyCard
class CompanyCardShimmer extends StatelessWidget {
  const CompanyCardShimmer({super.key});

  static const double _radius = 16.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Card body
        Container(
          padding: const EdgeInsets.all(0),
          width: MediaQuery.of(context).size.width,
          height: 90,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(_radius),
                  topRight: Radius.circular(_radius)),
              side: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.5), width: 1.6),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x11000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_radius - 6),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: local_shimmer.ShimmerBox(
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),

        // Pill shimmer
        Positioned(
          left: 0,
          top: 80,
          right: 0,
          child: Center(
            child: Container(
              width: 210,
              decoration: const BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16))),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                child: local_shimmer.ShimmerBox(
                  height: 10,
                  width: 150,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
