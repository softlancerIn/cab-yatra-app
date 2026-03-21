// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../constants/api_constants.dart';
import '../services/secure_storage_service.dart';
import '../exceptions/app_exceptions.dart';

class DioClient {
  static Dio get instance {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add token if requiresAuth is true (default)
          if (options.extra['requiresAuth'] ?? true) {
            final token = await SecureStorageService.getToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            debugPrint('🔑 TOKEN: $token');
          }

          // ✅ REQUEST LOG
          final fullUrl = options.path.startsWith('http') ? options.path : '${options.baseUrl}${options.path}';
          debugPrint('➡️ URL: $fullUrl');
          debugPrint('➡️ METHOD: ${options.method}');
          debugPrint('➡️ HEADERS: ${options.headers}');
          debugPrint('➡️ BODY: ${options.data}');
          debugPrint('➡️ QUERY: ${options.queryParameters}');

          handler.next(options);
        },
        onResponse: (response, handler) {
          // ✅ RESPONSE LOG
          debugPrint('✅ STATUS: ${response.statusCode}');
          debugPrint('✅ RESPONSE: ${response.data}');
          handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          // ✅ ERROR LOG
          debugPrint('❌ ERROR URL: ${error.requestOptions.uri}');
          debugPrint('❌ STATUS: ${error.response?.statusCode}');
          debugPrint('❌ MESSAGE: ${error.message}');
          debugPrint('❌ RESPONSE: ${error.response?.data}');

          // Handle 401 - Unauthorized
          if (error.response?.statusCode == 401) {
            final unauthorizedError = DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: UnauthorizedException(),
            );
            return handler.reject(unauthorizedError);
          }

          // Handle 5xx - Server Error
          if (error.response?.statusCode != null &&
              error.response!.statusCode! >= 500) {
            final serverError = DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: ServerException(),
            );
            return handler.reject(serverError);
          }

          // Handle No Internet / Timeout / Connection issues
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError ||
              error.message?.contains('SocketException') == true) {
            final noInternetError = DioException(
              requestOptions: error.requestOptions,
              type: error.type,
              error: NoInternetException(),
            );
            return handler.reject(noInternetError);
          }

          return handler.next(error);
        },
      ),
    );


    return dio;
  }
}