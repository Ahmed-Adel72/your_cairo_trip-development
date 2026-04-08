// lib/features/profile/presentation/cubit/profile_state.dart

import 'package:equatable/equatable.dart';
import '../../data/models/booking_list_model.dart';
import '../../data/models/favourite_model.dart';
import '../../data/models/profile_model.dart';
import '../../data/models/trip_model.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

// ── Initial ──
class ProfileInitial extends ProfileState {}

// ── Get Profile ──
class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Update Profile ──
class ProfileUpdateLoading extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {
  final ProfileModel profile;
  ProfileUpdateSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdateError extends ProfileState {
  final String message;
  ProfileUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Logout ──
class LogoutLoading extends ProfileState {}

class LogoutSuccess extends ProfileState {}

class LogoutError extends ProfileState {
  final String message;
  LogoutError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Trips ──
class TripsLoading extends ProfileState {}

class TripsLoaded extends ProfileState {
  final List<TripModel> completedTrips;
  final List<TripModel> upcomingTrips;

  TripsLoaded({required this.completedTrips, required this.upcomingTrips});

  @override
  List<Object?> get props => [completedTrips, upcomingTrips];
}

class TripsError extends ProfileState {
  final String message;
  TripsError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Rating ──
class RatingLoading extends ProfileState {}

class RatingSuccess extends ProfileState {}

class RatingError extends ProfileState {
  final String message;
  RatingError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Favourites ──
class FavouritesLoading extends ProfileState {}

class FavouritesLoaded extends ProfileState {
  final List<FavouriteModel> favourites;
  FavouritesLoaded(this.favourites);

  @override
  List<Object?> get props => [favourites];
}

class FavouritesError extends ProfileState {
  final String message;
  FavouritesError(this.message);

  @override
  List<Object?> get props => [message];
}

class FavouriteToggleSuccess extends ProfileState {
  final bool isFavourite;
  FavouriteToggleSuccess(this.isFavourite);

  @override
  List<Object?> get props => [isFavourite];
}

class FavouriteToggleError extends ProfileState {
  final String message;
  FavouriteToggleError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Bookings ──
class BookingsLoading extends ProfileState {}

class BookingsLoaded extends ProfileState {
  final List<BookingListModel> bookings;
  BookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class BookingsError extends ProfileState {
  final String message;
  BookingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class BookingCancelSuccess extends ProfileState {
  final BookingListModel booking;
  BookingCancelSuccess(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingCancelError extends ProfileState {
  final String message;
  BookingCancelError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Support ──
class SupportLoading extends ProfileState {}

class SupportSuccess extends ProfileState {}

class SupportError extends ProfileState {
  final String message;
  SupportError(this.message);

  @override
  List<Object?> get props => [message];
}
