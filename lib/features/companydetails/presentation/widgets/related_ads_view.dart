import 'package:flutter/material.dart';
import 'package:oreed_clean/core/enmus/enum.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/features/companydetails/presentation/widgets/grid_ads_view.dart';
import 'package:oreed_clean/features/companydetails/presentation/widgets/list_ads_view.dart';
import 'package:oreed_clean/features/companydetails/presentation/widgets/skelton_error.dart';
import 'package:oreed_clean/features/companydetails/presentation/widgets/top_bar.dart';
import 'package:oreed_clean/features/home/domain/entities/related_ad_entity.dart';
class RelatedAdsView extends StatefulWidget {
  final List<RelatedAdEntity> ads;
  final bool isLoading;
  final String? error;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final int sectionId;
  final int userId;
  final bool embedded;

  const RelatedAdsView({
    super.key,
    required this.ads,
    required this.sectionId,
    required this.userId,
    this.isLoading = false,
    this.error,
    this.onRefresh,
    this.onLoadMore,
    this.embedded = false,
  });

  @override
  State<RelatedAdsView> createState() => _RelatedAdsViewState();
}

class _RelatedAdsViewState extends State<RelatedAdsView> {
  final ScrollController _scrollCtrl = ScrollController();
  bool _isLoadingMore = false;
  ViewMode _mode = ViewMode.grid;

  @override
  void initState() {
    super.initState();
    if (!widget.embedded) {
      _scrollCtrl.addListener(_onScroll);
    }
  }

  void _onScroll() async {
    if (widget.embedded) return; // no inner pagination when embedded
    if (_isLoadingMore || widget.onLoadMore == null) return;
    if (_scrollCtrl.position.pixels >
        _scrollCtrl.position.maxScrollExtent - 300) {
      setState(() => _isLoadingMore = true);
      await widget.onLoadMore?.call();
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  @override
  void dispose() {
    if (!widget.embedded) {
      _scrollCtrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppTranslations.of(context); // ✅ نظام الترجمة المعتمد عندك
    final items = widget.ads;
    final initialLoading = widget.isLoading && items.isEmpty;
    final error = widget.error;

    // Build ads body depending on mode and embedding
    Widget _buildBody({required bool embedded}) {
      if (initialLoading && items.isEmpty) {
        return SkeletonList(mode: _mode, embedded: embedded);
      }

      if (error != null && items.isEmpty) {
        return ErrorState(
          message: error,
          onRetry: widget.onRefresh,
        );
      }

      if (items.isEmpty) return const EmptyState();

      final physics = embedded
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics();
      final shrinkWrap = embedded;
      final controller = embedded ? null : _scrollCtrl;

      final listOrGrid = _mode == ViewMode.grid
          ? GridAdsView(
              items: items,
              controller: controller,
              physics: physics,
              shrinkWrap: shrinkWrap,
              sectionId: widget.sectionId,
              userId: widget.userId,
            )
          : ListAdsView(
              items: items,
              controller: controller,
              physics: physics,
              shrinkWrap: shrinkWrap,
              sectionId: widget.sectionId,
              userId: widget.userId,
            );

      if (embedded) return listOrGrid;

      return RefreshIndicator(
        onRefresh: widget.onRefresh ?? () async {},
        child: listOrGrid,
      );
    }

    final topBar = TopBarads(
      mode: _mode,
      onModeChanged: (m) {
        setState(() {
          _mode = m;
          if (!widget.embedded) {
            _scrollCtrl.jumpTo(0);
          }
        });
      },
    );

    if (widget.embedded) {
      return Column(
        children: [
          topBar,
          _buildBody(embedded: true),
          // no overlay loader in embedded mode
        ],
      );
    }

    return Column(
      children: [
        topBar,
        Expanded(
          child: Stack(
            children: [
              _buildBody(embedded: false),
              if (_isLoadingMore)
                const Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ],
    );
  }
}







