import 'package:dio/dio.dart';
import 'package:your_cairo_trip/core/error/failures.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/login_response_model.dart';
import '../models/signup_request_model.dart';
import '../models/signup_response_model.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  // ── Login ──
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _remoteDataSource.login(email: email, password: password);
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'];
        if (message is Map) {
          throw ServerFailure(message['ar'] ?? 'حدث خطأ');
        }
        throw ServerFailure(message ?? 'حدث خطأ');
      }
      throw const NetworkFailure('تحقق من اتصالك بالإنترنت');
    }
  }

  // ── SignUp ──
  Future<SignUpResponseModel> signUp({
    required SignUpRequestModel request,
  }) async {
    try {
      return await _remoteDataSource.signUp(request: request);
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response?.data;

        // Extract top-level message (bilingual map or plain string)
        final rawMessage = data['message'];
        final String arMessage = rawMessage is Map
            ? (rawMessage['ar']?.toString() ?? 'حدث خطأ')
            : (rawMessage?.toString() ?? 'حدث خطأ');
        final String enMessage = rawMessage is Map
            ? (rawMessage['en']?.toString() ?? 'An error occurred')
            : (rawMessage?.toString() ?? 'An error occurred');

        // Extract field-level errors and keep both languages
        final rawErrors = data['errors'];
        if (rawErrors is Map && rawErrors.isNotEmpty) {
          final Map<String, Map<String, List<String>>> parsedErrors = {};

          rawErrors.forEach((field, value) {
            if (value is Map) {
              // Expected shape: {"ar": ["msg"], "en": ["msg"]}
              final arList =
                  (value['ar'] as List?)?.map((e) => e.toString()).toList() ??
                  [];
              final enList =
                  (value['en'] as List?)?.map((e) => e.toString()).toList() ??
                  [];
              parsedErrors[field.toString()] = {'ar': arList, 'en': enList};
            } else if (value is List) {
              // Plain list of strings (no language split)
              final msgs = value.map((e) => e.toString()).toList();
              parsedErrors[field.toString()] = {'ar': msgs, 'en': msgs};
            } else if (value is String) {
              parsedErrors[field.toString()] = {
                'ar': [value],
                'en': [value],
              };
            }
          });

          // Pass both ar/en top messages so the cubit can pick the right one
          throw ValidationFailure(
            '$arMessage|$enMessage',
            rawErrors: parsedErrors,
          );
        }

        throw ServerFailure(arMessage);
      }
      throw const NetworkFailure('تحقق من اتصالك بالإنترنت');
    }
  }
}
