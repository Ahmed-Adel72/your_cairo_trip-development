import 'package:dio/dio.dart';
import 'package:your_cairo_trip/core/error/failures.dart';
import '../data_sources/booking_remote_data_source.dart';
import '../models/booking_request_model.dart';
import '../models/booking_response_model.dart';

class BookingRepository {
  final BookingRemoteDataSource _remoteDataSource;

  BookingRepository(this._remoteDataSource);

  Future<BookingResponseModel> createBooking({
    required BookingRequestModel request,
    required String token,
  }) async {
    try {
      return await _remoteDataSource.createBooking(
        request: request,
        token: token,
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
