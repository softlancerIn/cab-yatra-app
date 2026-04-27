import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../app/router/navigation/nav.dart';
import '../../../../app/router/navigation/routes.dart';

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
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/loginSelection.png"),
                fit: BoxFit.fill)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.62,
              ),
              const Text(
                'Welcome to Cabyatra',
                style: TextStyle(
                  color: Color(0xFF3E4959),
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.40,
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Nav.push(context, Routes.loginMobile);
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3E4959),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
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
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Nav.push(context, Routes.loginRegister);
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCB117),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 320,
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                    ),
                    children: [
                      TextSpan(
                        text: 'By signing up, you agree to our ',
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.80),
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                      TextSpan(
                        text: 'Terms of Use',
                        recognizer: TapGestureRecognizer()..onTap = () => Nav.push(context, Routes.termsCondition),
                        style: const TextStyle(
                          color: Color(0xFF3E4959),
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          height: 1.50,
                        ),
                      ),
                      TextSpan(
                        text: ' and ',
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.80),
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        recognizer: TapGestureRecognizer()..onTap = () => Nav.push(context, Routes.privacyPolicy),
                        style: const TextStyle(
                          color: Color(0xFF3E4959),
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
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
        ),
      ),
    );
  }
}
