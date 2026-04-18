import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_cairo_trip/core/error/failures.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../../core/storage/token_manager.dart';
import '../../data/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginInitial());

  Future<void> login({required String email, required String password}) async {
    if (email.isEmpty) {
      emit(LoginFailure(AppTranslationKeys.loginEmailRequired.tr()));
      return;
    }
    if (password.isEmpty) {
      emit(LoginFailure(AppTranslationKeys.loginPasswordRequired.tr()));
      return;
    }

    emit(LoginLoading());

    try {
      final response = await _authRepository.login(
        email: email,
        password: password,
      );

      // ── save token ──
      await TokenManager.saveToken(response.token);

      emit(LoginSuccess(response));
    } on ServerFailure catch (e) {
      emit(LoginFailure(e.message));
    } on NetworkFailure catch (_) {
      emit(LoginFailure(AppTranslationKeys.noInternet.tr()));
    } catch (_) {
      emit(LoginFailure(AppTranslationKeys.loginUnexpectedError.tr()));
    }
  }
}
