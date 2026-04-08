// lib/features/explore/data/repositories/explore_repository.dart

import 'package:dio/dio.dart';
import 'package:your_cairo_trip/core/error/failures.dart';
import '../data_sources/explore_remote_data_source.dart';
import '../models/explore_place_model.dart';

class ExploreRepository {
  final ExploreRemoteDataSource _remoteDataSource;

  ExploreRepository(this._remoteDataSource);

  Future<List<ExplorePlaceModel>> getPlaces(String token) async {
    try {
      return await _remoteDataSource.getPlaces(token);
    } on DioException catch (e) {
      _handleError(e);
    }
    return [];
  }

  Future<List<ExplorePlaceModel>> searchPlaces(
    String query,
    String token,
  ) async {
    try {
      return await _remoteDataSource.searchPlaces(query, token);
    } on DioException catch (e) {
      _handleError(e);
    }
    return [];
  }

  Future<List<ExplorePlaceModel>> filterPlaces({
    required String token,
    bool? isFree,
  }) async {
    try {
      return await _remoteDataSource.filterPlaces(token: token, isFree: isFree);
    } on DioException catch (e) {
      _handleError(e);
    }
    return [];
  }

  Future<bool> toggleFavourite(int placeId, String token) async {
    try {
      return await _remoteDataSource.toggleFavourite(placeId, token);
    } on DioException catch (e) {
      _handleError(e);
    }
    return false;
  }

  void _handleError(DioException e) {
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
