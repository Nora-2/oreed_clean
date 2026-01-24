import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oreed_clean/core/utils/shared_widgets/shimmer.dart';

import '../../data/models/categorymodel.dart';

class SubCategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback? onTap;

  const SubCategoryCard({
    super.key,
    required this.category,
    this.onTap,
  });

  bool _isSvg(String? url) => (url ?? '').toLowerCase().endsWith('.svg');

  bool _isNetwork(String? url) => (url ?? '').toLowerCase().startsWith('http');

  @override
  Widget build(BuildContext context) {
    void defaultTap() {
      // Provider.of<SearchProvider>(context, listen: false)
      //     .setSelectedCategory(category);
      // Navigator.of(context).pushNamed(OtherSalesFilterSearchScreen.routeName);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap ?? defaultTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEAEAEA), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ مساحة مرنة للصورة لتأخذ حجمها المناسب
              Expanded(
                child: Center(child: _buildImage(category.image)),
              ),
              const SizedBox(height: 8),
              // ✅ تحسين تنسيق النص
              Text(
                category.name ?? '',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10, // تكبير الخط قليلاً ليكون أوضح
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  color: Color(0xFF333333), // لون أسود ناعم
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? src) {
    if (src == null || src.trim().isEmpty) {
      return const _FallbackIcon();
    }

    final isSvg = _isSvg(src);
    final isNet = _isNetwork(src);

    // ✅ إزالة العرض الثابت (width: 80) ليسمح للصورة بالتمدد وتكون أوضح
    // واستخدام ارتفاع نسبي أو ثابت مناسب داخل الكارت
    const double imgHeight = 75;

    if (isSvg) {
      return isNet
          ? SvgPicture.network(
              src,
              height: imgHeight,
              fit: BoxFit.contain,
              placeholderBuilder: (_) => const _Loader(),
            )
          : SvgPicture.asset(
              src,
              height: imgHeight,
              fit: BoxFit.contain,
            );
    }

    return isNet
        ? CachedNetworkImage(
            height: imgHeight,
            imageUrl: src,
            fit: BoxFit.contain,
            placeholder: (_, __) => const _Loader(),
            errorWidget: (_, __, ___) => const _FallbackIcon(),
          )
        : Image.asset(
            src,
            height: imgHeight,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const _FallbackIcon(),
          );
  }
}

class _Loader extends StatelessWidget {
  const _Loader();

  @override
  Widget build(BuildContext context) {
    // Shimmer placeholder instead of progress indicator
    return const SizedBox(
      width: 20,
      height: 20,
      child: ShimmerBox(
        height: 20,
        width: 20,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
    );
  }
}

class _FallbackIcon extends StatelessWidget {
  const _FallbackIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.image_not_supported_outlined,
      size: 30,
      color: Colors.grey,
    );
  }
}
