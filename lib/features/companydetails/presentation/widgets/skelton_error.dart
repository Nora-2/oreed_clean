
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/enmus/enum.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/shared_widgets/shimmer.dart';

/// Skeletons while loading
class SkeletonList extends StatelessWidget {
  final ViewMode mode;
  final bool embedded;

  const SkeletonList({required this.mode, required this.embedded});

  @override
  Widget build(BuildContext context) {
    final physics = embedded
        ? const NeverScrollableScrollPhysics()
        : const BouncingScrollPhysics();

    if (mode == ViewMode.grid) {
      return GridView.builder(
        physics: physics,
        shrinkWrap: embedded,
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent: 240,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(height: 120, width: double.infinity),
            SizedBox(height: 8),
            ShimmerBox(height: 14, width: 140),
            SizedBox(height: 6),
            ShimmerBox(height: 12, width: 100),
          ],
        ),
      );
    }

    return ListView.separated(
      physics: physics,
      shrinkWrap: embedded,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
      itemBuilder: (_, __) => const ShimmerBox(height: 110),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: 6,
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);
    return Center(
      child: Text(
        t?.text('common.noResults') ?? 'No results matching your search',
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function()? onRetry;

  const ErrorState({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 8),
          if (onRetry != null)
            ElevatedButton(
              onPressed: onRetry,
              child: Text(t?.text('common.retry') ?? 'Retry'),
            ),
        ],
      ),
    );
  }
}
