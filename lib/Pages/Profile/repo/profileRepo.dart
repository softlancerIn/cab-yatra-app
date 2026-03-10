// 1. Auth Repository
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../cores/constants/api_constants.dart';
import '../../../../cores/exceptions/app_exceptions.dart';
import '../../../../cores/network/api_service.dart';
import '../../../../cores/network/network_utils.dart';
import '../../../../cores/services/secure_storage_service.dart';
import '../model/getProfileModel.dart';
import '../model/updateProfileModel.dart';



class ProfileRepo {
  final ApiService _api = ApiService();

  Future<UpdateProfileModel> updateProfile({
    required BuildContext context,
    required String type,
    required String name,
    required String licenseNumber,
    required String licenseNumber2,
    required String cInfo,
    required File driverImage,
  }) async {
    try {
      final response = await _api.uploadFiles(
        ApiConstants.profile,
        requiresAuth: true,
        files: {
          "driver_image": driverImage, // 👈 exact key
        },
        fields: {
          "type": type,
          "name": name,
          "license_number": licenseNumber,
          "license_number2": licenseNumber2,
          "c_info": cInfo,
        },
      );


      return UpdateProfileModel.fromJson(response);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => updateProfile(
            context: context,
            type: type,
            name: name,
            licenseNumber: licenseNumber,
            licenseNumber2: licenseNumber2,
            cInfo: cInfo,
            driverImage: driverImage,
          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => updateProfile(
            context: context,
            type: type,
            name: name,
            licenseNumber: licenseNumber,
            licenseNumber2: licenseNumber2,
            cInfo: cInfo,
            driverImage: driverImage,
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
  Future<GetProfileModel> getProfile({
    required BuildContext context,

  }) async {
    try {
      final response = await _api.get(
        ApiConstants.profile,
        requiresAuth: true,

      );
      print("?????????????????????");
print("👌👌👌👌Profile Get success 👌👌👌👌👌 ${response["data"]["id"]}");

      await SecureStorageService.saveUserID("${response['data']["id"]}");
      print("👌👌👌👌Profile Get success22 👌👌👌👌👌 ${response["data"]["id"]}");
      return GetProfileModel.fromJson(response);


    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getProfile(
            context: context,

          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getProfile(
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
