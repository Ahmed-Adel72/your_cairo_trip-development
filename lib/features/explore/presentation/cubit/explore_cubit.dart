// lib/features/explore/presentation/cubit/explore_cubit.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_cairo_trip/core/error/failures.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../../core/storage/token_manager.dart';
import '../../data/models/explore_place_model.dart';
import '../../data/repositories/explore_repository.dart';
import 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  final ExploreRepository _repository;

  // ── القائمة الأصلية الكاملة ──
  List<ExplorePlaceModel> _allPlaces = [];

  // ── القائمة الحالية المعروضة (بعد فلتر أو سيرش) ──
  List<ExplorePlaceModel> _currentPlaces = [];

  String _activeFilter = 'all';

  ExploreCubit(this._repository) : super(ExploreInitial());

  // ── جلب كل الأماكن ──
  Future<void> getPlaces() async {
    emit(ExploreLoading());
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        emit(ExploreFailure('يجب تسجيل الدخول أولاً'));
        return;
      }
      _allPlaces = await _repository.getPlaces(token);
      _currentPlaces = List.from(_allPlaces);
      _activeFilter = 'all';
      emit(ExploreSuccess(places: _currentPlaces, activeFilter: _activeFilter));
    } on ServerFailure catch (e) {
      emit(ExploreFailure(e.message));
    } on NetworkFailure catch (_) {
      emit(ExploreFailure(AppTranslationKeys.noInternet.tr()));
    } catch (_) {
      emit(ExploreFailure(AppTranslationKeys.exploreUnexpectedError.tr()));
    }
  }

  // ── السيرش ──
  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) {
      _currentPlaces = List.from(_allPlaces);
      emit(ExploreSuccess(places: _currentPlaces, activeFilter: _activeFilter));
      return;
    }

    emit(ExploreLoading());
    try {
      final token = await TokenManager.getToken();
      if (token == null) return;

      final results = await _repository.searchPlaces(query, token);
      _currentPlaces = results;
      emit(ExploreSuccess(places: _currentPlaces, activeFilter: _activeFilter));
    } on ServerFailure catch (e) {
      emit(ExploreFailure(e.message));
    } on NetworkFailure catch (_) {
      emit(ExploreFailure(AppTranslationKeys.noInternet.tr()));
    } catch (_) {
      emit(ExploreFailure(AppTranslationKeys.exploreUnexpectedError.tr()));
    }
  }

  // ── الفلتر ──
  Future<void> filterPlaces(String filter) async {
    _activeFilter = filter;

    if (filter == 'all') {
      _currentPlaces = List.from(_allPlaces);
      emit(ExploreSuccess(places: _currentPlaces, activeFilter: _activeFilter));
      return;
    }

    emit(ExploreLoading());
    try {
      final token = await TokenManager.getToken();
      if (token == null) return;

      final results = await _repository.filterPlaces(
        token: token,
        isFree: filter == 'free',
      );
      _currentPlaces = results;
      emit(ExploreSuccess(places: _currentPlaces, activeFilter: _activeFilter));
    } on ServerFailure catch (e) {
      emit(ExploreFailure(e.message));
    } on NetworkFailure catch (_) {
      emit(ExploreFailure(AppTranslationKeys.noInternet.tr()));
    } catch (_) {
      emit(ExploreFailure(AppTranslationKeys.exploreUnexpectedError.tr()));
    }
  }

  // ── Toggle Favourite ──
  Future<void> toggleFavourite(int placeId) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) return;

      final isFavourite = await _repository.toggleFavourite(placeId, token);

      // ── تحديث القائمتين محلياً ──
      for (final place in _allPlaces) {
        if (place.id == placeId) {
          place.isFavourite = isFavourite;
          break;
        }
      }
      for (final place in _currentPlaces) {
        if (place.id == placeId) {
          place.isFavourite = isFavourite;
          break;
        }
      }

      // ── أولاً: أبعت الـ FavouriteUpdated للـ SnackBar ──
      emit(ExploreFavouriteUpdated(placeId: placeId, isFavourite: isFavourite));

      // ── ثانياً: ارجع للـ Success بالـ currentPlaces مع الفلتر الحالي ──
      emit(ExploreSuccess(places: _currentPlaces, activeFilter: _activeFilter));
    } catch (_) {}
  }
}
