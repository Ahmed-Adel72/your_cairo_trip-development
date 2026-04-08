// lib/features/settings/presentation/cubit/support_cubit.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_cairo_trip/core/error/failures.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../../core/storage/token_manager.dart';
import '../../data/repositories/support_repository.dart';
import 'support_state.dart';

class SupportCubit extends Cubit<SupportState> {
  final SupportRepository _repository;

  SupportCubit(this._repository) : super(SupportInitial());

  Future<void> submitSupport({
    required String name,
    required String email,
    required String phone,
    required String problem,
  }) async {
    emit(SupportLoading());
    try {
      final token = await TokenManager.getToken();
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
      emit(SupportError(AppTranslationKeys.supportUnexpectedError.tr()));
    }
  }
}
