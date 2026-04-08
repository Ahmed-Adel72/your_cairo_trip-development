// lib/features/settings/data/data_sources/support_remote_data_source.dart

import 'package:dio/dio.dart';
import '../../../../core/constants/app_endpoints.dart';

class SupportRemoteDataSource {
  final Dio _dio;

  SupportRemoteDataSource(this._dio);

  Options _authHeader(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  Future<void> submitSupport({
    required String token,
    required String name,
    required String email,
    required String phone,
    required String problem,
  }) async {
    await _dio.post(
      AppEndpoints.support,
      data: {'name': name, 'email': email, 'phone': phone, 'problem': problem},
      options: _authHeader(token),
    );
  }
}
