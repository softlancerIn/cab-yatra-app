// import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/ui/homepage.dart';
import 'package:cab_taxi_app/models/pickup_booking_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/network_service.dart';
import '../models/cancel_active_booking.dart';
import '../models/create_order_model.dart';
import '../models/home_model.dart';

class HomeController extends GetxController {
  NetworkService service = NetworkService();

  var homeData = HomePageModel().obs;
  var orderCreateData = OrderCreateModel().obs;
  var cancelBookingModel = CancelBookingModel().obs;
  var pickUpBookingModel = PickUpBookingModel().obs;

  var bannerList = <Banners>[].obs;
  var message = ''.obs;
  var homeLoading = false.obs;
  var orderLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    getHomeData();
    print("gfazhjgHome data");
  }

  Future<void> getHomeData() async {
    try {
      homeLoading.value = true;
      final response = await service.getHomeData();

      if (response != null) {
        if (response.status == true) {
          homeData.value = response;
          bannerList.value = response.banners!;
          message.value = response.message!;
          final RegExp regex = RegExp(r'(\d+(\.\d+)?)');
          final match = regex.firstMatch(message.toString());
          final String numericPart = match != null ? match.group(0)! : '0.0';

          // Save numericPart to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              'numericPart', numericPart); // Use a key to store the value

          update();
        } else {}
      } else {
        if (kDebugMode) {
          print('Failed to get hone data');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error get Home Data: $e');
      }
    } finally {
      homeLoading.value = false;
    }
  }

  Future<void> cancelActiveBooking({required String bookingId}) async {
    try {
      homeLoading.value = true;
      final response = await service.cancelBookingOrder(bookingId: bookingId);

      if (response != null) {
        if (response.status == true) {
          cancelBookingModel.value = response;
          getHomeData();
          update();
          Get.back();
        } else {}
      } else {
        if (kDebugMode) {
          print('Failed to get hone data');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error get Home Data: $e');
      }
    } finally {
      homeLoading.value = false;
    }
  }

  Future<void> pickUpBookingOrder(
      {required var bookingId,
      Function(BuildContext, String)? onDialogShow,
      t}) async {
    try {
      print("11");
      homeLoading.value = true;
      print('ghfcakc');
      final response = await service.pickUpBookingOrder(bookingId: bookingId);
      print("22");
      if (response != null) {
        print("33");
        if (response.status == true) {
          pickUpBookingModel.value = response;
          if (onDialogShow != null) {
            onDialogShow(Get.context!, bookingId.toString());
          }
          getHomeData();
          update();
          // Get.back();
        } else {}
      } else {
        if (kDebugMode) {
          print('Failed to get hone data');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error get Home Data: $e');
      }
    } finally {
      homeLoading.value = false;
    }
  }

  Future<void> createOrder({required String amount}) async {
    try {
      orderLoading.value = true;
      final response = await service.createOrder(amount: amount);

      if (response != null) {
        if (response.status == true) {
          orderCreateData.value = response;
          getHomeData();
          update();
        } else {}
      } else {
        if (kDebugMode) {
          print('Failed to get hone data');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error get Home Data: $e');
      }
    } finally {
      orderLoading.value = false;
    }
  }

  Future<void> updateBookingOrder({
    required String bookingId,
    required String orderId,
  }) async {
    try {
      orderLoading.value = true;
      final response = await service.updateBookingOrder(
          bookingId: bookingId, orderId: orderId);

      if (response != null) {
        if (response.status == true) {
          Fluttertoast.showToast(msg: response.message.toString());
          update();
          // orderCreateData.value = response;
        } else {
          Fluttertoast.showToast(msg: response.message.toString());
        }
      } else {
        if (kDebugMode) {
          print('Failed to get hone data');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error get Home Data: $e');
      }
    } finally {
      orderLoading.value = false;
    }
  }
}
