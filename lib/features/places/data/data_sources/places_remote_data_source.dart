// lib/features/places/data/data_sources/places_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:your_cairo_trip/features/places/data/model/budget_request_model.dart';
import 'package:your_cairo_trip/features/places/data/model/budget_response_model.dart';
import '../../../../core/constants/app_endpoints.dart';

class PlacesRemoteDataSource {
  final Dio _dio;

  PlacesRemoteDataSource(this._dio);

  Future<BudgetResponseModel> getBudgetPlaces({
    required BudgetRequestModel request,
    required String token,
  }) async {
    final response = await _dio.post(
      AppEndpoints.budget,
      data: request.toJson(),
      // ── Bearer Token ──
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return BudgetResponseModel.fromJson(response.data);
  }
}
