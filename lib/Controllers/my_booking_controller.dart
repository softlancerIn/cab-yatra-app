import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../Pages/HomePageFlow/home_controller.dart';
import '../core/api_client.dart';
import '../core/network_service.dart';
import '../models/my_booking_model.dart';
import '../models/post_booking_model.dart';


class MyBookingController extends GetxController {
  NetworkService service = NetworkService();
  var myBookingData = BookingResponse().obs;
  var myBookingLoading = false.obs;

  BookingResponse? bookingResponse;

  @override
  void onInit() {
    super.onInit();
    getMyBookingData();
    print('bookingggg data');
  }

  Future<void> getMyBookingData() async {
    try {
      myBookingLoading.value = true;
      final response = await service.getMybookingData();

      if (response != null) {
        if (response.status == true) {
          myBookingData.value = response;
          update();
        } else {}
      } else {
        if (kDebugMode) {
          print('Controller Failed to My Booking data');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Controller Error get My Booking Data: $e');
      }
    } finally {
      myBookingLoading.value = false;
    }
  }

  Future<void> deleteBooking({required var bookingId}) async {
    try {
      myBookingLoading.value = true;
      final response = await service.deleteTripData(bookingId);

      if (response != null) {
        if (response.status == true) {
          getMyBookingData();
          update();
          Get.back();
        } else {
          if (kDebugMode) {
            print('Failed to delete booking: ${response.message}');
          }
        }
      } else {
        if (kDebugMode) {
          print('Failed to get My booking data');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting My booking Data: $e');
      }
    } finally {
      myBookingLoading.value = false;
    }
  }

  Future<ApiResponse?> updateBooking({required AddBookingModel tripData, required int bookingId}) async {
    try {
      myBookingLoading.value = true;
      final response = await service.updateTripData(tripData, bookingId);

      if (response != null) {
        if (response.status == true) {
          getMyBookingData();
          update();
          Get.back();
        } else {
          if (kDebugMode) {
            print('Failed to update booking: ${response.message}');
          }
        }
        return response; // Return the response
      } else {
        if (kDebugMode) {
          print('Failed to get My booking data');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating My booking Data: $e');
      }
    } finally {
      myBookingLoading.value = false;
    }
    return null;
  }

  Future<ApiResponse?> postBooking({required AddBookingModel tripData}) async {
    try {
      myBookingLoading.value = true;
      final response = await service.postTripData(tripData);

      if (response != null && response.status == true) {
        await getMyBookingData();
        update();
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('Error postBooking: $e');
    } finally {
      myBookingLoading.value = false;
    }
    return null;
  }
}