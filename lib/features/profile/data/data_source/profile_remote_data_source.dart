// lib/features/profile/data/data_sources/profile_remote_data_source.dart

import 'package:dio/dio.dart';
import '../models/booking_list_model.dart';
import '../models/favourite_model.dart';
import '../models/profile_model.dart';
import '../models/trip_model.dart';

class ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSource(this._dio);

  // ── Helper: Auth Header ──
  Options _authHeader(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  // ── Get Profile ──
  Future<ProfileModel> getProfile({required String token}) async {
    final response = await _dio.get(
      '/auth/profile',
      options: _authHeader(token),
    );
    return ProfileModel.fromJson(response.data['data']['user']);
  }

  // ── Update Profile ──
  Future<ProfileModel> updateProfile({
    required String token,
    required String name,
    required String phone,
    required String preferredLanguage,
  }) async {
    final response = await _dio.put(
      '/auth/profile',
      data: {
        'name': name,
        'phone': phone,
        'preferred_language': preferredLanguage,
      },
      options: _authHeader(token),
    );
    return ProfileModel.fromJson(response.data['data']['user']);
  }

  // ── Logout ──
  Future<void> logout({required String token}) async {
    await _dio.post('/auth/logout', options: _authHeader(token));
  }

  // ── Get Completed Trips ──
  Future<List<TripModel>> getCompletedTrips({required String token}) async {
    final response = await _dio.get(
      '/trips/completed',
      options: _authHeader(token),
    );
    final List data = response.data['data'] ?? [];
    return data.map((e) => TripModel.fromJson(e)).toList();
  }

  // ── Get Upcoming Trips ──
  Future<List<TripModel>> getUpcomingTrips({required String token}) async {
    final response = await _dio.get(
      '/trips/upcoming',
      options: _authHeader(token),
    );
    final List data = response.data['data'] ?? [];
    return data.map((e) => TripModel.fromJson(e)).toList();
  }

  // ── Get Favourites ──
  Future<List<FavouriteModel>> getFavourites({required String token}) async {
    final response = await _dio.get('/favourites', options: _authHeader(token));
    final List data = response.data['data'] ?? [];
    return data.map((e) => FavouriteModel.fromJson(e)).toList();
  }

  // ── Toggle Favourite ──
  Future<bool> toggleFavourite({
    required String token,
    required int placeId,
  }) async {
    final response = await _dio.post(
      '/favourites/$placeId/toggle',
      options: _authHeader(token),
    );
    return response.data['data']['is_favourite'] ?? false;
  }

  // ── Get Bookings ──
  Future<List<BookingListModel>> getBookings({required String token}) async {
    final response = await _dio.get('/bookings', options: _authHeader(token));
    final List data = response.data['data'] ?? [];
    return data.map((e) => BookingListModel.fromJson(e)).toList();
  }

  // ── Cancel Booking ──
  Future<BookingListModel> cancelBooking({
    required String token,
    required int bookingId,
  }) async {
    final response = await _dio.put(
      '/bookings/$bookingId/cancel',
      options: _authHeader(token),
    );
    return BookingListModel.fromJson(response.data['data']);
  }

  // ── Submit Support ──
  Future<void> submitSupport({
    required String token,
    required String name,
    required String email,
    required String phone,
    required String problem,
  }) async {
    await _dio.post(
      '/support',
      data: {'name': name, 'email': email, 'phone': phone, 'problem': problem},
      options: _authHeader(token),
    );
  }

  // ── Rate Trip ──
  Future<void> rateTrip({
    required String token,
    required int tripId,
    required double rating,
  }) async {
    await _dio.post(
      '/ratings',
      data: {'trip_id': tripId, 'rating': rating},
      options: _authHeader(token),
    );
  }
}
