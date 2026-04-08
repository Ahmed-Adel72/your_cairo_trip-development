// lib/features/auth/presentation/cubit/signup_cubit.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_cairo_trip/core/error/failures.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../../core/storage/token_manager.dart';
import '../../data/models/signup_request_model.dart';
import '../../data/repositories/auth_repository.dart';
import 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository _authRepository;

  SignUpCubit(this._authRepository) : super(SignUpInitial());

  Future<void> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    if (name.isEmpty) {
      emit(SignUpFailure(AppTranslationKeys.signUpNameRequired.tr()));
      return;
    }
    if (email.isEmpty) {
      emit(SignUpFailure(AppTranslationKeys.signUpEmailRequired.tr()));
      return;
    }
    if (phone.isEmpty) {
      emit(SignUpFailure(AppTranslationKeys.signUpPhoneRequired.tr()));
      return;
    }
    if (password.isEmpty) {
      emit(SignUpFailure(AppTranslationKeys.signUpPasswordRequired.tr()));
      return;
    }
    if (passwordConfirmation.isEmpty) {
      emit(
        SignUpFailure(AppTranslationKeys.signUpConfirmPasswordRequired.tr()),
      );
      return;
    }
    if (password != passwordConfirmation) {
      emit(SignUpFailure(AppTranslationKeys.signUpPasswordMismatch.tr()));
      return;
    }

    emit(SignUpLoading());

    try {
      final request = SignUpRequestModel(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      final response = await _authRepository.signUp(request: request);

      // ── حفظ التوكن ──
      await TokenManager.saveToken(response.token);

      emit(SignUpSuccess(response));
    } on ServerFailure catch (e) {
      emit(SignUpFailure(e.message));
    } on NetworkFailure catch (_) {
      emit(SignUpFailure(AppTranslationKeys.noInternet.tr()));
    } catch (_) {
      emit(SignUpFailure(AppTranslationKeys.signUpUnexpectedError.tr()));
    }
  }
}
