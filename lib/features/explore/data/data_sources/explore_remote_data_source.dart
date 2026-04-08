// lib/features/explore/data/data_sources/explore_remote_data_source.dart

import 'package:dio/dio.dart';
import '../../../../core/constants/app_endpoints.dart';
import '../models/explore_place_model.dart';

class ExploreRemoteDataSource {
  final Dio _dio;

  ExploreRemoteDataSource(this._dio);

  // ── Headers مع التوكن ──
  Options _authOptions(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  // ── جلب كل الأماكن ──
  Future<List<ExplorePlaceModel>> getPlaces(String token) async {
    final response = await _dio.get(
      AppEndpoints.explore,
      options: _authOptions(token),
    );
    final data = response.data['data'] as List;
    return data
        .map((e) => ExplorePlaceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── السيرش ──
  Future<List<ExplorePlaceModel>> searchPlaces(
    String query,
    String token,
  ) async {
    final response = await _dio.get(
      AppEndpoints.exploreSearch,
      queryParameters: {'q': query},
      options: _authOptions(token),
    );
    final data = response.data['data'] as List;
    return data
        .map((e) => ExplorePlaceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── الفلتر ──
  Future<List<ExplorePlaceModel>> filterPlaces({
    required String token,
    bool? isFree,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (isFree != null) queryParams['is_free'] = isFree;

    final response = await _dio.get(
      AppEndpoints.exploreFilter,
      queryParameters: queryParams,
      options: _authOptions(token),
    );
    final data = response.data['data'] as List;
    return data
        .map((e) => ExplorePlaceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Toggle Favourite ──
  Future<bool> toggleFavourite(int placeId, String token) async {
    final response = await _dio.post(
      AppEndpoints.favouriteToggle(placeId),
      options: _authOptions(token),
    );
    return response.data['data']['is_favourite'] ?? false;
  }
}
