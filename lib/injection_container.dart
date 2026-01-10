import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/features/favourite/data/datasources/favourite_remote_data_source.dart';
import 'package:oreed_clean/features/favourite/data/repositories/favourite_repo.dart';
import 'package:oreed_clean/features/favourite/domain/repositories/favourite_repo_impl.dart';
import 'package:oreed_clean/features/favourite/domain/usecases/get_favourite.dart';
import 'package:oreed_clean/features/favourite/domain/usecases/toggel_favourite.dart';
import 'package:oreed_clean/features/favourite/presentation/cubit/favourite_cubit.dart';
import 'package:oreed_clean/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:oreed_clean/features/notification/data/repositories/notification_repo.dart';
import 'package:oreed_clean/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:oreed_clean/features/personal_register/data/datasources/personal_register_remote_data_source.dart';
import 'package:oreed_clean/features/personal_register/data/repositories/personal_register_repo_impl.dart';
import 'package:oreed_clean/features/personal_register/domain/repositories/personal_register_repo.dart';
import 'package:oreed_clean/features/personal_register/domain/usecases/personal_register_usecase.dart';
import 'package:oreed_clean/features/personal_register/presentation/cubit/personal_register_cubit.dart';
import 'package:oreed_clean/networking/api_provider.dart';
import 'package:oreed_clean/networking/http_client.dart';
import 'package:oreed_clean/networking/optimized_api_client.dart';
import 'package:oreed_clean/features/home/data/datasources/home_remote_datasource.dart';
import 'package:oreed_clean/features/home/data/repositories/home_repo_impelement.dart';
import 'package:oreed_clean/features/home/domain/repositories/home_repo.dart';
import 'package:oreed_clean/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:oreed_clean/features/home/domain/usecases/get_related_ad_usecase.dart';
import 'package:oreed_clean/features/home/presentation/cubit/home_cubit.dart';
import 'package:oreed_clean/features/banners/data/datasources/banner_remote_data_source.dart';
import 'package:oreed_clean/features/banners/data/repositories/banner_repo_impl.dart';
import 'package:oreed_clean/features/banners/domain/repositories/banner_repo.dart';
import 'package:oreed_clean/features/banners/domain/usecases/get_banner_usecase.dart';
import 'package:oreed_clean/features/banners/presentation/cubit/banners_cubit.dart';
import 'package:oreed_clean/features/login/data/datasources/auth_remote_data_source.dart';
import 'package:oreed_clean/features/login/data/repositories/auth_repo_impl.dart';
import 'package:oreed_clean/features/login/domain/repositories/auth_repo.dart';
import 'package:oreed_clean/features/login/domain/usecases/login_usecase.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
sl.registerLazySingleton<AppSharedPreferences>(
  () => AppSharedPreferences(),
);

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
  sl.registerLazySingleton<OptimizedApiClient>(() => OptimizedApiClient());

  // SharedPreferences initialization
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
// ================== Notifications ==================

  sl.registerLazySingleton<PersonalRegisterRemoteDataSource>(
    () => PersonalRegisterRemoteDataSource(sl<ApiProvider>()),
  );
  sl.registerLazySingleton<PersonalRegisterRepository>(
    () =>
        PersonalRegisterRepositoryImpl(sl<PersonalRegisterRemoteDataSource>()),
  );
  sl.registerLazySingleton<PersonalRegisterUseCase>(
    () => PersonalRegisterUseCase(sl<PersonalRegisterRepository>()),
  );
sl.registerFactory<PersonalRegisterCubit>(
  () => PersonalRegisterCubit(sl<PersonalRegisterUseCase>()),
);

sl.registerFactory(
  () => NotificationsCubit(
    repository: sl(),
    prefs: sl(),
  ),
);

// Repository
sl.registerLazySingleton<NotificationsRepository>(
  () => NotificationsRepository(
    remoteDataSource: sl(),
  ),
);

// Remote Data Source
sl.registerLazySingleton<NotificationsRemoteDataSource>(
  () => NotificationsRemoteDataSourceImpl(),
);
   sl.registerLazySingleton<http.Client>(
    () => http.Client(),
  );

  /// HttpClientService ✅
  sl.registerLazySingleton<HttpClientService>(
    () => HttpClientService(
      client: sl<http.Client>(),
      baseUrl: 'https://oreedo.net/', // ⚠️ نفس baseUrl بتاعتك
      defaultHeaders: const {
        'Content-Type': 'application/json',
      },
    ),
  );
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

  // ================== Banners ==================
  // Cubit
  sl.registerFactory(() => BannerCubit(sl()));

  // Use case
  sl.registerLazySingleton(() => GetBannersUseCase(sl()));

  // Repository
  sl.registerLazySingleton<BannerRepository>(
    () => BannerRepositoryImpl(sl()),
  );

  // Data source
  sl.registerLazySingleton<BannerRemoteDataSource>(
    () => BannerRemoteDataSource(),
  );

  // ================== Home ==================
  // Cubit
  sl.registerFactory(() => MainHomeCubit(
        sl(),
        sl(),
        sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetSectionsUseCase(sl()));
  sl.registerLazySingleton(() => GetRelatedAdsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<MainHomeRepository>(
    () => MainHomeRepositoryImpl(sl()),
  );

  // Data source
  sl.registerLazySingleton<MainHomeRemoteDataSource>(
    () => MainHomeRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<ApiProvider>(
  () => ApiProvider(),
);
// ================== Favorites ==================


 sl.registerLazySingleton<FavoritesRemoteDataSource>(
  () => FavoritesRemoteDataSourceImpl(sl<HttpClientService>()),
);

  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(sl(),),
  );

  sl.registerLazySingleton<ToggleFavorite>(
    () => ToggleFavorite(sl()),
  );

  sl.registerLazySingleton<GetFavorites>(
    () => GetFavorites(sl()),
  );

  sl.registerFactory<FavoritesCubit>(
    () => FavoritesCubit(
      sl<ToggleFavorite>(),
      sl<GetFavorites>(),
      sl<AppSharedPreferences>(),
    ),
  );



}
