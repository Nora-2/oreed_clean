

import 'package:equatable/equatable.dart';
import 'package:oreed_clean/features/banners/domain/entities/banner_entity.dart';
import 'package:oreed_clean/features/banners/presentation/cubit/banners_cubit.dart';

class BannerState extends Equatable {
  final BannerStatus status;
  final List<BannerEntity> banners; // Current active banners
  final Map<int?, List<BannerEntity>> sectionBanners; // Cache of all sections
  final String? errorMessage;

  const BannerState({
    this.status = BannerStatus.idle,
    this.banners = const [],
    this.sectionBanners = const {},
    this.errorMessage,
  });

  BannerState copyWith({
    BannerStatus? status,
    List<BannerEntity>? banners,
    Map<int?, List<BannerEntity>>? sectionBanners,
    String? errorMessage,
  }) {
    return BannerState(
      status: status ?? this.status,
      banners: banners ?? this.banners,
      sectionBanners: sectionBanners ?? this.sectionBanners,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, banners, sectionBanners, errorMessage];
}