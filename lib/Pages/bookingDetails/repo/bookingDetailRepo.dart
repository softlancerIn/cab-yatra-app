// 1. Auth Repository
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../cores/constants/api_constants.dart';
import '../../../../cores/exceptions/app_exceptions.dart';
import '../../../../cores/network/api_service.dart';
import '../../../../cores/network/network_utils.dart';
import '../../../../cores/services/secure_storage_service.dart';
import '../model/bookingDetailModel.dart';




class BookingDetailRepo {
  final ApiService _api = ApiService();

  Future<BookingDetailModel> getBookingDetailApi({

    required BuildContext context,
    required String bookingId,
  }) async {
    try {
      final response = await _api.get(
        "${ApiConstants.bookingDetail}/$bookingId",

        requiresAuth: true,
      );
      debugPrint("📦 BookingDetail raw response keys: ${response is Map ? (response as Map).keys.toList() : 'not a map'}");
      if (response is Map && response['data'] is Map) {
        final d = response['data'] as Map;
        debugPrint("📦 BookingDetail data keys: ${d.keys.toList()}");
        debugPrint("📦 assign_driver_id=${d['assign_driver_id']}, user_id=${d['user_id']}, creator_id=${d['creator_id']}");
      }
      //   await SecureStorageService.saveToken(response['token']);
      return BookingDetailModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getBookingDetailApi( context: context,bookingId:bookingId),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getBookingDetailApi( context: context,bookingId:bookingId),
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

  Future<Map<String, dynamic>> getDriverReviews({
    required String driverId,
  }) async {
    try {
      final response = await _api.get(
        ApiConstants.reviews,
        queryParameters: {'driver_id': driverId},
        requiresAuth: true,
      );
      return response;
    } catch (e) {
      debugPrint("❌ Error fetching driver reviews: $e");
      return {};
    }
  }

}
