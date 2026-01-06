import 'package:dio/dio.dart';
import 'package:oreed_clean/features/home/data/models/banner_model.dart';
import 'package:oreed_clean/features/home/data/models/category_model.dart';
import 'package:oreed_clean/features/home/data/models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProducts();
  Future<List<BannerModel>> getBanners({String place, int? sectionId});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final uri = '/api/get_sections';

    try {
      final response = await dio.get(uri, queryParameters: {
        'paginate': 'enabled',
        'per_page': 10,
      }, options: Options(headers: {
        'Accept': 'application/json',
      }));

      if (response.statusCode == 200) {
        final data = response.data;
        // data might be { code:200, status:true, data: [...] } or directly list
        List raw = [];
        if (data is Map && data['data'] is List) raw = data['data'];
        else if (data is List) raw = data;
        else if (data is Map && data['data'] is Map && data['data']['data'] is List) raw = data['data']['data'];

        return raw.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
      }

      throw DioException(
        requestOptions: response.requestOptions,
        error: 'Failed to fetch categories: ${response.statusCode}',
        type: DioExceptionType.badResponse,
      );
    } on DioException catch (e) {
      throw e;
    } catch (e) {
      throw DioException(requestOptions: RequestOptions(path: uri), error: e.toString(), type: DioExceptionType.unknown);
    }
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    // Keep existing fake implementation for products for now
    await Future.delayed(Duration(seconds: 1));
    DateTime dateTime = DateTime.now();
    final products = [
      {
        'id': '1',
        'name': 'لاند كروزر 2022',
        'image': 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=400',
        'price': 250000.0,
        'category': 'سيارات',
        'government': 'القاهرة',
        'city': 'مدينة نصر',
        'createdAt': dateTime,
      },
    ];

    return products.map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  Future<List<BannerModel>> getBanners({String place = 'home', int? sectionId}) async {
    final uri = '/api/v1/banners';

    try {
      final query = {
        'place': place,
        if (sectionId != null) 'section_id': sectionId,
        'paginate': 'enabled',
        'per_page': 10,
      };

      final response = await dio.get(uri, queryParameters: query, options: Options(headers: {
        'Accept': 'application/json',
      }));

      if (response.statusCode == 200) {
        final data = response.data;
        List raw = [];
        if (data is Map && data['data'] is List) raw = data['data'];
        else if (data is List) raw = data;
        else if (data is Map && data['data'] is Map && data['data']['data'] is List) raw = data['data']['data'];

        return raw.map((e) => BannerModel.fromJson(e as Map<String, dynamic>)).toList();
      }

      throw DioException(
        requestOptions: response.requestOptions,
        error: 'Failed to fetch banners: ${response.statusCode}',
        type: DioExceptionType.badResponse,
      );
    } on DioException catch (e) {
      throw e;
    } catch (e) {
      throw DioException(requestOptions: RequestOptions(path: uri), error: e.toString(), type: DioExceptionType.unknown);
    }
  }
}