import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/home/domain/entities/category_entity.dart';

class CategoryItem extends StatefulWidget {
  final CategoryEntity category;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool _pressed = false;

  void _onTapDown(TapDownDetails _) => setState(() => _pressed = true);
  void _onTapEnd([_]) => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    final bool isSvg =
        widget.category.icon.toLowerCase().endsWith('.svg');

    return AnimatedScale(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      scale: _pressed ? 0.97 : 1,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grayback.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: widget.onTap,
            onTapDown: _onTapDown,
            onTapUp: _onTapEnd,
            onTapCancel: _onTapEnd,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// 🖼️ Icon
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: isSvg
                          ? SvgPicture.network(
                              widget.category.icon,
                              fit: BoxFit.contain,
                            )
                          : CachedNetworkImage(
                              imageUrl: widget.category.icon,
                              fit: BoxFit.contain,
                              placeholder: (_, __) => const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (_, __, ___) => const Icon(
                                Icons.category,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// 🏷️ Name
                  Expanded(
                    flex: 2,
                    child: Text(
                      widget.category.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
