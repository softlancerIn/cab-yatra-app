import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/ui/homepage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Pages/Add Profile/add_profile.dart';
import '../Pages/AuthPages/otp/ui/verify_otp.dart';
import '../Pages/HomePageFlow/home_controller.dart';
import '../core/api_client.dart';
import '../core/network_service.dart';
import '../models/add_driver_model.dart';

class AuthController extends GetxController {
  NetworkService service = NetworkService();

  var addDriverModel = AddDriverModel().obs;

  var nextSeen = false.obs;

  Future<void> sendOtp({required String mobile}) async {
    try {
      final response = await service.sendOtpUser(mobile: mobile);

      if (response != null) {
        if (response.status == true) {
          Get.to(() => VerifyOtpPage(
                mobile: mobile,
              ));
          print('OTP sent successfully: ${response.otp}');
        } else {
          if (response.userType!.toLowerCase() == 'new') {
            Get.to(() => Profile(
                  mobile: mobile,
                ));
          }
        }
      } else {
        if (kDebugMode) {
          print('Failed to send OTP');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending OTP: $e');
      }
    }
  }

  Future<void> verifyOtp({required String mobile, required String otp}) async {
    try {
      final response = await service.verifyOtpUser(mobile: mobile, otp: otp);

      if (response != null) {
        if (response.status == true) {
          ///
          String? token = response.token;

          if (token != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', token);
            DioClient.setToken(token);
          }

          ///
          if (response.userType!.toLowerCase() == 'new') {
            Get.to(() => Profile(
                  mobile: mobile,
                ));
          } else {
            Get.offAll(const MainHomeController());
          }
          // Get.to(() => VerifyOtpPage(
          //       mobile: mobile,
          //     ));
          // print('OTP sent successfully: ${response.otp}');
        } else {
          if (response.userType!.toLowerCase() == 'new') {
            Get.to(() => Profile(
                  mobile: mobile,
                ));
          } else {
            String? token = response.token;

            if (token != null) {
              Get.offAll(const MainHomeController());
            } else {
              Get.to(() => Profile(
                    mobile: mobile,
                  ));
            }
          }
        }
      } else {
        if (kDebugMode) {
          print('Failed to send OTP');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending OTP: $e');
      }
    }
  }

  Future<void> uploadDriverDetails({
    required String name,
    required String email,
    required String phone,
    required String aadhaarFrontImage,
    required String aadhaarBackImage,
    required String aadhaarNo,
    required String pan,
    required String dlNo,
    required String dlImage,
    required String driverPhoto,
  }) async {
    try {
      final response = await service.uploadDriverDetails(
          name: name,
          email: email,
          pan: pan,
          phone: phone,
          aadhaarFrontImage: aadhaarFrontImage,
          aadhaarBackImage: aadhaarBackImage,
          aadhaarNo: aadhaarNo,
          dlImage: dlImage,
          dlNo: dlNo,
          driverPhoto: driverPhoto);

      if (response != null) {
        if (response.status == true) {
          nextSeen.value = true;
          addDriverModel.value = response;
          // Get.to(() => VerifyOtpPage(
          //       mobile: mobile,
          //     ));
          // print('OTP sent successfully: ${response.otp}');
        } else {
          // if (response.userType!.toLowerCase() == 'new') {
          //   // Get.to(() => Profile(
          //   //       mobile: mobile,
          //   //     ));
          // }
        }
      } else {
        if (kDebugMode) {
          print('Failed to send OTP');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending OTP: $e');
      }
    }
  }

  Future<void> uploadCarDetails({
    required String driverId,
    required String carBrand,
    required String carName,
    required String carRcFrontImage,
    required String carRcBackImage,
    required String fuelType,
    required String carNo,
    required String seat,
    required String expiryDate,
    required String insuranceImage,
    required String carImage,
  }) async {
    try {
      final response = await service.uploadCarDetails(
          driverId: driverId,
          carBrand: carBrand,
          carName: carName,
          carRcFrontImage: carRcFrontImage,
          carRcBackImage: carRcBackImage,
          fuelType: fuelType,
          carNo: carNo,
          seat: seat,
          expiryDate: expiryDate,
          insuranceImage: insuranceImage,
          carImage: carImage);

      if (response != null) {
        if (response.status == true) {
          Get.offAll(() => MainHomeController());
          // nextSeen.value = true;
          // addDriverModel.value = response;
          //           // Get.to(() => VerifyOtpPage(
          //       mobile: mobile,
          //     ));
          // print('OTP sent successfully: ${response.otp}');
        } else {
          // if (response.userType!.toLowerCase() == 'new') {
          //   // Get.to(() => Profile(
          //   //       mobile: mobile,
          //   //     ));
          // }
        }
      } else {
        if (kDebugMode) {
          print('Failed to send OTP');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending OTP: $e');
      }
    }
  }
}
