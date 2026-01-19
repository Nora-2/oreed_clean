import 'dart:io';
import 'package:flutter/material.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/technican_detailes_entity.dart';

// class MediaItem {
//   final int id;
//   final String url;

//   MediaItem({required this.id, required this.url});
// }

class GalleryGrid extends StatelessWidget {
  final List<MediaItem> galleryRemote;
  final List<File> galleryLocal;
  final Set<int> deletingRemote;
  final Function(MediaItem) onDeleteRemote;
  final Function(int) onDeleteLocal;

  const GalleryGrid({
    super.key,
    required this.galleryRemote,
    required this.galleryLocal,
    required this.deletingRemote,
    required this.onDeleteRemote,
    required this.onDeleteLocal,
  });

  @override
  Widget build(BuildContext context) {
    final totalCount = galleryRemote.length + galleryLocal.length;

    if (totalCount == 0) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        mainAxisExtent: 100,
      ),
      itemBuilder: (context, i) {
        if (i < galleryRemote.length) {
          return RemoteGalleryItem(
            mediaItem: galleryRemote[i],
            isDeleting: deletingRemote.contains(galleryRemote[i].id),
            onDelete: () => onDeleteRemote(galleryRemote[i]),
          );
        } else {
          final localIndex = i - galleryRemote.length;
          return LocalGalleryItem(
            file: galleryLocal[localIndex],
            onDelete: () => onDeleteLocal(localIndex),
          );
        }
      },
    );
  }
}

class RemoteGalleryItem extends StatelessWidget {
  final MediaItem mediaItem;
  final bool isDeleting;
  final VoidCallback onDelete;

  const RemoteGalleryItem({
    super.key,
    required this.mediaItem,
    required this.isDeleting,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            mediaItem.url,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: 6,
          top: 6,
          child: isDeleting
              ? Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: Colors.white,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE11D48),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class LocalGalleryItem extends StatelessWidget {
  final File file;
  final VoidCallback onDelete;

  const LocalGalleryItem({
    super.key,
    required this.file,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            file,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: 6,
          top: 6,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE11D48),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
