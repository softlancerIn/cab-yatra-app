// 1. Auth Repository
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../cores/constants/api_constants.dart';
import '../../../../cores/exceptions/app_exceptions.dart';
import '../../../../cores/network/api_service.dart';
import '../../../../cores/network/network_utils.dart';
import '../../../../cores/services/secure_storage_service.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/dashboardModel.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/cityModel.dart';
import 'package:cab_taxi_app/Pages/Add%20New%20Booking/model/car_category_model.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/alert_response_model.dart';

class DashboardRepo {
  final ApiService _api = ApiService();

  Future<CityResponse> getCitiesApi({
    required BuildContext context,
  }) async {
    try {
      final response = await _api.get(
        ApiConstants.getCities,
        requiresAuth: true,
      );
      return CityResponse.fromJson(response);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getCitiesApi(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getCitiesApi(context: context),
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

  Future<HomePageResponse> getHomeDataApi({

    required BuildContext context,
  }) async {
    try {
      final response = await _api.get(
        ApiConstants.homeData,

        requiresAuth: true,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return HomePageResponse.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getHomeDataApi( context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getHomeDataApi( context: context),
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

  Future<CarCategoryModel> getCarCategoryApi({
    required BuildContext context,
  }) async {
    try {
      final response = await _api.get(
        ApiConstants.getCarCategory,
        requiresAuth: true,
      );
      return CarCategoryModel.fromJson(response);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getCarCategoryApi(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getCarCategoryApi(context: context),
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

  Future<Map<String, dynamic>> updateAlertsApi({
    required BuildContext context,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.alerts,
        data: data,
        requiresAuth: true,
      );
      return response;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      throw ApiException(0, e.toString());
    }
  }

  Future<Map<String, dynamic>> clearAlertsApi({
    required BuildContext context,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.alertsClear,
        requiresAuth: true,
      );
      return response;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      throw ApiException(0, e.toString());
    }
  }
  Future<AlertResponseModel> getAlertsApi({
    required BuildContext context,
  }) async {
    try {
      final response = await _api.get(
        ApiConstants.alerts,
        requiresAuth: true,
      );
      return AlertResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getAlertsApi(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getAlertsApi(context: context),
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
