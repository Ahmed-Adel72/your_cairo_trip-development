// lib/features/booking/data/data_sources/booking_remote_data_source.dart

import 'package:dio/dio.dart';
import '../../../../core/constants/app_endpoints.dart';
import '../models/booking_request_model.dart';
import '../models/booking_response_model.dart';

class BookingRemoteDataSource {
  final Dio _dio;

  BookingRemoteDataSource(this._dio);

  Future<BookingResponseModel> createBooking({
    required BookingRequestModel request,
    required String token,
  }) async {
    final response = await _dio.post(
      AppEndpoints.createBooking,
      data: request.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return BookingResponseModel.fromJson(response.data);
  }
}
