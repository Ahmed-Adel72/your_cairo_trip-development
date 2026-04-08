// lib/features/profile/data/repositories/profile_repository.dart

import 'package:dio/dio.dart';
import 'package:your_cairo_trip/core/error/failures.dart';
import 'package:your_cairo_trip/features/profile/data/data_source/profile_remote_data_source.dart';
import '../models/booking_list_model.dart';
import '../models/favourite_model.dart';
import '../models/profile_model.dart';
import '../models/trip_model.dart';

class ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepository(this._remoteDataSource);

  // ── Helper: Handle Error ──
  Never _handleError(DioException e) {
    if (e.response != null) {
      final message = e.response?.data['message'];
      if (message is Map) {
        throw ServerFailure(message['ar'] ?? 'حدث خطأ');
      }
      throw ServerFailure(message?.toString() ?? 'حدث خطأ');
    }
    throw const NetworkFailure('تحقق من اتصالك بالإنترنت');
  }

  // ── Get Profile ──
  Future<ProfileModel> getProfile({required String token}) async {
    try {
      return await _remoteDataSource.getProfile(token: token);
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // ── Update Profile ──
  Future<ProfileModel> updateProfile({
    required String token,
    required String name,
    required String phone,
    required String preferredLanguage,
  }) async {
    try {
      return await _remoteDataSource.updateProfile(
        token: token,
        name: name,
        phone: phone,
        preferredLanguage: preferredLanguage,
      );
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // ── Logout ──
  Future<void> logout({required String token}) async {
    try {
      await _remoteDataSource.logout(token: token);
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // ── Get Completed Trips ──
  Future<List<TripModel>> getCompletedTrips({required String token}) async {
    try {
      return await _remoteDataSource.getCompletedTrips(token: token);
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // ── Get Upcoming Trips ──
  Future<List<TripModel>> getUpcomingTrips({required String token}) async {
    try {
      return await _remoteDataSource.getUpcomingTrips(token: token);
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // ── Get Favourites ──
  Future<List<FavouriteModel>> getFavourites({required String token}) async {
    try {
      return await _remoteDataSource.getFavourites(token: token);
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // ── Toggle Favourite ──
  Future<bool> toggleFavourite({
    required String token,
    required int placeId,
  }) async {
    try {
      return await _remoteDataSource.toggleFavourite(
        token: token,
        placeId: placeId,
      );
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // ── Get Bookings ──
  Future<List<BookingListModel>> getBookings({required String token}) async {
    try {
      return await _remoteDataSource.getBookings(token: token);
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // ── Cancel Booking ──
  Future<BookingListModel> cancelBooking({
    required String token,
    required int bookingId,
  }) async {
    try {
      return await _remoteDataSource.cancelBooking(
        token: token,
        bookingId: bookingId,
      );
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // ── Submit Support ──
  Future<void> submitSupport({
    required String token,
    required String name,
    required String email,
    required String phone,
    required String problem,
  }) async {
    try {
      await _remoteDataSource.submitSupport(
        token: token,
        name: name,
        email: email,
        phone: phone,
        problem: problem,
      );
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // ── Rate Trip ──
  Future<void> rateTrip({
    required String token,
    required int tripId,
    required double rating,
  }) async {
    try {
      await _remoteDataSource.rateTrip(
        token: token,
        tripId: tripId,
        rating: rating,
      );
    } on DioException catch (e) {
      _handleError(e);
    }
  }
}
