// lib/features/places/presentation/cubit/places_cubit.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_cairo_trip/core/error/failures.dart';
import 'package:your_cairo_trip/features/places/data/model/budget_request_model.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../data/repositories/places_repository.dart';
import 'places_state.dart';

class PlacesCubit extends Cubit<PlacesState> {
  final PlacesRepository _placesRepository;

  PlacesCubit(this._placesRepository) : super(PlacesInitial());

  Future<void> getBudgetPlaces({
    required String budget,
    required String personCount,
    required String token,
  }) async {
    if (budget.isEmpty) {
      emit(PlacesFailure(AppTranslationKeys.homeBudgetRequired.tr()));
      return;
    }

    final double? budgetValue = double.tryParse(budget);
    if (budgetValue == null || budgetValue <= 0) {
      emit(PlacesFailure(AppTranslationKeys.homeBudgetInvalid.tr()));
      return;
    }

    final int? personCountValue = int.tryParse(personCount);
    if (personCountValue == null || personCountValue <= 0) {
      emit(PlacesFailure(AppTranslationKeys.homePersonCountInvalid.tr()));
      return;
    }

    emit(PlacesLoading());

    try {
      final request = BudgetRequestModel(
        budget: budgetValue,
        personCount: personCountValue,
      );

      final response = await _placesRepository.getBudgetPlaces(
        request: request,
        token: token,
      );

      emit(PlacesSuccess(response));
    } on ServerFailure catch (e) {
      emit(PlacesFailure(e.message));
    } on NetworkFailure catch (_) {
      emit(PlacesFailure(AppTranslationKeys.noInternet.tr()));
    } catch (e, stackTrace) {
      debugPrint('❌ PlacesCubit Error: $e');
      debugPrint('❌ StackTrace: $stackTrace');
      emit(PlacesFailure('$e'));
    }
  }

  // ── بعد الحجز نعمل mark للمكان ونخصم التكلفة ──
  void markAsBooked({required int placeId, required num bookedCost}) {
    final currentState = state;
    if (currentState is! PlacesSuccess) return;

    final updatedIds = {...currentState.bookedPlaceIds, placeId};
    final updatedCost = currentState.totalBookedCost + bookedCost;

    emit(
      currentState.copyWith(
        bookedPlaceIds: updatedIds,
        totalBookedCost: updatedCost,
      ),
    );
  }
}
