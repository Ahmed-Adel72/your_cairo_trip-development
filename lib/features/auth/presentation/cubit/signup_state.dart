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

  /// Field-level errors from the API, e.g. {'email': 'يجب أن يكون...', 'password': '...'}
  final Map<String, String> fieldErrors;

  SignUpFailure(this.message, {this.fieldErrors = const {}});

  @override
  List<Object?> get props => [message, fieldErrors];
}
