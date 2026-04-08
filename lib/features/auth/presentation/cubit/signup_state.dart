// lib/features/auth/presentation/cubit/signup_state.dart

import 'package:equatable/equatable.dart';
import '../../data/models/signup_response_model.dart';

abstract class SignUpState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final SignUpResponseModel signUpResponse;

  SignUpSuccess(this.signUpResponse);

  @override
  List<Object?> get props => [signUpResponse];
}

class SignUpFailure extends SignUpState {
  final String message;

  SignUpFailure(this.message);

  @override
  List<Object?> get props => [message];
}
