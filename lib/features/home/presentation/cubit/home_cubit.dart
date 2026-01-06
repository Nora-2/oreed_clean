import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oreed_clean/features/home/domain/entities/banner_entity.dart';
import 'package:oreed_clean/features/home/domain/entities/category_entity.dart';
import 'package:oreed_clean/features/home/domain/entities/product_entity.dart';
import 'package:oreed_clean/features/home/domain/usecases/get_banner_usecase.dart';
import 'package:oreed_clean/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:oreed_clean/features/home/domain/usecases/get_product_usecase.dart';
import 'package:oreed_clean/core/utils/either.dart';
import 'package:oreed_clean/core/error/failures.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;
  final GetBannersUseCase getBannersUseCase;

  HomeCubit({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
    required this.getBannersUseCase,
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    try {
      final categoriesRes = await getCategoriesUseCase();
      final productsRes = await getProductsUseCase();
      final bannersRes = await getBannersUseCase();

      // If any failed, emit error with first failure message
      if (categoriesRes is Left) return emit(HomeError((categoriesRes as Left).value.message));
      if (productsRes is Left) return emit(HomeError((productsRes as Left).value.message));
      if (bannersRes is Left) return emit(HomeError((bannersRes as Left).value.message));

      emit(HomeLoaded(
        categories: (categoriesRes as Right).value as List<CategoryEntity>,
        products: (productsRes as Right).value as List<ProductEntity>,
        banners: (bannersRes as Right).value as List<BannerEntity>,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}