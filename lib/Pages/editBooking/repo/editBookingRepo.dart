// 1. Auth Repository
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../cores/constants/api_constants.dart';
import '../../../../cores/exceptions/app_exceptions.dart';
import '../../../../cores/network/api_service.dart';
import '../../../../cores/network/network_utils.dart';
import '../../../../cores/services/secure_storage_service.dart';

import '../model/edit_Booking_model.dart';
import '../model/edit_car_category_model.dart';


class EditBookingRepo {
  final ApiService _api = ApiService();



  Future<EditBookingModel> editBookingApi({
    required String subType,
    required int carCategoryId,
    required String pickUp_date,
    required String pickUp_time,
    required List pickUpLoc,
    required List destinationLoc,
    required double total_faire,
    required double driverCommission,
    required double is_show_phoneNumber,
    required String remarks,
    required BuildContext context,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.addBooking,
        data: {
          "subType": "0", //hardcoded rahega ok
          "carCategoryId": 2,// car category wala api se aayag ok drop down se single select karega ok
          "pickUp_date": "2024-01-15",
          "pickUp_time": "10:30:00",
          "pickUpLoc": ["Ghaziabad"],
          "destinationLoc": ["Noida", "Delhi", "Gurgaon"],
          "total_faire": 1150.00,
          "driverCommission": 300.00,
          "is_show_phoneNumber": false,
          "remarks": "Please arrive 5 minutes early"
        },
        requiresAuth: true,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return EditBookingModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry:
              () => editBookingApi(
               context: context,
                carCategoryId: carCategoryId,
                destinationLoc: destinationLoc,
                driverCommission: driverCommission,
                is_show_phoneNumber: is_show_phoneNumber,
                pickUp_date: pickUp_date,
                pickUp_time: pickUp_time,
                pickUpLoc: pickUpLoc,
                remarks: remarks,
                subType: subType,
                total_faire: total_faire
              ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry:
              () => editBookingApi(
                  context: context,
                  carCategoryId: carCategoryId,
                  destinationLoc: destinationLoc,
                  driverCommission: driverCommission,
                  is_show_phoneNumber: is_show_phoneNumber,
                  pickUp_date: pickUp_date,
                  pickUp_time: pickUp_time,
                  pickUpLoc: pickUpLoc,
                  remarks: remarks,
                  subType: subType,
                  total_faire: total_faire
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



  Future<EditCarCategoryModel> getCarCategory({

    required BuildContext context,
  }) async {
    try {
      final response = await _api.get(
        ApiConstants.getCarCategory,

        requiresAuth: true,
      );

      return EditCarCategoryModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getCarCategory( context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getCarCategory( context: context),
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
