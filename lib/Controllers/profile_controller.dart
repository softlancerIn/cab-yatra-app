import 'package:get/get.dart';
import '../models/profile_model.dart';
import '../core/network_service.dart';
import 'package:flutter/foundation.dart';

class ProfileController extends GetxController {
  final NetworkService service = NetworkService();

  var profileData = DriverProfile().obs;
  var profileLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    getProfileData();
  }
  Future<void> getProfileData() async {
    try {
      profileLoading.value = true;
      final response = await service.getProfileData();

      if (response != null) {
        if (response.status == true) {
          profileData.value = response;
          update();
        } else {
          if (kDebugMode) {
            print('Failed to get profile data: ${response.message}');
          }
        }
      } else {
        if (kDebugMode) {
          print('Error fetching profile data: Response is null');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting profile data: $e');
      }
    } finally {
      profileLoading.value = false;
    }
  }

  Future<void> updateDriverProfileData({
    required String pan,
    required String driverPhoto,
    required String name,
    required String email,
    required String aadhaarNo,
    required String phone,
    required String dlNo,
  }) async {
    try {
      profileLoading.value = true;
      final bool? updateSuccess = await service.updateDriverDetails(
        pan: pan,
        driverPhoto: driverPhoto,
        name: name,
        email: email,
        aadhaarNo: aadhaarNo,
        phone: phone,
        dlNo: dlNo,
      );

      if (updateSuccess == true) {
        await getProfileData();
        update();
        debugPrint('Driver details updated successfully');
      } else {
        debugPrint('Failed to update driver details');
      }
    } catch (e) {
      debugPrint('Error updating driver profile data: $e');
    } finally {
      profileLoading.value = false;
    }
  }

  Future<void> updateCarProfileData({
    // required String driverId,
    required String carBrand,
    required String carName,
    required String carRcFrontImage,
    // required String carRcBackImage,
    required String fuelType,
    required String carNo,
    required String seat,
    required String expiryDate,
    required String insuranceImage,
    required String carImage,
  }) async {
    try {
      profileLoading.value = true;
      final bool? updateSuccess = await service.updateCarDetails(
        // driverId: driverId,
          carBrand: carBrand,
          carName: carName,
          carRcFrontImage: carRcFrontImage,
          // carRcBackImage: carRcBackImage,
          fuelType: fuelType,
          carNo: carNo,
          seat: seat,
          expiryDate: expiryDate,
          insuranceImage: insuranceImage,
          carImage: carImage
      );

      if (updateSuccess == true) {
        await getProfileData();
        update();
        debugPrint('car details updated successfully');
      } else {
        debugPrint('Failed to update car details');
      }
    } catch (e) {
      debugPrint('Error updating car profile data: $e');
    } finally {
      profileLoading.value = false;
    }
  }
}