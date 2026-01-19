
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';

class AddPlaceholder extends StatelessWidget {
  const AddPlaceholder({
    super.key,
    required this.height,
    required this.radius,
    required this.borderColor,
    required this.accentColor,
    required this.onTap,
  });

  final double height;
  final BorderRadius radius;
  final Color borderColor;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);
    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(.08),
                    shape: BoxShape.circle,
                    border: Border.all(color: accentColor.withOpacity(.25)),
                  ),
                  child: Icon(Icons.add_rounded, size: 28, color: accentColor),
                ),
                const SizedBox(height: 8),
                Text(
                  t?.text('photos.add_image') ?? 'Add Image',
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  t?.text('press_to_select') ?? 'Press to select',
                  style: TextStyle(
                    color: Colors.black.withOpacity(.45),
                    fontSize: 12,
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
