// lib/features/profile/presentation/cubit/profile_cubit.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_cairo_trip/core/error/failures.dart';
import 'package:your_cairo_trip/features/profile/data/repository/profile_repository.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../../core/storage/token_manager.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit(this._repository) : super(ProfileInitial());

  // ── Helper: Get Token ──
  Future<String?> _getToken() => TokenManager.getToken();

  // ── Get Profile ──
  Future<void> getProfile() async {
    emit(ProfileLoading());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(ProfileError('يجب تسجيل الدخول أولاً'));
        return;
      }
      final profile = await _repository.getProfile(token: token);
      emit(ProfileLoaded(profile));
    } on ServerFailure catch (e) {
      emit(ProfileError(e.message));
    } on NetworkFailure catch (_) {
      emit(ProfileError(AppTranslationKeys.noInternet.tr()));
    } catch (_) {
      emit(ProfileError(AppTranslationKeys.error.tr()));
    }
  }

  // ── Update Profile ──
  Future<void> updateProfile({
    required String name,
    required String phone,
    required String preferredLanguage,
  }) async {
    emit(ProfileUpdateLoading());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(ProfileUpdateError('يجب تسجيل الدخول أولاً'));
        return;
      }
      final profile = await _repository.updateProfile(
        token: token,
        name: name,
        phone: phone,
        preferredLanguage: preferredLanguage,
      );
      emit(ProfileUpdateSuccess(profile));
    } on ServerFailure catch (e) {
      emit(ProfileUpdateError(e.message));
    } on NetworkFailure catch (_) {
      emit(ProfileUpdateError(AppTranslationKeys.noInternet.tr()));
    } catch (_) {
      emit(ProfileUpdateError(AppTranslationKeys.error.tr()));
    }
  }

  // ── Logout ──
  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(LogoutSuccess());
        return;
      }
      await _repository.logout(token: token);
      await TokenManager.clearToken();
      emit(LogoutSuccess());
    } on ServerFailure catch (e) {
      emit(LogoutError(e.message));
    } on NetworkFailure catch (_) {
      emit(LogoutError(AppTranslationKeys.noInternet.tr()));
    } catch (_) {
      emit(LogoutError(AppTranslationKeys.error.tr()));
    }
  }

  // ── Get Trips ──
  Future<void> getTrips() async {
    emit(TripsLoading());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(TripsError('يجب تسجيل الدخول أولاً'));
        return;
      }
      final completed = await _repository.getCompletedTrips(token: token);
      final upcoming = await _repository.getUpcomingTrips(token: token);
      emit(TripsLoaded(completedTrips: completed, upcomingTrips: upcoming));
    } on ServerFailure catch (e) {
      emit(TripsError(e.message));
    } on NetworkFailure catch (_) {
      emit(TripsError(AppTranslationKeys.noInternet.tr()));
    } catch (_) {
      emit(TripsError(AppTranslationKeys.error.tr()));
    }
  }

  // ── Rate Trip ──
  Future<void> rateTrip({required int tripId, required double rating}) async {
    emit(RatingLoading());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(RatingError('يجب تسجيل الدخول أولاً'));
        return;
      }
      await _repository.rateTrip(token: token, tripId: tripId, rating: rating);
      emit(RatingSuccess());
      // ── Refresh Trips ──
      await getTrips();
    } on ServerFailure catch (e) {
      emit(RatingError(e.message));
    } on NetworkFailure catch (_) {
      emit(RatingError(AppTranslationKeys.noInternet.tr()));
    } catch (_) {
      emit(RatingError(AppTranslationKeys.error.tr()));
    }
  }

  // ── Get Favourites ──
  Future<void> getFavourites() async {
    emit(FavouritesLoading());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(FavouritesError('يجب تسجيل الدخول أولاً'));
        return;
      }
      final favourites = await _repository.getFavourites(token: token);
      emit(FavouritesLoaded(favourites));
    } on ServerFailure catch (e) {
      emit(FavouritesError(e.message));
    } on NetworkFailure catch (_) {
      emit(FavouritesError(AppTranslationKeys.noInternet.tr()));
    } catch (_) {
      emit(FavouritesError(AppTranslationKeys.error.tr()));
    }
  }

  // ── Toggle Favourite ──
  Future<void> toggleFavourite(int placeId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        emit(FavouriteToggleError('يجب تسجيل الدخول أولاً'));
        return;
      }
      final isFavourite = await _repository.toggleFavourite(
        token: token,
        placeId: placeId,
      );
      emit(FavouriteToggleSuccess(isFavourite));
      // ── Refresh Favourites ──
      await getFavourites();
    } on ServerFailure catch (e) {
      emit(FavouriteToggleError(e.message));
    } on NetworkFailure catch (_) {
      emit(FavouriteToggleError(AppTranslationKeys.noInternet.tr()));
    } catch (_) {
      emit(FavouriteToggleError(AppTranslationKeys.error.tr()));
    }
  }

  // ── Get Bookings ──
  Future<void> getBookings() async {
    emit(BookingsLoading());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(BookingsError('يجب تسجيل الدخول أولاً'));
        return;
      }
      final bookings = await _repository.getBookings(token: token);
      emit(BookingsLoaded(bookings));
    } on ServerFailure catch (e) {
      emit(BookingsError(e.message));
    } on NetworkFailure catch (_) {
      emit(BookingsError(AppTranslationKeys.noInternet.tr()));
    } catch (_) {
      emit(BookingsError(AppTranslationKeys.error.tr()));
    }
  }

  // ── Cancel Booking ──
  Future<void> cancelBooking(int bookingId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        emit(BookingCancelError('يجب تسجيل الدخول أولاً'));
        return;
      }
      final booking = await _repository.cancelBooking(
        token: token,
        bookingId: bookingId,
      );
      emit(BookingCancelSuccess(booking));
      // ── Refresh Bookings ──
      await getBookings();
    } on ServerFailure catch (e) {
      emit(BookingCancelError(e.message));
    } on NetworkFailure catch (_) {
      emit(BookingCancelError(AppTranslationKeys.noInternet.tr()));
    } catch (_) {
      emit(BookingCancelError(AppTranslationKeys.error.tr()));
    }
  }

  // ── Submit Support ──
  Future<void> submitSupport({
    required String name,
    required String email,
    required String phone,
    required String problem,
  }) async {
    emit(SupportLoading());
    try {
      final token = await _getToken();
      if (token == null) {
        emit(SupportError('يجب تسجيل الدخول أولاً'));
        return;
      }
      await _repository.submitSupport(
        token: token,
        name: name,
        email: email,
        phone: phone,
        problem: problem,
      );
      emit(SupportSuccess());
    } on ServerFailure catch (e) {
      emit(SupportError(e.message));
    } on NetworkFailure catch (_) {
      emit(SupportError(AppTranslationKeys.noInternet.tr()));
    } catch (_) {
      emit(SupportError(AppTranslationKeys.error.tr()));
    }
  }
}
