import 'dart:developer';
import 'package:flutter/cupertino.dart';

import '../models/add_driver_model.dart';
import '../models/cancel_active_booking.dart';
import '../models/cmsPages_model.dart';
import '../models/dirver_payment_method.dart';
import '../models/driverData_model.dart';
import '../models/dropdown_models.dart';
import '../models/create_order_model.dart';
import '../models/home_model.dart';
import '../models/my_booking_model.dart';
import '../models/post_booking_model.dart';
import '../models/pickup_booking_model.dart';
import '../models/profile_model.dart';
import '../models/send_otp_model.dart';
import '../models/update_booking_model.dart';
import '../models/verify_otp_model.dart';
import '../models/wallet_model.dart';
import 'api_client.dart';

class NetworkService {
  ///send Otp for mobile verification
  Future<OtpSendModel?> sendOtpUser({required String mobile}) async {
    final data = {
      'mobile': mobile,
    };
    final response = await DioClient.post('/send-otp', data: data);
    print('response: ${response!.data}');
    print('responseStatusCode: ${response.statusCode}');
    if (response != null) {
      return OtpSendModel.fromJson(response.data);
    } else {
      print('Failed to create user');
    }
  }

  Future<HomePageModel?> getHomeData() async {
    final data = {};
    final response = await DioClient.post('/home', data: data);
    log('response home data: ${response!.data}');
    print('responseStatusCode: ${response.statusCode}');
    if (response != null) {
      return HomePageModel.fromJson(response.data);
    } else {
      print('Failed to get HomeData');
    }
  }

  Future<BookingResponse?> getMybookingData() async {
    final response = await DioClient.get('/my_booking');
    log('API response home data: ${response!.data}');
    print('API responseStatusCode: ${response.statusCode}');
    if (response != null) {
      return BookingResponse.fromJson(response.data);
    } else {
      print('Failed to get HomeData');
    }
  }

  Future<WalletResponse?> getWalletData() async {
    final response = await DioClient.get('/wallet');
    print('response: ${response!.data}');
    print('responseStatusCode: ${response.statusCode}');

    if (response != null) {
      return WalletResponse.fromJson(response.data);
    } else {
      print('Failed to get wallet data');
      return null;
    }
  }

  Future<DriverProfile?> getProfileData() async {
    final response = await DioClient.get('/profile');
    print('profile response: ${response!.data}');
    print('responseStatusCode: ${response.statusCode}');

    if (response != null) {
      return DriverProfile.fromJson(response.data);
    } else {
      print('Failed to get DriverProfile data');
      return null;
    }
  }
  Future<DriverPaymentMethod?> getPayementMethodData() async {
    final response = await DioClient.get('/driverPaymentMethod');
    print('response: ${response!.data}');
    print('responseStatusCode: ${response.statusCode}');

    if (response != null) {
      return DriverPaymentMethod.fromJson(response.data);
    } else {
      print('Failed to get paymentMethod data');
      return null;
    }
  }
  Future<dynamic> getReviewList() async {
    final response = await DioClient.get('/ratin_driverReviewList');

    if (response != null && response.statusCode == 200) {
      print('response: ${response.data}');
      return response.data;
    } else {
      print('Failed to getReviewList data');
      return null;
    }
  }


  Future<CmsPageModel?> getCmsPage() async {
    try {
      final response = await DioClient.get('/cmsPages');
      if (response != null) {
        return CmsPageModel.fromJson(response.data);
      } else {
        print('Failed to get CMS page data');
        return null;
      }
    } catch (e) {
      print('Error fetching CMS page data: $e');
      return null;
    }
  }

  Future<OtpVerifyModel?> verifyOtpUser(
      {required String mobile, required String otp}) async {
    final data = {
      'mobile': mobile,
      'otp': otp,
    };
    final response = await DioClient.post('/login', data: data);
    print('response: ${response!.data}');
    print('responseStatusCode: ${response.statusCode}');
    if (response != null) {
      return OtpVerifyModel.fromJson(response.data);
    } else {
      print('Failed to create user');
    }
  }

  Future<Map<String, dynamic>?> verifyStartRideOtp({
    required String bookingId,
    String? otp,
  }) async {
    final data = {
      'booking_id': bookingId,
      'otp': otp,
    };

    try {
      final response = await DioClient.post('/verifyStartRideOtp', data: data);

      if (response != null) {
        final responseData = response.data;
        print('Response: $responseData');
        if (responseData != null &&
            responseData['status'] != null &&
            responseData['message'] != null) {
          return {
            'status': responseData['status'],
            'message': responseData['message'],
          };
        } else {
          print('Invalid response format');
          return null;
        }
      } else {
        print('No response from the server');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> endRide({
    required String bookingId,
  }) async {
    final data = {
      'booking_id': bookingId,
    };

    try {
      final response = await DioClient.post('/rideEnd', data: data);

      if (response != null) {
        final responseData = response.data;
        print('Response: $responseData');
        if (responseData != null &&
            responseData['status'] != null &&
            responseData['message'] != null) {
          return {
            'status': responseData['status'],
            'message': responseData['message'],
            'name': responseData['name'] ?? 'N/A',
          };
        } else {
          print('Invalid response format');
          return null;
        }
      } else {
        print('No response from the server');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> sendReview({
    required String bookingId,
    required int rating,
    required int driver_Id,
    required List<String> checkBoxReview,
    required String textReview,
  }) async {
    final data = {
      'booking_id': bookingId,
      'rating': rating,
      'checkBox_review': checkBoxReview.join(', '),
      'text_review': textReview,
      'driver_id': driver_Id,
    };

    try {
      final response = await DioClient.post('/bookingRatignReview', data: data);

      if (response != null) {
        final responseData = response.data;
        print('Response: $responseData');
        if (responseData != null &&
            responseData['status'] != null &&
            responseData['message'] != null) {
          return {
            'status': responseData['status'],
            'message': responseData['message'],
          };
        } else {
          print('Invalid response format');
          return null;
        }
      } else {
        print('No response from the server');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<DriverPaymentMethod?> postPaymentMethod(PayMethodData paymentData) async {
    final data = paymentData.toJson(); // Convert the Data object to JSON
    final response = await DioClient.post('/driverPaymentMethod', data: data);

    if (response != null) {
      return DriverPaymentMethod.fromJson(response.data);
    } else {
      print('Failed to post payment method');
      return null;
    }
  }

  Future<DriverDataModel?> getDriverDataForRatingReview({required String bookingId}) async {
    try {
      final response = await DioClient.get('/getDriverDataForRatingReview/$bookingId');

      if (response != null && response.data['status'] == true) {
        return DriverDataModel.fromJson(response.data['data']);
      } else {
        print('Failed to get driver data for rating review');
        return null;
      }
    } catch (e) {
      print('Error fetching driver data for rating review: $e');
      return null;
    }
  }

  Future<List<CarModel>?> getCarList() async {
    final response = await DioClient.get('/get-car-category');
    if (response != null) {
      final apiResponse = DioClient.handleApiResponse(response);
      if (apiResponse.status) {
        if (apiResponse.data is List) {
          List<CarModel> carList = (apiResponse.data as List)
              .map((car) => CarModel.fromJson(car))
              .toList();
          return carList;
        } else {
          print(
              'Error: Expected a list but got ${apiResponse.data.runtimeType}');
          return null;
        }
      } else {
        debugPrint('Error: ${apiResponse.message}');
        debugPrint('Errors: ${apiResponse.errors}');
        return null;
      }
    } else {
      print('Failed to get car list');
      return null;
    }
  }

  Future<List<TimeZone>?> getLocalTime() async {
    final response = await DioClient.get('/getLocalTime');
    if (response != null) {
      print("response");
      print(response);
      final apiResponse = DioClient.handleApiResponse(response);
      if (apiResponse.status) {
        if (apiResponse.data is List) {
          print(apiResponse.data);
          List<TimeZone> timeList = (apiResponse.data as List)
              .map((time) => TimeZone.fromJson(time))
              .toList();
          return timeList;
        } else {
          print(
              'Error: Expected a timeList but got ${apiResponse.data.runtimeType}');
          return null;
        }
      } else {
        debugPrint('Error: ${apiResponse.message}');
        debugPrint('Errors: ${apiResponse.errors}');
        return null;
      }
    } else {
      print('Failed to get timeList');
      return null;
    }
  }

  Future<bool?> checkBankInfo() async {
    final response = await DioClient.get('/checkBankInfo');
    if (response != null) {
      print("response");
      print(response);
      final apiResponse = DioClient.handleApiResponse(response);
      if (apiResponse.data != null && apiResponse.data.isNotEmpty) {
        print(apiResponse.data);
        return true;
      } else {
        print(apiResponse.message);
        return false;
      }
    } else {
      print('Failed to get bank info');
      return false;
    }
  }


  Future<ApiResponse?> postTripData(AddBookingModel tripData) async {
    final data = tripData.toJson();
    final response = await DioClient.post('/add_booking', data: data);

    if (response != null) {
      final apiResponse = DioClient.handleApiResponse(response);
      return apiResponse;
    } else {
      print('Failed to post trip data');
      return null;
    }
  }

  Future<ApiResponse?> updateTripData(AddBookingModel tripData, int Id) async {
    final data = tripData.toJson();
    final response = await DioClient.post('/update_booking/$Id', data: data);

    if (response != null) {
      final apiResponse = DioClient.handleApiResponse(response);
      return apiResponse;
    } else {
      print('Failed to update trip data');
      return null;
    }
  }

  Future<ApiResponse?> deleteTripData(var bookingId) async {
    final data = {'booking_id': bookingId};
    final response = await DioClient.post('/deleteDriverBooking', data: data);

    if (response != null) {
      final apiResponse = DioClient.handleApiResponse(response);
      return apiResponse;
    } else {
      print('Failed to Delete trip data');
      return null;
    }
  }

  Future<OrderCreateModel?> createOrder({
    required String amount,
  }) async {
    final data = {
      'amount': amount,
    };
    final response =
        await DioClient.post('/crete_razorpay_oder_id', data: data);
    print('response: ${response!.data}');
    print('responseStatusCode: ${response.statusCode}');
    return OrderCreateModel.fromJson(response.data);
  }

  Future<UpdateBookingModel?> updateBookingOrder({
    required String bookingId,
    required String orderId,
  }) async {
    final data = {
      'booking_id': bookingId,
      'razorpyayOrderId': orderId,
    };
    final response = await DioClient.post('/update_booking_status', data: data);
    print('response: ${response!.data}');
    print('responseStatusCode: ${response.statusCode}');
    return UpdateBookingModel.fromJson(response.data);
  }

  Future<CancelBookingModel?> cancelBookingOrder({
    required String bookingId,
  }) async {
    final data = {
      'booking_id': bookingId,
    };
    final response = await DioClient.post('/cancelBooking', data: data);
    print('response: ${response!.data}');
    print('responseStatusCode: ${response.statusCode}');
    return CancelBookingModel.fromJson(response.data);
  }

  Future<PickUpBookingModel?> pickUpBookingOrder({
    required var bookingId,
  }) async {
    final data = {
      'booking_id': bookingId,
    };
    final response = await DioClient.post('/sendStartRideOtp', data: data);
    print('response: ${response!.data}');
    print('responseStatusCoderer: ${response.statusCode}');
    return PickUpBookingModel.fromJson(response.data);
  }

  Future<void> uploadQR({
    required String qrImagePath, required PayMethodData paymentData
  }) async {
    const String uploadUrl = '/driverPaymentMethod';

    final Map<String, String> fileKeyPathMap = {
      'qr_image': qrImagePath,
    };


    void onProgress(int sent, int total) {
      final progress = (sent / total * 100).toStringAsFixed(2);
      print('Upload Progress: $progress%');
    }

    try {
      final response = await DioClient.uploadFilesWithKeysAndProgress(
        uploadUrl,
        data: paymentData.toJson(),
        fileKeyPathMap: fileKeyPathMap,
        onSendProgress: onProgress,
      );

      final apiResponse = DioClient.handleApiResponse(response);
      if (apiResponse.status) {
        debugPrint('QR Image uploaded successfully: ${apiResponse.message}');
      } else {
        debugPrint('Error uploading QR image: ${apiResponse.message}');
      }
    } catch (e) {
      debugPrint('Error uploading QR image: $e');
    }
  }


  Future<AddDriverModel?> uploadDriverDetails({
    // required String profileType,
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
    const String uploadUrl = '/registration';

    final Map<String, String> fileKeyPathMap = {
      'driver_image': driverPhoto,
      'aadhar_frontImage': aadhaarFrontImage,
      'aadhar_backImage': aadhaarBackImage,
      'dl_image': dlImage,
    };

    final Map<String, dynamic> additionalData = {
      'name': name,
      'type': 'driver_details',
      /*profileType,*/
      'email': email,
      'phone': phone,
      'pan_no': pan,
      'aadhar_no': aadhaarNo,
      'dl_no': dlNo,
    };

    void onProgress(int sent, int total) {
      final progress = (sent / total * 100).toStringAsFixed(2);
      // print('Upload Progress: $progress%');
    }

    final response = await DioClient.uploadFilesWithKeysAndProgress(
      uploadUrl,
      fileKeyPathMap: fileKeyPathMap,
      data: additionalData,
      onSendProgress: onProgress,
    );

    // Handle response
    final apiResponse = DioClient.handleApiResponse(response);
    if (apiResponse.status) {
      debugPrint('Success: ${apiResponse.message}');
      return AddDriverModel.fromJson(apiResponse.data);
    } else {
      debugPrint('Error: ${apiResponse.message}');
      debugPrint('Errors: ${apiResponse.errors}');
      return AddDriverModel.fromJson(apiResponse.data);
      return null;
    }

    ///till here

    // Handle the response
    // if (response != null &&
    //     (response.statusCode == 200 || response.statusCode == 400)) {
    //   print('Files uploaded successfully: ${response.data}');
    //   return AddDriverModel.fromJson(response.data);
    // } else {
    //   print('Failed to upload files. ${response!.data}');
    // }
  }

  Future<AddDriverModel?> uploadCarDetails({
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
    const String uploadUrl = '/registration';

    final Map<String, String> fileKeyPathMap = {
      'car_image': carImage,
      'car_rc_frontImage': carRcFrontImage,
      'car_rc_backImage': carRcBackImage,
      'insurence_image': insuranceImage,
    };

    final Map<String, dynamic> additionalData = {
      'driver_id': driverId,
      'type': 'car_details',
      'car_brand': carBrand,
      'car_name': carName,
      'car_no': carNo,
      'fuel_type': fuelType,
      'no_seat': seat,
      'insurence_expiry': expiryDate,
    };

    void onProgress(int sent, int total) {
      final progress = (sent / total * 100).toStringAsFixed(2);
      // print('Upload Progress: $progress%');
    }

    final response = await DioClient.uploadFilesWithKeysAndProgress(
      uploadUrl,
      fileKeyPathMap: fileKeyPathMap,
      data: additionalData,
      onSendProgress: onProgress,
    );

    // Handle the response
    if (response != null &&
        (response.statusCode == 200 || response.statusCode == 400)) {
      print('Files uploaded successfully: ${response.data}');
      return AddDriverModel.fromJson(response.data);
    } else {
      print('Failed to upload files. ${response!.data}');
    }
  }

  Future<bool?> updateDriverDetails({
    required String name,
    required String email,
    required String phone,
    required String aadhaarNo,
    required String pan,
    required String dlNo,
    String? driverPhoto,
  }) async {
    const String uploadUrl = '/profile';

    final Map<String, String> fileKeyPathMap = {};
    if (driverPhoto != null) fileKeyPathMap['driver_image'] = driverPhoto;
    final Map<String, dynamic> additionalData = {
      'name': name,
      'email': email,
      'phone': phone,
      'pan_no': pan,
      'aadhar_no': aadhaarNo,
      'dl_no': dlNo,
      'type': 'driver_detail',
    };

    void onProgress(int sent, int total) {
      final progress = (sent / total * 100).toStringAsFixed(2);
      debugPrint('Update Progress: $progress%');
    }

    try {
      final response = await DioClient.uploadFilesWithKeysAndProgress(
        uploadUrl,
        fileKeyPathMap: fileKeyPathMap,
        data: additionalData,
        onSendProgress: onProgress,
      );

      final apiResponse = DioClient.handleApiResponse(response);
      print(response);
      print('gsfjfjaf');
      if (apiResponse.status) {
        debugPrint('Driver details updated: ${apiResponse.message}');
        // return AddDriverModel.fromJson(apiResponse.data);
        return true;
      } else {
        debugPrint('Error updating driver details: ${apiResponse.message}');
        debugPrint('Errors: ${apiResponse.errors}');
        return false;
      }
    } catch (e) {
      debugPrint('Exception while updating driver details: $e');
      return false;
    }
  }

  Future<bool> updateCarDetails({
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
    const String uploadUrl = '/profile';

    final Map<String, String> fileKeyPathMap = {};
    if (carImage != null) fileKeyPathMap['car_image'] = carImage;
    if (carRcFrontImage != null) fileKeyPathMap['car_rc_frontImage'] = carRcFrontImage;
    if (insuranceImage != null) fileKeyPathMap['insurence_image'] = insuranceImage;

    final Map<String, dynamic> additionalData = {
      'type': 'car_details',
      'car_brand': carBrand,
      'car_name': carName,
      'car_no': carNo,
      'fuel_type': fuelType,
      'insurence_expiry': expiryDate,
      'no_seat': seat,
    };

    void onProgress(int sent, int total) {
      final progress = (sent / total * 100).toStringAsFixed(2);
      debugPrint('Update Progress: $progress%');
    }

    try {
      final response = await DioClient.uploadFilesWithKeysAndProgress(
        uploadUrl,
        fileKeyPathMap: fileKeyPathMap,
        data: additionalData,
        onSendProgress: onProgress,
      );

      final apiResponse = DioClient.handleApiResponse(response);
      if (apiResponse.status) {
        debugPrint('Car details updated: ${apiResponse.message}');
        return true;
      } else {
        debugPrint('Error updating Car details: ${apiResponse.message}');
        debugPrint('Errors: ${apiResponse.errors}');
        return false;
      }
    } catch (e) {
      debugPrint('Exception while updating driver details: $e');
      return false;
    }
  }
}
