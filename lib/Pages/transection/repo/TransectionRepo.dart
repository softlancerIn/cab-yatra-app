// 1. Auth Repository

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../cores/constants/api_constants.dart';
import '../../../../cores/exceptions/app_exceptions.dart';
import '../../../../cores/network/api_service.dart';
import '../../../../cores/network/network_utils.dart';
import '../../../../cores/services/secure_storage_service.dart';

import '../model/getTransectionModel.dart';

class TransectionRepo {
  final ApiService _api = ApiService();

  Future<GetTransectionModel> getTransction({
    required BuildContext context,
  }) async {
    try {
      final response = await _api.get(
        ApiConstants.transactions,
        requiresAuth: true,
      );
      print("👌👌👌👌driverImageUrldriverImageUrldriverImageUrldriverImageUrl");

      return GetTransectionModel.fromJson(response);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getTransction(
            context: context,
          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getTransction(
            context: context,
          ),
        );
        throw ServerException();
      } else if (e.error is UnauthorizedException) {
        await SecureStorageService.logout(context);
        throw UnauthorizedException();
      } else {
        rethrow;
      }
    } catch (e) {
      throw ApiException(0, e.toString());
    }
  }
}
