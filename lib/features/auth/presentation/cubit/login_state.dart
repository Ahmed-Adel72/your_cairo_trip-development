// lib/features/auth/presentation/cubit/login_state.dart

import 'package:equatable/equatable.dart';
import '../../data/models/login_response_model.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

// ── الحالة الابتدائية ──
class LoginInitial extends LoginState {}

// ── جاري تسجيل الدخول ──
class LoginLoading extends LoginState {}

// ── تسجيل الدخول نجح ──
class LoginSuccess extends LoginState {
  final LoginResponseModel loginResponse;

  LoginSuccess(this.loginResponse);

  @override
  List<Object?> get props => [loginResponse];
}

// ── تسجيل الدخول فشل ──
class LoginFailure extends LoginState {
  final String message;

  LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}
