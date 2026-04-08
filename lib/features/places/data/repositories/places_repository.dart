// lib/features/places/data/repositories/places_repository.dart

import 'package:dio/dio.dart';
import 'package:your_cairo_trip/core/error/failures.dart';
import 'package:your_cairo_trip/features/places/data/model/budget_request_model.dart';
import 'package:your_cairo_trip/features/places/data/model/budget_response_model.dart';

import '../data_sources/places_remote_data_source.dart';

class PlacesRepository {
  final PlacesRemoteDataSource _remoteDataSource;

  PlacesRepository(this._remoteDataSource);

  Future<BudgetResponseModel> getBudgetPlaces({
    required BudgetRequestModel request,
    required String token,
  }) async {
    try {
      return await _remoteDataSource.getBudgetPlaces(
        request: request,
        token: token,
      );
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
