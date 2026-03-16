// 1. Auth Repository
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../cores/constants/api_constants.dart';
import '../../../../cores/exceptions/app_exceptions.dart';
import '../../../../cores/network/api_service.dart';
import '../../../../cores/network/network_utils.dart';
import '../../../../cores/services/secure_storage_service.dart';
import '../model/booking_create_model.dart';
import '../model/car_category_model.dart';
import '../model/updateAssignMethodModel.dart';


class AddBookingRepo {
  final ApiService _api = ApiService();



  Future<BookingCreateModel> bookingCreateApi({
    required String subType,
    required int carCategoryId,
    required String pickUp_date,
    required String pickUp_time,
    required List pickUpLoc,
    required List destinationLoc,
    required double total_faire,
    required double driverCommission,
    required bool is_show_phoneNumber,
    required String remarks,
    required String noOfDay,
    required String tripNotes,
    required BuildContext context,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.addBooking,
        data: {
          "subType": subType,
          "carCategoryId": carCategoryId,
          "pickUp_date": pickUp_date,
          "pickUp_time": pickUp_time,
          "no_of_days": noOfDay,
          "trip_notes": tripNotes,
          "pickUpLoc": pickUpLoc,
          "destinationLoc": destinationLoc,
          "total_faire": total_faire,
          "driverCommission": driverCommission,
          "is_show_phoneNumber": is_show_phoneNumber,
          "remarks": remarks,
        },
        requiresAuth: true,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return BookingCreateModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry:
              () => bookingCreateApi(
               context: context,
                carCategoryId: carCategoryId,
                destinationLoc: destinationLoc,
                driverCommission: driverCommission,
                noOfDay: noOfDay,
                tripNotes: tripNotes,
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
              () => bookingCreateApi(
                  context: context,
                  carCategoryId: carCategoryId,
                  destinationLoc: destinationLoc,
                  driverCommission: driverCommission,
                  is_show_phoneNumber: is_show_phoneNumber,
                  pickUp_date: pickUp_date,
                  pickUp_time: pickUp_time,
                  pickUpLoc: pickUpLoc,
                  remarks: remarks,
                  tripNotes: tripNotes,
                  noOfDay: noOfDay,
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



  Future<CarCategoryModel> getCarCategory({

    required BuildContext context,
  }) async {
    try {
      final response = await _api.get(
        ApiConstants.getCarCategory,

        requiresAuth: true,
      );

      return CarCategoryModel.fromJson(response);
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
  }  Future<UpdateAssignMethodModel> updateAssignMethodApi({

    required BuildContext context,
    required String assignType,
  }) async {
    try {
      final response = await _api.put(
        ApiConstants.updateAssignMethod,
        data: {
          "assignType": assignType,

        },

        requiresAuth: true,
      );

      return UpdateAssignMethodModel.fromJson(response);
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
