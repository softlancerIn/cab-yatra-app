import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../cores/constants/api_constants.dart';
import '../../../cores/network/api_service.dart';
import '../model/chat_drivers_response_model.dart';
import '../model/messageModel.dart';

class ChatRepo {
  final ApiService _apiService = ApiService();

  Future<ChatDriversResponseModel> getAllChatDrivers({
    required BuildContext context,
    required String type, // 0 posted, 1 received
  }) async {
    try {
      final response = await _apiService.get(
        "${ApiConstants.allChatDrivers}?type=$type&is_approve=1",
      );
      return ChatDriversResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<ChatDriversResponseModel> getChatHistoryForBooking({
    required BuildContext context,
    required String bookingId,
  }) async {
    try {
      final response = await _apiService.get(
        "${ApiConstants.allChatUsers}/$bookingId",
      );
      // The API response might have 'users' and 'drivers'
      // We'll wrap them into the existing model
      return ChatDriversResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getChatMessages({
    required BuildContext context,
    required String bookingId,
    required String driverId,
  }) async {
    try {
      final response = await _apiService.get(
        "${ApiConstants.chatMessages}/$bookingId?driver_id=$driverId",
      );
      
      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }
      return {};
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> sendNewMessage({
    required BuildContext context,
    required String bookingId,
    required String receiverId,
    required String message,
    String? socketId,
    required int type,
    Map<String, dynamic>? metaData,
  }) async {
    try {
      final formData = FormData.fromMap({
        'booking_id': bookingId,
        'receiver_id': receiverId,
        'message': message,
        'type': type.toString(),
        // API expects meta_data as a JSON string, or empty string if none
        'meta_data': metaData != null ? jsonEncode(metaData) : '',
      });

      final response = await _apiService.post(
        ApiConstants.sendMessage,
        data: formData,
        options: socketId != null ? Options(headers: {'X-Socket-Id': socketId}) : null,
      );
      return response as Map<String, dynamic>?;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> authorizeChannel({
    required String channelName,
    required String socketId,
    required String token,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.authEndpoint,
        data: {
          'socket_id': socketId,
          'channel_name': channelName,
        },
      );
      // Pusher expect a JSON response with 'auth' and optionally 'channel_data'
      return response as Map<String, dynamic>?;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateBookingStatus({
    required BuildContext context,
    required String bookingId,
    required String status,
  }) async {
    try {
      final response = await _apiService.put(
        "${ApiConstants.booking}/$bookingId",
        data: {"status": status},
      );
      return (response['status'] == true || response['status'] == 1);
    } catch (e) {
      rethrow;
    }
  }

  /// Creates a Razorpay order and returns the full response map.
  /// The [amount] should be in rupees (e.g. 500 for ₹500).
  /// The API accepts rupees and returns `amount` in paise in the response.
  Future<Map<String, dynamic>?> createRazorpayOrder({
    required num amount,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.razorpayCreateOrder,
        data: {'amount': amount.toInt()}, // send rupees directly
      );
      return response as Map<String, dynamic>?;
    } catch (e) {
      rethrow;
    }
  }

  /// Verifies a Razorpay payment using multipart form-data.
  /// [amount] should be in rupees (e.g. 500 for ₹500).
  Future<Map<String, dynamic>?> verifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
    required num amount,
    required String bookingId, // ✅ newly required
  }) async {
    try {
      final formData = FormData.fromMap({
        "razorpay_order_id": orderId,
        "razorpay_payment_id": paymentId,
        "razorpay_signature": signature,
        "amount": amount.toInt().toString(),
        "booking_id": bookingId,
      });

      final response = await _apiService.post(
        ApiConstants.razorpayVerifyPayment,
        data: formData,
      );
      return response as Map<String, dynamic>?;
    } catch (e) {
      rethrow;
    }
  }

  /// Submits a star rating and optional review comment for a completed booking.
  /// [bookingId] – the booking being rated
  /// [rating]    – 1 to 5 stars
  /// [review]    – optional text comment
  Future<Map<String, dynamic>?> submitRating({
    required String bookingId,
    required int rating,
    String review = '',
  }) async {
    try {
      final formData = FormData.fromMap({
        'booking_id': bookingId,
        'rating': rating.toString(),
        'review': review,
      });
      final response = await _apiService.post(
        ApiConstants.submitRating,
        data: formData,
      );
      return response as Map<String, dynamic>?;
    } catch (e) {
      rethrow;
    }
  }
}
