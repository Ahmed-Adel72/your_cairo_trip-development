// lib/features/settings/data/repositories/support_repository.dart

import 'package:dio/dio.dart';
import 'package:your_cairo_trip/core/error/failures.dart';
import '../data_sources/support_remote_data_source.dart';

class SupportRepository {
  final SupportRemoteDataSource _dataSource;

  SupportRepository(this._dataSource);

  Future<void> submitSupport({
    required String token,
    required String name,
    required String email,
    required String phone,
    required String problem,
  }) async {
    try {
      await _dataSource.submitSupport(
        token: token,
        name: name,
        email: email,
        phone: phone,
        problem: problem,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'];
        if (message is Map) {
          throw ServerFailure(message['ar'] ?? 'حدث خطأ');
        }
        throw ServerFailure(message?.toString() ?? 'حدث خطأ');
      }
      throw const NetworkFailure('تحقق من اتصالك بالإنترنت');
    }
  }
}
