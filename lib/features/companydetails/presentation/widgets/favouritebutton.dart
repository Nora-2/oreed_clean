import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';

class FavoriteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isFavorite;
  final bool isPending;
  final bool isDisabled;

  const FavoriteButton({
    super.key,
    this.onPressed,
    required this.isFavorite,
    required this.isPending,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = isDisabled ? 0.4 : 1.0;
    return Opacity(
      opacity: opacity,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffE8E8E9),
          ),
          child: isPending
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : SvgPicture.asset(
                  isFavorite ? AppIcons.heartFull : AppIcons.heartSpace,
                  color: const Color(0xFF1649D3),
                  width: 16,
                  height: 16,
                ),
        ),
      ),
    );
  }
}
