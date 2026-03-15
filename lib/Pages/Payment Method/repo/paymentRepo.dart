import 'dart:io';

import '../../../cores/constants/api_constants.dart';
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
      ApiConstants.paymentMethods,
      fields: fields,
      files: files,
      requiresAuth: true,
    );

    return CreatePaymentModel.fromJson(response);
  }

  /// GET DRIVER LIST
  Future<GetPaymentModel> getPaymentApi() async {
    final response = await _api.get(
      ApiConstants.paymentMethods,
      requiresAuth: true,
    );

    return GetPaymentModel.fromJson(response);
  }
}
