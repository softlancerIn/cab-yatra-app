import 'dart:io';
import 'package:flutter/material.dart';
import '../../../cores/network/api_service.dart';
import '../../../cores/constants/api_constants.dart';
import '../model/vehicle_model.dart';
import '../../editBooking/model/edit_car_category_model.dart';

class VehicleRepo {
  final ApiService _api = ApiService();

  /// GET CAR CATEGORY
  Future<EditCarCategoryModel> getCarCategory({
    required BuildContext context,
  }) async {
    final response = await _api.get(
      ApiConstants.getCarCategory,
      requiresAuth: true,
    );
    return EditCarCategoryModel.fromJson(response);
  }

  /// GET VEHICLE LIST
  Future<VehicleListModel> getVehicles() async {
    final response = await _api.get(
      ApiConstants.vehicles,
      requiresAuth: true,
    );
    return VehicleListModel.fromJson(response);
  }

  /// GET VEHICLE BY ID
  Future<Map<String, dynamic>> getVehicleById(int id) async {
    final response = await _api.get(
      "${ApiConstants.vehicles}/$id",
      requiresAuth: true,
    );
    return response;
  }

  /// DELETE VEHICLE
  Future<bool> deleteVehicle(int id) async {
    final response = await _api.delete(
      "${ApiConstants.vehicles}/$id",
      requiresAuth: true,
    );
    return response['status'] == true;
  }

  /// ADD VEHICLE
  Future<bool> addVehicle({
    required Map<String, dynamic> fields,
    required Map<String, File> files,
  }) async {
    final response = await _api.uploadFiles(
      ApiConstants.vehicles,
      fields: fields,
      files: files,
      requiresAuth: true,
    );

    if (response != null && response['status'] == true) {
      return true;
    }

    return false;
  }

  /// UPDATE VEHICLE (PUT)
  Future<bool> updateVehicle({
    required int id,
    required Map<String, dynamic> fields,
    required Map<String, File> files,
  }) async {
    final response = await _api.uploadFiles(
      "${ApiConstants.vehicles}/$id",
      fields: fields,
      files: files,
      requiresAuth: true,
      method: "POST",
    );

    if (response != null && response['status'] == true) {
      return true;
    }

    return false;
  }
}
