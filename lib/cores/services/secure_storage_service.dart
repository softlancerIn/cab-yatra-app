
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../app/router/navigation/nav.dart';
import '../../app/router/navigation/routes.dart';
import '../constants/api_constants.dart';
import 'package:flutter/material.dart';





class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  /// TOKEN
  static Future<void> saveToken(String token) async {
    await _storage.write(key: ApiConstants.tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: ApiConstants.tokenKey);
  }

  /// IS AGENT
  static Future<void> saveIsAgent(bool value) async {
    await _storage.write(
      key: ApiConstants.isAgentKey,
      value: value.toString(), // true / false
    );
  }

  static Future<bool> getIsAgent() async {
    final value = await _storage.read(key: ApiConstants.isAgentKey);
    return value == 'true';
  }

  /// IS USER
  // static Future<void> saveIsUser(bool value) async {
  //   await _storage.write(
  //     key: ApiConstants.isUserKey,
  //     value: value.toString(),
  //   );
  // }

  // static Future<bool> getIsUser() async {
  //   //final value = await _storage.read(key: ApiConstants.isUserKey);
  //   //return value == 'true';
  // }

  /// LOGOUT
  static Future<void> logout(BuildContext context) async {
    await _storage.deleteAll(); // token + flags clear
    Nav.go(context,Routes.login);
    // Navigator.pushNamedAndRemoveUntil(
    //   context,
    //   Routes.login,
    //       (route) => false,
    // );
  }
}
