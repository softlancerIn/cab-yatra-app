// Step 8: API Service (lib/core/network/api_service.dart)
// Complete with all methods: get, post, put, patch, delete, multipart
import 'dart:io';
import 'package:dio/dio.dart';
import 'dio_client.dart';
import 'network_utils.dart';
import '../exceptions/app_exceptions.dart';

class ApiService {
  final Dio _dio = DioClient.instance;

  Future<void> _checkInternet() async {
    if (!await hasInternet()) {
      throw NoInternetException();
    }
  }

  Future<dynamic> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        bool requiresAuth = true,
      }) async {
    await _checkInternet();
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        bool requiresAuth = true,
      }) async {
    await _checkInternet();
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> put(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        bool requiresAuth = true,
      }) async {
    await _checkInternet();
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> patch(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        bool requiresAuth = true,
      }) async {
    await _checkInternet();
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> delete(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        bool requiresAuth = true,
      }) async {
    await _checkInternet();
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> uploadFiles(
      String endpoint, {
        required Map<String, File> files,
        Map<String, dynamic>? fields,
        bool requiresAuth = true,
      }) async {
    await _checkInternet();

    try {
      final formData = FormData();

      if (fields != null) {
        formData.fields.addAll(
          fields.entries.map(
                (e) => MapEntry(e.key, e.value.toString()),
          ),
        );
      }

      for (var entry in files.entries) {
        formData.files.add(
          MapEntry(
            entry.key, // 👈 key same as API
            await MultipartFile.fromFile(
              entry.value.path,
              filename: entry.value.path.split('/').last,
            ),
          ),
        );
      }

      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(extra: {'requiresAuth': requiresAuth}),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

}