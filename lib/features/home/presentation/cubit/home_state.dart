part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<CategoryEntity> categories;
  final List<ProductEntity> products;
  final List<BannerEntity> banners;

  HomeLoaded({
    required this.categories,
    required this.products,
    required this.banners,
  });

  @override
  List<Object?> get props => [categories, products, banners];
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}