// lib/features/places/presentation/cubit/places_state.dart

import 'package:equatable/equatable.dart';
import 'package:your_cairo_trip/features/places/data/model/budget_response_model.dart';

abstract class PlacesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlacesInitial extends PlacesState {}

class PlacesLoading extends PlacesState {}

class PlacesSuccess extends PlacesState {
  final BudgetResponseModel budgetResponse;

  // ── IDs الأماكن اللي اتحجزت ──
  final Set<int> bookedPlaceIds;

  // ── إجمالي فلوس الحجوزات ──
  final num totalBookedCost;

  PlacesSuccess(
    this.budgetResponse, {
    this.bookedPlaceIds = const {},
    this.totalBookedCost = 0,
  });

  // ── Copy with ──
  PlacesSuccess copyWith({
    BudgetResponseModel? budgetResponse,
    Set<int>? bookedPlaceIds,
    num? totalBookedCost,
  }) {
    return PlacesSuccess(
      budgetResponse ?? this.budgetResponse,
      bookedPlaceIds: bookedPlaceIds ?? this.bookedPlaceIds,
      totalBookedCost: totalBookedCost ?? this.totalBookedCost,
    );
  }

  @override
  List<Object?> get props => [budgetResponse, bookedPlaceIds, totalBookedCost];
}

class PlacesFailure extends PlacesState {
  final String message;

  PlacesFailure(this.message);

  @override
  List<Object?> get props => [message];
}
