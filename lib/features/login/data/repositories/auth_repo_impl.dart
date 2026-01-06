import 'package:oreed_clean/features/login/data/datasources/auth_remote_data_source.dart';
import 'package:oreed_clean/features/login/domain/entities/user_entity.dart';
import 'package:oreed_clean/features/login/domain/repositories/auth_repo.dart';
import 'package:oreed_clean/core/utils/either.dart';
import 'package:oreed_clean/core/error/failures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SharedPreferences prefs;

  static const _tokenKey = 'auth_token';

  AuthRepositoryImpl(this.remoteDataSource, this.prefs);

  @override
  Future<Either<Failure, UserEntity>> login(String phoneNumber, String password) async {
    try {
      // call remote datasource using named parameters to match its signature
      final userModel = await remoteDataSource.login(phone: phoneNumber, password: password);
      final user = userModel.toEntity();
      // persist token if present
      if (user.token.isNotEmpty) {
        await prefs.setString(_tokenKey, user.token);
      }
      return Right(user);
    } on DioException catch (e) {
      // Log rich details to help debugging
      final status = e.response?.statusCode;
      final body = e.response?.data;
      final errorMsg = e.error?.toString() ?? body?.toString() ?? 'Network error';
      // Print to console (Dio LogInterceptor also prints request/response)
      print('Login DioException -> status: $status, body: $body, error: ${e.error}');

      if (status == 401) return Left(AuthFailure(errorMsg));
      if (errorMsg.contains('API baseUrl not configured') || errorMsg.contains('example.com')) {
        return Left(ServerFailure('API baseUrl not configured — set your real API URL in lib/injection_container.dart'));
      }
      if (errorMsg.contains('428') || errorMsg.toLowerCase().contains('verify') || errorMsg.toLowerCase().contains('غير')) {
        return Left(UnverifiedPhoneFailure(errorMsg));
      }
      // prefer server message if available in body
      if (body is Map && body['msg'] != null) return Left(ServerFailure(body['msg'].toString()));
      return Left(ServerFailure(errorMsg));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  String? cachedToken() => prefs.getString(_tokenKey);
}