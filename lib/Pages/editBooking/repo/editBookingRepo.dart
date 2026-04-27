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
import '../../Add New Booking/model/updateAssignMethodModel.dart';

class EditBookingRepo {
  final ApiService _api = ApiService();

  Future<EditBookingModel> editBookingApi({
    required String id,
    required String subType,
    required int carCategoryId,
    required String pickUp_date,
    required String pickUp_time,
    required List pickUpLoc,
    required List destinationLoc,
    required double total_faire,
    required double driverCommission,
    required int is_show_phoneNumber,
    required String remarks,
    required List<String>? extra,
    required String? noOfDays,
    required String? tripNotes,
    required BuildContext context,
  }) async {
    try {
      final response = await _api.put(
        "${ApiConstants.addBooking}/$id",
        data: {
          "subType": subType,
          "carCategoryId": carCategoryId,
          "pickUp_date": pickUp_date,
          "pickUp_time": pickUp_time,
          "pickUpLoc": pickUpLoc,
          "destinationLoc": destinationLoc,
          "total_faire": total_faire,
          "driverCommission": driverCommission,
          "is_show_phoneNumber": is_show_phoneNumber,
          "remarks": remarks,
          "extra": extra,
          "no_of_days": noOfDays,
          "trip_notes": tripNotes,
        },
        requiresAuth: true,
      );
      return EditBookingModel.fromJson(response);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => editBookingApi(
            id: id,
            context: context,
            carCategoryId: carCategoryId,
            destinationLoc: destinationLoc,
            driverCommission: driverCommission,
            is_show_phoneNumber: is_show_phoneNumber,
            pickUp_date: pickUp_date,
            pickUp_time: pickUp_time,
            pickUpLoc: pickUpLoc,
            remarks: remarks,
            extra: extra,
            subType: subType,
            total_faire: total_faire,
            noOfDays: noOfDays,
            tripNotes: tripNotes,
          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => editBookingApi(
            id: id,
            context: context,
            carCategoryId: carCategoryId,
            destinationLoc: destinationLoc,
            driverCommission: driverCommission,
            is_show_phoneNumber: is_show_phoneNumber,
            pickUp_date: pickUp_date,
            pickUp_time: pickUp_time,
            pickUpLoc: pickUpLoc,
            remarks: remarks,
            extra: extra,
            subType: subType,
            total_faire: total_faire,
            noOfDays: noOfDays,
            tripNotes: tripNotes,
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
          onRetry: () => getCarCategory(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getCarCategory(context: context),
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

  Future<UpdateAssignMethodModel> updateAssignMethodApi({
    required BuildContext context,
    required String assignType,
    required String bookingId,
  }) async {
    try {
      final response = await _api.put(
        "${ApiConstants.updateAssignMethod}/$bookingId",
        data: {
          "assignType": assignType,
        },
        requiresAuth: true,
      );
      return UpdateAssignMethodModel.fromJson(response);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => updateAssignMethodApi(
              context: context, assignType: assignType, bookingId: bookingId),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => updateAssignMethodApi(
              context: context, assignType: assignType, bookingId: bookingId),
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
