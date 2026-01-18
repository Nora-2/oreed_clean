
import 'package:flutter/material.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/ad_card_newlook.dart';

class ImageBack extends StatelessWidget {
  const ImageBack({
    super.key,
    required this.widget,
  });

  final AdCardNewLook widget;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.image_rounded, size: 42, color: Colors.white70),
      ),
    );

    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) return placeholder;

    final isNetwork = widget.imageUrl!.startsWith('http');
    return isNetwork
        ? Image.network(
            widget.imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => placeholder,
          )
        : Image.asset(
            widget.imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => placeholder,
          );
  }
}


