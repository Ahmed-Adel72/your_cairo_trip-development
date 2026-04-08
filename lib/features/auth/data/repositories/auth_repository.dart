import 'package:dio/dio.dart';
import 'package:your_cairo_trip/core/error/failures.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/login_response_model.dart';
import '../models/signup_request_model.dart';
import '../models/signup_response_model.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  // ── Login ──
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _remoteDataSource.login(email: email, password: password);
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'];
        if (message is Map) {
          throw ServerFailure(message['ar'] ?? 'حدث خطأ');
        }
        throw ServerFailure(message ?? 'حدث خطأ');
      }
      throw const NetworkFailure('تحقق من اتصالك بالإنترنت');
    }
  }

  // ── SignUp ──
  Future<SignUpResponseModel> signUp({
    required SignUpRequestModel request,
  }) async {
    try {
      return await _remoteDataSource.signUp(request: request);
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'];
        if (message is Map) {
          throw ServerFailure(message['ar'] ?? 'حدث خطأ');
        }
        throw ServerFailure(message ?? 'حدث خطأ');
      }
      throw const NetworkFailure('تحقق من اتصالك بالإنترنت');
    }
  }
}
