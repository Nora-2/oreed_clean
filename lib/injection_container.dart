import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/features/ads/domain/repositories/ads_repo.dart';
import 'package:oreed_clean/features/ads/domain/usecases/delete_ad_use_case.dart';
import 'package:oreed_clean/features/chooseplane/data/datasources/packege_remote_datasource.dart';
import 'package:oreed_clean/features/chooseplane/data/repositories/package_repo_impl.dart';
import 'package:oreed_clean/features/chooseplane/domain/usecases/get_package_by_type_usecase.dart';
import 'package:oreed_clean/features/comapany_register/data/datasources/company_register_remote_data_source.dart';
import 'package:oreed_clean/features/comapany_register/data/datasources/company_remote_data_source.dart';
import 'package:oreed_clean/features/comapany_register/data/repositories/comapny_register_repo_impl.dart';
import 'package:oreed_clean/features/comapany_register/data/repositories/comapny_repo_impl.dart';
import 'package:oreed_clean/features/comapany_register/domain/usecases/create_company_usecase.dart';
import 'package:oreed_clean/features/comapany_register/domain/usecases/get_categories_usecase.dart';
import 'package:oreed_clean/features/comapany_register/domain/usecases/get_country_usecase.dart';
import 'package:oreed_clean/features/comapany_register/domain/usecases/get_state_usecase.dart';
import 'package:oreed_clean/features/comapany_register/domain/usecases/rwgister_company_usecase.dart';
import 'package:oreed_clean/features/comapany_register/presentation/cubit/comapany_register_cubit.dart';
import 'package:oreed_clean/features/companyprofile/data/datasources/company_profile_remote_data_source.dart';
import 'package:oreed_clean/features/companyprofile/data/repositories/company_profile_repo_impl.dart';
import 'package:oreed_clean/features/companyprofile/domain/repositories/company_profile_repo.dart';
import 'package:oreed_clean/features/companyprofile/domain/usecases/get_company_profile_ad_usecase.dart';
import 'package:oreed_clean/features/companyprofile/domain/usecases/get_company_profile_usecase.dart';
import 'package:oreed_clean/features/companyprofile/presentation/cubit/companyprofile_cubit.dart';
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
import 'package:oreed_clean/features/login/data/repositories/auth_repo_impl.dart';
import 'package:oreed_clean/features/login/domain/repositories/auth_repo.dart';
import 'package:oreed_clean/features/login/domain/usecases/login_usecase.dart';
import 'package:oreed_clean/features/login/presentation/cubit/login_cubit.dart';
import 'package:oreed_clean/features/chooseplane/presentation/cubit/chooseplane_cubit.dart';
import 'package:oreed_clean/features/verification/data/datasources/company_otp_verification_data_source.dart';
import 'package:oreed_clean/features/verification/data/company_otp_verification_repo_impl.dart';
import 'package:oreed_clean/features/verification/domain/repositories/compant_otp_repo.dart';
import 'package:oreed_clean/features/verification/domain/usecases/verifiy_otp_usecase.dart';
import 'package:oreed_clean/features/verification/presentation/cubit/verificationscreen_cubit.dart';
import 'package:oreed_clean/features/AdvancedSearch/data/repositories/advanced_search_repo.dart';
import 'package:oreed_clean/features/AdvancedSearch/presentation/cubit/advancedsearch_cubit.dart';
import 'package:oreed_clean/features/account_type/presentation/cubit/account_type_cubit.dart';
import 'package:oreed_clean/features/password/presentation/cubit/password_cubit.dart';
import 'package:oreed_clean/features/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:oreed_clean/features/comapany_register/presentation/cubit/form_ui_cubit.dart';
import 'package:oreed_clean/features/mainlayout/presentation/cubit/mainlayout_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oreed_clean/features/companydetails/presentation/cubit/companydetailes_cubit.dart';
import 'package:oreed_clean/features/companydetails/domain/usecases/get_company_usecase.dart';
import 'package:oreed_clean/features/companydetails/domain/usecases/get_company_ad_usecase.dart';
import 'package:oreed_clean/features/companydetails/domain/repositories/company_details_repo.dart';
import 'package:oreed_clean/features/companydetails/data/repositories/company_details_repo.dart';
import 'package:oreed_clean/features/companydetails/data/datasources/company_details_remote_data_source.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<AppSharedPreferences>(() => AppSharedPreferences());

  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: 'https://oreedo.net/',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    ),
  );
  sl.registerLazySingleton<CompanyProfileRemoteDataSource>(
    () => CompanyProfileRemoteDataSource(),
  );
  sl.registerLazySingleton<CompanyProfileRepository>(
    () => CompanyProfileRepositoryImpl(sl<CompanyProfileRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetCompanyProfileUseCase>(
    () => GetCompanyProfileUseCase(sl<CompanyProfileRepository>()),
  );

  sl.registerLazySingleton<GetCompanyProfileAdsUseCase>(
    () => GetCompanyProfileAdsUseCase(sl<CompanyProfileRepository>()),
  );

  sl.registerLazySingleton<DeleteAdUseCase>(
    () => DeleteAdUseCase(sl<AdsRepository>()),
  );

  sl.registerFactory<CompanyprofileCubit>(
    () => CompanyprofileCubit(
      sl<GetCompanyProfileUseCase>(),
      sl<GetCompanyProfileAdsUseCase>(),
      sl<DeleteAdUseCase>(),
    ),
  );

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
  sl.registerLazySingleton<CompanyRegisterRemoteDataSource>(
    () => CompanyRegisterRemoteDataSource(sl<ApiProvider>()),
  );
  sl.registerLazySingleton<CompanyRemoteDataSource>(
    () => CompanyRemoteDataSource(),
  );
  sl.registerLazySingleton<CompanyRegisterRepositoryImpl>(
    () => CompanyRegisterRepositoryImpl(sl<CompanyRegisterRemoteDataSource>()),
  );

  sl.registerLazySingleton<CompanyRepositoryImpl>(
    () => CompanyRepositoryImpl(sl<CompanyRemoteDataSource>()),
  );
  sl.registerLazySingleton<CreateCompanyUseCase>(
    () => CreateCompanyUseCase(sl<CompanyRepositoryImpl>()),
  );

  sl.registerFactory<CompanyFormCubit>(
    () => CompanyFormCubit(sl<CreateCompanyUseCase>()),
  );

  sl.registerLazySingleton<GetCountriesUseCase>(
    () => GetCountriesUseCase(sl<CompanyRegisterRepositoryImpl>()),
  );
  sl.registerLazySingleton<GetStatesUseCase>(
    () => GetStatesUseCase(sl<CompanyRegisterRepositoryImpl>()),
  );
  sl.registerFactory<CompanyRegisterCubit>(
    () => CompanyRegisterCubit(
      sl<GetCountriesUseCase>(),
      sl<GetStatesUseCase>(),
      sl<GetCategoriesUseCase>(),
      sl<RegisterCompanyUseCase>(),
      sl<GetSectionsUseCase>(), // This comes from the Home module
    ),
  );
  sl.registerLazySingleton<PackageRemoteDataSource>(
    () => PackageRemoteDataSource(sl<ApiProvider>()),
  );
  sl.registerLazySingleton<PackageRepositoryImpl>(
    () => PackageRepositoryImpl(sl<PackageRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetPackagesByTypeUseCase>(
    () => GetPackagesByTypeUseCase(sl<PackageRepositoryImpl>()),
  );
  // sl.registerLazySingleton<CreateCompanyUseCase>(
  //     () => CreateCompanyUseCase(sl()));
  sl.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(sl<CompanyRegisterRepositoryImpl>()),
  );
  sl.registerLazySingleton<RegisterCompanyUseCase>(
    () => RegisterCompanyUseCase(sl<CompanyRegisterRepositoryImpl>()),
  );

  sl.registerFactory<PackagesCubit>(
    () => PackagesCubit(sl<GetPackagesByTypeUseCase>()),
  );

  // ================== Verification ==================
  sl.registerLazySingleton<CompanyOtpRemoteDataSource>(
    () => CompanyOtpRemoteDataSource(sl<ApiProvider>()),
  );
  sl.registerLazySingleton<CompanyOtpRepository>(
    () => CompanyOtpRepositoryImpl(sl<CompanyOtpRemoteDataSource>()),
  );
  sl.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(sl<CompanyOtpRepository>()),
  );
  sl.registerFactory<VerificationCubit>(
    () => VerificationCubit(sl<VerifyOtpUseCase>()),
  );

  // ================== Advanced Search ==================
  sl.registerLazySingleton<AdvancedSearchRepository>(
    () => AdvancedSearchRepository(),
  );
  sl.registerFactory<AdvancedSearchCubit>(
    () => AdvancedSearchCubit(repository: sl<AdvancedSearchRepository>()),
  );

  // ================== Password ==================
  sl.registerFactory<PasswordCubit>(() => PasswordCubit(sl<AuthRepository>()));

  // ================== Account Type ==================
  sl.registerFactory<AccountTypeCubit>(() => AccountTypeCubit());

  // ================== OnBoarding ==================
  sl.registerFactory<OnBoardingCubit>(() => OnBoardingCubit());

  // ================== Main Layout ==================
  sl.registerFactory<HomelayoutCubit>(() => HomelayoutCubit());

  sl.registerFactory(() => NotificationsCubit(repository: sl(), prefs: sl()));

  // Repository
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepository(remoteDataSource: sl()),
  );

  // Remote Data Source
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<http.Client>(() => http.Client());

  /// HttpClientService ✅
  sl.registerLazySingleton<HttpClientService>(
    () => HttpClientService(
      client: sl<http.Client>(),
      baseUrl: 'https://oreedo.net/', // ⚠️ نفس baseUrl بتاعتك
      defaultHeaders: const {'Content-Type': 'application/json'},
    ),
  );
  // ================== Auth ==================
  // Cubit
  sl.registerFactory(() => AuthCubit(sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Data source

  // ================== Banners ==================
  // Cubit
  sl.registerFactory(() => BannerCubit(sl()));

  // Use case
  sl.registerLazySingleton(() => GetBannersUseCase(sl()));

  // Repository
  sl.registerLazySingleton<BannerRepository>(() => BannerRepositoryImpl(sl()));

  // Data source
  sl.registerLazySingleton<BannerRemoteDataSource>(
    () => BannerRemoteDataSource(),
  );

  // ================== Home ==================
  // Cubit
  sl.registerFactory(() => MainHomeCubit(sl(), sl(), sl()));

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
  sl.registerLazySingleton<ApiProvider>(() => ApiProvider());
  // ================== Favorites ==================

  sl.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSourceImpl(sl<HttpClientService>()),
  );

  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<ToggleFavorite>(() => ToggleFavorite(sl()));

  sl.registerLazySingleton<GetFavorites>(() => GetFavorites(sl()));

  sl.registerFactory<FavoritesCubit>(
    () => FavoritesCubit(
      sl<ToggleFavorite>(),
      sl<GetFavorites>(),
      sl<AppSharedPreferences>(),
    ),
  );

  // ================== Company Details ==================
  sl.registerLazySingleton<CompanyDetailsRemoteDataSource>(
    () => CompanyDetailsRemoteDataSource(sl<ApiProvider>()),
  );
  sl.registerLazySingleton<CompanyDetailsRepository>(
    () => CompanyDetailsRepositoryImpl(sl<CompanyDetailsRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetCompanyDetailsUseCase>(
    () => GetCompanyDetailsUseCase(sl<CompanyDetailsRepository>()),
  );
  sl.registerLazySingleton<GetCompanyAdsUseCase>(
    () => GetCompanyAdsUseCase(sl<CompanyDetailsRepository>()),
  );
  sl.registerFactory<CompanyDetailsCubit>(
    () => CompanyDetailsCubit(
      getCompanyDetailsUseCase: sl<GetCompanyDetailsUseCase>(),
      getCompanyAdsUseCase: sl<GetCompanyAdsUseCase>(),
    ),
  );
}
