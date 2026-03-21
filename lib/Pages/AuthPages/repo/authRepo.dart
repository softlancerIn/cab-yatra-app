// 1. Auth Repository
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cores/constants/api_constants.dart';
import '../../../../cores/exceptions/app_exceptions.dart';
import '../../../../cores/network/api_service.dart';
import '../../../../cores/network/network_utils.dart';
import '../../../../cores/services/secure_storage_service.dart';

import '../../../app/router/navigation/nav.dart';
import '../../../app/router/navigation/routes.dart';
import '../login/model/loginModel.dart';
import '../otp/bloc/otpBloc.dart';
import '../otp/bloc/otpEvent.dart';
import '../otp/model/verifyOtpModel.dart';
import '../register/model/registerModel.dart';

class AuthRepo {
  final ApiService _api = ApiService();

  Future<LoginModel> sendOtp({
    required String phone,
    required BuildContext context,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.sendOtp,
        data: {'mobile': phone},
        requiresAuth: false,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return LoginModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => sendOtp(phone: phone, context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => sendOtp(phone: phone, context: context),
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

  Future<RegisterModel> registerOtp({
    required String mobile,
    required String otp,
    required String name,
    required String city,

    required BuildContext context,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.registration,
        data: {
          "mobile": mobile,
          "otp": otp,
          "name": name,
          "city": city,

        },
        requiresAuth: false,
      );
      final String? token = response['token'] ?? response['data']?['token'];
      if (token != null) {
        await SecureStorageService.saveToken(token);
      }
      if (response['data'] != null && response['data']["isAgent"] != null) {
        await SecureStorageService.saveIsAgent(response['data']["isAgent"]);
      }
      
      return RegisterModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry:
              () => registerOtp(
             otp: otp,
                city: city,
                mobile: mobile,
                context: context,
                name: name,

              ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry:
              () => registerOtp(
                otp: otp,
                city: city,
                mobile: mobile,
                context: context,
                name: name,
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

  Future<VerifyOtpModel> verifyOtp({
    required String phone,
    required String otp,
    required BuildContext context,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.verifyOtp,
        data: {'mobile': phone, "otp": otp},
        requiresAuth: false,
      );
      // Nav.go(
      //  context,
      //   Routes.home,
      //
      // );
      print("Store>>>>>>>>>>>>>>>>>>token ${response['token']}");

      if(response["user_type"]=="Old"){
        Nav.go(context, Routes.home);
      }

   else   if(response["user_type"]=="New"){
        {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              title: const Text(
                "Verification Failed",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              content: Text(
               response["message"],
                style: const TextStyle(fontSize: 14),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Redirect new user to registration screen
                    Nav.go(context, Routes.newRegister, extra: phone);
                   context.read<OTPBloc>().add(const ResetVerifyOtpEvent());
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );}
      }
      await SecureStorageService.saveToken(response['token']);

      await SecureStorageService.saveIsAgent(response['data']["isAgent"]);
     // await SecureStorageService.saveIsUser(response['data']["isUser"]);
      return VerifyOtpModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => verifyOtp(phone: phone, otp: otp, context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => verifyOtp(phone: phone, otp: otp, context: context),
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

  // Future<SettingResponseModel> getSettingsApi({
  //
  //   required BuildContext context,
  // }) async {
  //   try {
  //     final response = await _api.get(
  //       ApiConstants.settingData,
  //
  //       requiresAuth: true,
  //     );
  //
  //     return SettingResponseModel.fromJson(response);
  //     //  return LoginModel.fromJson(response['user']);
  //   } on DioException catch (e) {
  //     if (e.error is NoInternetException) {
  //       showNoInternetScreen(
  //         context,
  //         onRetry: () => getSettingsApi( context: context),
  //       );
  //       throw NoInternetException();
  //     } else if (e.error is ServerException) {
  //       showServerErrorScreen(
  //         context,
  //         onRetry: () => getSettingsApi( context: context),
  //       );
  //       throw ServerException();
  //     } else if (e.error is UnauthorizedException) {
  //       await SecureStorageService.logout(context);
  //       throw UnauthorizedException();
  //     } else {
  //       rethrow;
  //     }
  //   } catch (e) {
  //     throw ApiException(0, e.toString());
  //   }
  // }
}
