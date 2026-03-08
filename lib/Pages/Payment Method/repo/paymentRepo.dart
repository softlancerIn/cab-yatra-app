import 'dart:io';

import '../../../cores/network/api_service.dart';

import '../model/createPaymentModel.dart';
import '../model/getPaymentModel.dart';


class PaymentRepo {
  final ApiService _api = ApiService();

  /// ADD DRIVER (MULTIPART)
  Future<CreatePaymentModel> addPaymentApi({
    required Map<String, dynamic> fields,
    required Map<String, File> files,
  }) async {
    final response = await _api.uploadFiles(
      "https://cabyatra.com/api/driver/V2/profile/payment-methods",
      fields: fields,
      files: files,
      requiresAuth: true,
    );

    return CreatePaymentModel.fromJson(response);
  }

  /// GET DRIVER LIST
  Future<GetPaymentModel> getPaymentApi() async {
    final response = await _api.get(
      "https://cabyatra.com/api/driver/V2/profile/payment-methods",
      requiresAuth: true,
    );

    return GetPaymentModel.fromJson(response);
  }
}
