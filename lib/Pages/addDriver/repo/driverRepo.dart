import 'dart:io';

import '../../../cores/network/api_service.dart';
import '../model/addDriverModel.dart';
import '../model/driverListModel.dart';

class DriverRepo {
  final ApiService _api = ApiService();

  /// ADD DRIVER (MULTIPART)
  Future<AddDriverResponse> addDriver({
    required Map<String, dynamic> fields,
    required Map<String, File> files,
  }) async {
    final response = await _api.uploadFiles(
      "api/driver/V2/profile/sub-drivers",
      fields: fields,
      files: files,
      requiresAuth: true,
    );

    return AddDriverResponse.fromJson(response);
  }

  /// GET DRIVER LIST
  Future<DriverListModel> getDrivers() async {
    final response = await _api.get(
      "api/driver/V2/profile/sub-drivers",
      requiresAuth: true,
    );

    return DriverListModel.fromJson(response);
  }
}
