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
        "${ApiConstants.allChatDrivers}?type=$type",
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

  Future<List<MessageListModel>> getChatMessages({
    required BuildContext context,
    required String bookingId,
  }) async {
    try {
      final response = await _apiService.get(
        "${ApiConstants.chatMessages}/$bookingId",
      );
      
      if (response is List) {
        return response.map((e) => MessageListModel.fromJson(e)).toList();
      } else if (response is Map && response['status'] == true && response['data'] != null) {
        return (response['data'] as List)
            .map((e) => MessageListModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> sendMessage({
    required BuildContext context,
    required String bookingId,
    required String receiverId,
    required String message,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.sendMessage,
        data: {
          'booking_id': bookingId,
          'receiver_id': receiverId,
          'message': message,
        },
      );
      return response['status'] == true;
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
}
