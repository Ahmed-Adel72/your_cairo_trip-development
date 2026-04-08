// lib/features/auth/data/data_sources/auth_remote_data_source.dart

import 'package:dio/dio.dart';
import '../../../../core/constants/app_endpoints.dart';
import '../models/login_response_model.dart';
import '../models/signup_request_model.dart';
import '../models/signup_response_model.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  // ── Login ──
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      AppEndpoints.login,
      data: {'email': email, 'password': password},
    );
    return LoginResponseModel.fromJson(response.data);
  }

  // ── SignUp ──
  Future<SignUpResponseModel> signUp({
    required SignUpRequestModel request,
  }) async {
    final response = await _dio.post(
      AppEndpoints.signUp,
      data: request.toJson(),
    );
    return SignUpResponseModel.fromJson(response.data);
  }
}
