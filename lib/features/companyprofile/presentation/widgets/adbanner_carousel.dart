import 'package:flutter/material.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/ad_card_newlook.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/priorty_button.dart';

class AdBannerCarousel extends StatefulWidget {
  final int itemCount;
  final String Function(int index) titleBuilder;
  final String Function(int index) sectionTypeBuilder;
  final String Function(int index) adIdBuilder;
  final String Function(int index) typeBuilder;
  final String Function(int index) adTypeBuilder;
  final String Function(int index) dateBuilder;
  final int Function(int index) viewsBuilder;
  final int companyId;
  final String ownerType;
  final int Function(int index) sectionId;
  final String? Function(int index)? imageUrlBuilder;
  final String Function(int index)? statusBuilder;
  final bool Function(int index)? showPin;
  final void Function(int index)? onEdit;
  final void Function(int index)? onDelete;
  final void Function(int index)? onRepublish;
  final BoxDecoration? cardDecoration;

  /// ✅ للتحكم في ظهور "تمييز إعلانك"
  final bool showHighlight;

  /// ✅ للتحكم في ظهور "ثبّت إعلانك"

  const AdBannerCarousel({
    super.key,
    required this.ownerType,
    required this.itemCount,
    required this.titleBuilder,
    required this.sectionTypeBuilder,
    required this.adIdBuilder,
    required this.adTypeBuilder,
    required this.companyId,
    required this.typeBuilder,
    required this.dateBuilder,
    required this.viewsBuilder,
    required this.sectionId,
    this.imageUrlBuilder,
    this.statusBuilder,
    this.onEdit,
    this.onDelete,
    this.onRepublish,
    this.cardDecoration,
    this.showHighlight = true,
    this.showPin,
  });

  @override
  State<AdBannerCarousel> createState() => _AdBannerCarouselState();
}

class _AdBannerCarouselState extends State<AdBannerCarousel> {
  @override
  Widget build(BuildContext context) {
    if (widget.itemCount == 0) {
      return const Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: EmptyCard(),
          ),
        ],
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: AdCardNewLook(
            ownerType: widget.ownerType,
            key: ValueKey('ad_card_$index'),
            title: widget.titleBuilder(index),
            date: widget.dateBuilder(index),
            sectionType: widget.sectionTypeBuilder(index),
            companyId: widget.companyId,
            views: widget.viewsBuilder(index),
            sectionId: widget.sectionId(index),
            status: widget.statusBuilder?.call(index),
            imageUrl: widget.imageUrlBuilder?.call(index),
            onEdit: widget.onEdit != null ? () => widget.onEdit!(index) : null,
            onDelete:
                widget.onDelete != null ? () => widget.onDelete!(index) : null,
            onRepublish: widget.onRepublish != null
                ? () => widget.onRepublish!(index)
                : null,

            // ✅ مرّر الفلاجين للكارت
            showHighlight: widget.showHighlight,
            showPin: widget.showPin?.call(index) ?? true,
            type: widget.typeBuilder(index),
            adType: widget.adTypeBuilder(index),
            adId: widget.adIdBuilder(index),
          ),
        );
      },
    );
  }
}
