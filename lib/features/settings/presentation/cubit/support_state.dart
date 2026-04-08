// lib/features/settings/presentation/cubit/support_state.dart

import 'package:equatable/equatable.dart';

abstract class SupportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SupportInitial extends SupportState {}

class SupportLoading extends SupportState {}

class SupportSuccess extends SupportState {}

class SupportError extends SupportState {
  final String message;
  SupportError(this.message);

  @override
  List<Object?> get props => [message];
}
