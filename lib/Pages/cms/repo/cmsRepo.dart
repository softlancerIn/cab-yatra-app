import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../cores/constants/api_constants.dart';
import '../../../../cores/network/api_service.dart';
import '../model/cmsModel.dart';

class CmsRepo {

  final ApiService _api = ApiService();

  Future<CmsModel> getCms({
    required BuildContext context,
  }) async {

    try {

      final response = await _api.get(
        ApiConstants.cmsPages,
        requiresAuth: true,
      );

      return CmsModel.fromJson(response);

    } on DioException catch (e) {

      throw Exception(e.message);

    } catch (e) {

      throw Exception(e.toString());

    }

  }

}