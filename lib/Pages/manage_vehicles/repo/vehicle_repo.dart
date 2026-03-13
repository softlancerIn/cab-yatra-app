import 'dart:io';
import '../../../cores/network/api_service.dart';
import '../model/vehicle_model.dart';

class VehicleRepo {
  final ApiService _api = ApiService();

  /// GET VEHICLE LIST
  Future<VehicleListModel> getVehicles() async {
    final response = await _api.get(
      "api/driver/V2/profile/vehicles", // Assuming this is the endpoint
      requiresAuth: true,
    );
    return VehicleListModel.fromJson(response);
  }

  /// DELETE VEHICLE
  Future<bool> deleteVehicle(int id) async {
    final response = await _api.delete(
      "api/driver/V2/profile/vehicles/$id",
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
      "api/driver/V2/profile/vehicles",
      fields: fields,
      files: files,
      requiresAuth: true,
    );
    return response['status'] == true;
  }
}
