// lib/features/explore/presentation/cubit/explore_state.dart

import 'package:equatable/equatable.dart';
import '../../data/models/explore_place_model.dart';

abstract class ExploreState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExploreSuccess extends ExploreState {
  final List<ExplorePlaceModel> places;
  final String activeFilter; // 'all' | 'free' | 'paid'

  ExploreSuccess({required this.places, this.activeFilter = 'all'});

  @override
  List<Object?> get props => [places, activeFilter];
}

class ExploreFailure extends ExploreState {
  final String message;

  ExploreFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// ── حالة تحديث المفضلة بدون reload كامل ──
class ExploreFavouriteUpdated extends ExploreState {
  final int placeId;
  final bool isFavourite;

  ExploreFavouriteUpdated({required this.placeId, required this.isFavourite});

  @override
  List<Object?> get props => [placeId, isFavourite];
}
