import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer Loading Skeleton Widget
/// Used for loading states instead of CircularProgressIndicator
class ShimmerSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;
  final ShapeType shapeType;

  const ShimmerSkeleton({
    super.key,
    this.width = double.infinity,
    this.height = 100,
    this.borderRadius,
    this.margin,
    this.shapeType = ShapeType.rectangle,
  });

  const ShimmerSkeleton.circular({
    super.key,
    this.width = 80,
    this.height = 80,
    this.borderRadius,
    this.margin,
    this.shapeType = ShapeType.circle,
  });

  const ShimmerSkeleton.rectangle({
    super.key,
    this.width = double.infinity,
    this.height = 100,
    this.borderRadius,
    this.margin,
    this.shapeType = ShapeType.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: shapeType == ShapeType.circle
                ? null
                : (borderRadius ?? BorderRadius.circular(8)),
            shape: shapeType == ShapeType.circle
                ? BoxShape.circle
                : BoxShape.rectangle,
          ),
        ),
      ),
    );
  }
}

enum ShapeType { rectangle, circle }

/// Form Field Skeleton
class FormFieldSkeleton extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final double height;

  const FormFieldSkeleton({
    super.key,
    this.padding,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerSkeleton(
            width: 80,
            height: 14,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          ShimmerSkeleton(
            width: double.infinity,
            height: height,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}

/// List Item Skeleton (Card-like appearance)
class ListItemSkeleton extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final bool withImage;
  final bool compact;

  const ListItemSkeleton({
    super.key,
    this.padding,
    this.withImage = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment:
            compact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          if (withImage) ...[
            ShimmerSkeleton.circular(
              width: compact ? 60 : 80,
              height: compact ? 60 : 80,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerSkeleton(
                  width: double.infinity,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                ShimmerSkeleton(
                  width: 200,
                  height: 12,
                  borderRadius: BorderRadius.circular(4),
                ),
                if (!compact) ...[
                  const SizedBox(height: 8),
                  ShimmerSkeleton(
                    width: 150,
                    height: 12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Grid Item Skeleton
class GridItemSkeleton extends StatelessWidget {
  final int crossAxisCount;
  final int itemCount;
  final bool hasLabel;
  final double childAspectRatio;

  const GridItemSkeleton({
    super.key,
    this.crossAxisCount = 2,
    this.itemCount = 6,
    this.hasLabel = true,
    this.childAspectRatio = 1,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ShimmerSkeleton(
                width: double.infinity,
                height: double.infinity,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            if (hasLabel) ...[
              const SizedBox(height: 8),
              ShimmerSkeleton(
                width: double.infinity,
                height: 12,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Image Card Skeleton
class ImageCardSkeleton extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry? margin;
  final bool withBottom;

  const ImageCardSkeleton({
    super.key,
    this.height = 200,
    this.margin,
    this.withBottom = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerSkeleton(
            width: double.infinity,
            height: height,
            borderRadius: BorderRadius.circular(12),
          ),
          if (withBottom) ...[
            const SizedBox(height: 12),
            ShimmerSkeleton(
              width: double.infinity,
              height: 14,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            ShimmerSkeleton(
              width: 150,
              height: 12,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ],
      ),
    );
  }
}

/// Banner/Hero Image Skeleton
class BannerSkeleton extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius? borderRadius;

  const BannerSkeleton({
    super.key,
    this.height = 200,
    this.width = double.infinity,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
    );
  }
}

/// Full Form Loading Skeleton
class FormLoadingSkeleton extends StatelessWidget {
  final int fieldCount;
  final EdgeInsetsGeometry? padding;

  const FormLoadingSkeleton({
    super.key,
    this.fieldCount = 5,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: fieldCount,
        itemBuilder: (context, index) {
          return FormFieldSkeleton(
            padding: const EdgeInsets.only(bottom: 20),
            height: index % 3 == 0 ? 60 : 50,
          );
        },
      ),
    );
  }
}

/// List View Loading Skeleton
class ListLoadingSkeleton extends StatelessWidget {
  final int itemCount;
  final bool withImage;
  final bool compact;
  final EdgeInsetsGeometry? padding;

  const ListLoadingSkeleton({
    super.key,
    this.itemCount = 8,
    this.withImage = true,
    this.compact = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return ListItemSkeleton(
          withImage: withImage,
          compact: compact,
          padding: const EdgeInsets.symmetric(vertical: 8),
        );
      },
    );
  }
}

/// Table/Row Skeleton
class TableRowSkeleton extends StatelessWidget {
  final List<double> columnWidths;
  final EdgeInsetsGeometry? padding;

  const TableRowSkeleton({
    super.key,
    required this.columnWidths,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      child: Row(
        children: columnWidths.map((width) {
          return Expanded(
            flex: (width * 100).toInt(),
            child: ShimmerSkeleton(
              width: width,
              height: 14,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Profile Header Skeleton
class ProfileHeaderSkeleton extends StatelessWidget {
  const ProfileHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ShimmerSkeleton.circular(
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 16),
          ShimmerSkeleton(
            width: 150,
            height: 20,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          ShimmerSkeleton(
            width: 200,
            height: 14,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),
          ShimmerSkeleton(
            width: double.infinity,
            height: 40,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}

