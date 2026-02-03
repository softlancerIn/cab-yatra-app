import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiResponse {
  final bool status;
  final String? message;
  final dynamic data;
  final Map<String, dynamic>? errors;

  ApiResponse({
    required this.status,
    this.message,
    this.data,
    this.errors,
  });
}

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  DioClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
    _initializeToken();
    setupInterceptors();
  }

  late Dio _dio;
  static String? _token;
  static const String _baseUrl =
      // 'https://taxibooking.teknikoglobal.in/api/driver';
      'https://cabyatra.com/api/driver'; //updation tip: will have to update in network_service also

  static Future<void> setToken(String? token) async {
    _token = token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString('auth_token', token);
    } else {
      await prefs.remove('auth_token');
    }
  }

  Future<void> _initializeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  void setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          debugPrint('--- API Request ---');
          debugPrint('URL: ${options.uri}');
          debugPrint('Method: ${options.method}');
          debugPrint('Headers: ${options.headers}');
          debugPrint('Query Parameters: ${options.queryParameters}');
          debugPrint('Request Data: ${options.data}');
          if (_token != null) {
            debugPrint('Token: Bearer $_token');
            options.headers['Authorization'] = 'Bearer $_token';
          } else {
            debugPrint('Token: Not Provided');
          }
          // if (_token != null) {
          //   options.headers['Authorization'] = 'Bearer $_token';
          // }
          return handler.next(options);
        },
        onResponse: (response, handler) => handler.next(response),
        onError: (DioException e, handler) => handler.next(e),
      ),
    );
  }
  Future<bool> isConnected() async {
    final List<ConnectivityResult> connectivityResults = await Connectivity().checkConnectivity();
    for (var result in connectivityResults) {
      if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
        print('connected to internet');
        return true;
      }
    }

    return false;
  }


  static ApiResponse handleApiResponse(Response? response) {
    if (response != null) {
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successful response
        return ApiResponse(
          status: true,
          message: response.data['message'],
          data: response.data['data'],
        );
      } else {
        // Error response
        return ApiResponse(
          status: false,
          message: response.data['message'] ?? 'An error occurred',
          errors: response.data['error'] ?? 'No additional error info',
        );
      }
    } else {
      return ApiResponse(
        status: false,
        message: 'No response from the server.',
      );
    }
  }


  static Future<Response?> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    if (!await DioClient().isConnected()) {
      throw Exception("Not connected to the internet");
    }
    try {
      return await DioClient()
          ._dio
          .get(_baseUrl + path, queryParameters: queryParameters);
    } catch (e) {
      debugPrint('GET Error: $e');
      return null;
    }
  }


  static Future<Response?> post(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    if (!await DioClient().isConnected()) {
      throw Exception("Not connected to the internet");
    }
    try {
      debugPrint('Calling API: $_baseUrl$path');
      debugPrint('Data: $data');
      final response = await DioClient()._dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      debugPrint('Response: ${response.data}');
      return response;
    } catch (e) {
      if (e is DioException) {
        debugPrint('POST Error: ${e.response?.data}');
        debugPrint('Error Status Code: ${e.response?.statusCode}');
      } else {
        debugPrint('Unexpected Error: $e');
      }
      return null;
    }
  }

  static Future<Response?> put(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    if (!await DioClient().isConnected()) {
      throw Exception("Not connected to the internet");
    }
    try {
      return await DioClient()._dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } catch (e) {
      log('PUT Error: $e');
      return null;
    }
  }

  static Future<Response?> delete(String path,
      {Map<String, dynamic>? queryParameters}) async {
    if (!await DioClient().isConnected()) {
      throw Exception("Not connected to the internet");
    }
    try {
      return await DioClient()
          ._dio
          .delete(path, queryParameters: queryParameters);
    } catch (e) {
      debugPrint('DELETE Error: $e');
      return null;
    }
  }

  static Future<Response?> uploadFileWithProgress(
    String path, {
    required String filePath,
    Map<String, dynamic>? data,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        ...?data,
        'file': await MultipartFile.fromFile(filePath,
            filename: filePath.split('/').last),
      });

      return await DioClient()._dio.post(
            path,
            data: formData,
            options: Options(headers: {'Content-Type': 'multipart/form-data'}),
            onSendProgress: onSendProgress,
          );
    } catch (e) {
      debugPrint('Multipart Request Error: $e');
      return null;
    }
  }

  static Future<Response?> uploadFilesWithKeysAndProgress(
      String path, {
        required Map<String, String> fileKeyPathMap, // Map of keys and file paths
        Map<String, dynamic>? data,
        void Function(int sent, int total)? onSendProgress,
      }) async {
    if (!await DioClient().isConnected()) {
      throw Exception("Not connected to the internet");
    }
    try {
      print('calling api: $_baseUrl$path');
      print('calling api file data: $fileKeyPathMap');
      print('calling api data: $data');
      final Map<String, dynamic> fileMap = {};
      for (var entry in fileKeyPathMap.entries) {
        if (entry.value.isNotEmpty) {
          // Validate file existence
          final file = File(entry.value);
          if (!file.existsSync()) {
            print(
                "Warning: File for '${entry.key}' does not exist at path: ${entry.value}");
            continue; // Skip this file if it doesn't exist
          }

          fileMap[entry.key] = await MultipartFile.fromFile(
            entry.value,
            filename: entry.value.split('/').last,
          );
        } else {
          print("Skipping empty file path for key: '${entry.key}'");
        }
      }

      final combinedData = {
        ...?data,
        ...fileMap,
      };

      final formData = FormData.fromMap(combinedData);

      return await DioClient()._dio.post(
        path,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
        onSendProgress: onSendProgress,
      );
    } catch (e) {
      debugPrint('Multipart Request Error: $e');
      return null;
    }
  }

}

// void setupInterceptors() {
//   _dio.interceptors.add(
//     InterceptorsWrapper(
//       onRequest: (options, handler) {
//         options.headers['Authorization'] = 'Bearer YOUR_TOKEN_HERE';
//         return handler.next(options);
//       },
//       onResponse: (response, handler) {
//         return handler.next(response);
//       },
//       onError: (DioException e, handler) {
//         return handler.next(e);
//       },
//     ),
//   );
// }
