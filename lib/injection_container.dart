import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:oreed_clean/networking/optimized_api_client.dart';
import 'package:oreed_clean/features/home/data/datasources/home_remote_datasource.dart';
import 'package:oreed_clean/features/home/data/repositories/home_repo_impelement.dart';
import 'package:oreed_clean/features/home/domain/repositories/home_repo.dart';
import 'package:oreed_clean/features/home/domain/usecases/get_banner_usecase.dart';
import 'package:oreed_clean/features/home/domain/usecases/get_categories_usecase.dart' show GetCategoriesUseCase;
import 'package:oreed_clean/features/home/domain/usecases/get_product_usecase.dart';
import 'package:oreed_clean/features/home/presentation/cubit/home_cubit.dart';
import 'package:oreed_clean/features/login/data/datasources/auth_remote_data_source.dart';
import 'package:oreed_clean/features/login/data/repositories/auth_repo_impl.dart';
import 'package:oreed_clean/features/login/domain/repositories/auth_repo.dart';
import 'package:oreed_clean/features/login/domain/usecases/login_usecase.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {

  sl.registerLazySingleton<Dio>(() => Dio(
        BaseOptions(
          baseUrl: 'https://oreedo.net/',
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 3),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ));

  // API client wrapper
  sl.registerLazySingleton<OptimizedApiClient>(() => OptimizedApiClient(sl()));

  // SharedPreferences initialization
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // ================== Auth ==================
  // Cubit
  sl.registerFactory(() => AuthCubit(sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );

  // Data source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // ================== Home ==================
  // Cubit
  sl.registerFactory(() => HomeCubit(
        getCategoriesUseCase: sl(),
        getProductsUseCase: sl(),
        getBannersUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetBannersUseCase(sl()));

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl()),
  );

  // Data source
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl()),
  );
}
