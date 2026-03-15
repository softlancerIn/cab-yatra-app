
import 'package:flutter/material.dart';

import '../../../../app/router/navigation/nav.dart';
import '../../../../app/router/navigation/routes.dart';

import '../../../cores/services/secure_storage_service.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () async {
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.getString('auth_token');
      final userToken = await SecureStorageService.getToken();
   //   String? userToken = prefs.getString('auth_token');

      print('token============>$userToken');
      if (userToken == null || userToken == "") {
        Nav.go(context,Routes.login);
        //  Get.off(const LoginSelectionScreen());
        // Get.off(const OtpPage());
      } else {
        Nav.go(
          context,
          Routes.home,

        );
       // Get.off(const MainHomeController());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/images/spalshSCreen.png",
          height: screenHeight,
          width: screenWidth,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}