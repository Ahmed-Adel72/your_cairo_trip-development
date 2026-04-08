import 'package:dio/dio.dart';
import '../constants/app_endpoints.dart';

class DioClient {
  DioClient._();

  static Dio getInstance() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // ── Interceptor للـ Logging ──
    dio.interceptors.add(LogInterceptor(request: true, responseBody: true));

    return dio;
  }
}
