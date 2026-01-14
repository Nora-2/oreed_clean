import 'package:flutter/material.dart';

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;
  final String? heroTag;

  const FullScreenImageView({super.key, required this.imageUrl, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final img = Image.network(
      imageUrl,
      fit: BoxFit.contain,
      loadingBuilder: (c, child, progress) {
        if (progress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            value: progress.expectedTotalBytes != null
                ? progress.cumulativeBytesLoaded /
                      (progress.expectedTotalBytes!)
                : null,
          ),
        );
      },
      errorBuilder: (c, e, s) =>
          const Icon(Icons.broken_image, color: Colors.white54, size: 40),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Center(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: heroTag != null ? Hero(tag: heroTag!, child: img) : img,
          ),
        ),
      ),
    );
  }
}
