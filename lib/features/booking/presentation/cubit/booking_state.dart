// lib/features/booking/presentation/cubit/booking_state.dart

import 'package:equatable/equatable.dart';
import '../../data/models/booking_response_model.dart';

abstract class BookingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final BookingResponseModel bookingResponse;

  BookingSuccess(this.bookingResponse);

  @override
  List<Object?> get props => [bookingResponse];
}

class BookingFailure extends BookingState {
  final String message;

  BookingFailure(this.message);

  @override
  List<Object?> get props => [message];
}
