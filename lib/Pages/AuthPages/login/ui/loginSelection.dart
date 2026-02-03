import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../app/router/navigation/nav.dart';
import '../../../../app/router/navigation/routes.dart';
import '../../register/ui/newRegister.dart';

class LoginSelectionScreen extends StatefulWidget {
  const LoginSelectionScreen({super.key});

  @override
  State<LoginSelectionScreen> createState() => _LoginSelectionScreenState();
}

class _LoginSelectionScreenState extends State<LoginSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/loginSelection.png"),fit: BoxFit.fill)
        ),
        child:SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.62,),
              Text(
                'Welcome to Cabyatra',
                style: TextStyle(
                  color: const Color(0xFF3E4959),
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.40,
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      Nav.push(context,Routes.loginMobile);
                  //    Get.to(const OtpPage(phone: "324472734734",));
                    },
                    child: Container(
                      width: 150,
                      height: 38,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF3E4959),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 53,
                            top: 7,
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Nav.push(context,Routes.loginRegister);
                     // Get.to(const NewRegisterScreen());
                    },
                    child: Container(
                      width: 150,
                      height: 38,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFCB117),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 41,
                            top: 7,
                            child: Text(
                              'Register ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10,),
              SizedBox(
                width: 300,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'By signing up, you agree to our ',
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.90),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                      TextSpan(
                        text: 'Terms of Use',
                        style: TextStyle(
                          color: const Color(0xFF3E4959),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                      //    textDecoration: TextDecoration.underline,
                          height: 1.50,
                        ),
                      ),
                      TextSpan(
                        text: ' and ',
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.90),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: const Color(0xFF3E4959),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        //  textDecoration: TextDecoration.underline,
                          height: 1.50,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ) ,
      ),
    );
  }
}
