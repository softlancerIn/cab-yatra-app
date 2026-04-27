import 'dart:io';
import '../../../cores/constants/api_constants.dart';
import '../../../cores/network/api_service.dart';
import '../model/addDriverModel.dart';
import '../model/driverListModel.dart';
import '../../manage_vehicles/model/vehicle_model.dart';

class DriverRepo {
  final ApiService _api = ApiService();

  /// ADD DRIVER (MULTIPART)
  Future<AddDriverResponse> addDriver({
    required Map<String, dynamic> fields,
    required Map<String, File> files,
  }) async {
    final response = await _api.uploadFiles(
      ApiConstants.subDrivers,
      fields: fields,
      files: files,
      requiresAuth: true,
    );

    return AddDriverResponse.fromJson(response);
  }

  /// UPDATE DRIVER (POST)
  Future<AddDriverResponse> updateDriver({
    required int id,
    required Map<String, dynamic> fields,
    required Map<String, File> files,
  }) async {
    final response = await _api.uploadFiles(
      "${ApiConstants.subDrivers}/$id",
      fields: fields,
      files: files,
      requiresAuth: true,
      method: "POST",
    );

    return AddDriverResponse.fromJson(response);
  }

  /// GET DRIVER LIST
  Future<DriverListModel> getDrivers({int? isApprove}) async {
    final response = await _api.get(
      ApiConstants.subDrivers,
      queryParameters: isApprove != null ? {'is_approve': isApprove} : null,
      requiresAuth: true,
    );

    return DriverListModel.fromJson(response);
  }

  /// GET DRIVER BY ID
  Future<Map<String, dynamic>> getDriverById(int id) async {
    final response = await _api.get(
      "${ApiConstants.subDrivers}/$id",
      requiresAuth: true,
    );
    return response;
  }

  /// DELETE DRIVER
  Future<bool> deleteDriver(int id) async {
    final response = await _api.delete(
      "${ApiConstants.subDrivers}/$id",
      requiresAuth: true,
    );
    return response['status'] == true;
  }

  /// GET VEHICLE LIST
  Future<VehicleListModel> getVehicles({int? isApprove}) async {
    final response = await _api.get(
      ApiConstants.vehicles,
      queryParameters: isApprove != null ? {'is_approve': isApprove} : null,
      requiresAuth: true,
    );
    return VehicleListModel.fromJson(response);
  }
}
