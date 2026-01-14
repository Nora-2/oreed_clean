import 'package:equatable/equatable.dart';
import '../../domain/entities/package_entity.dart';

enum PackagesStatus { initial, loading, success, error }

class PackagesState extends Equatable {
  final PackagesStatus status;
  final List<PackageEntity> packages;
  final String? error;

  const PackagesState({
    this.status = PackagesStatus.initial,
    this.packages = const [],
    this.error,
  });

  PackagesState copyWith({
    PackagesStatus? status,
    List<PackageEntity>? packages,
    String? error,
  }) {
    return PackagesState(
      status: status ?? this.status,
      packages: packages ?? this.packages,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, packages, error];
}