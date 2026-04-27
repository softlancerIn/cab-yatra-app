import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../app/router/navigation/nav.dart';
import '../../../../app/router/navigation/routes.dart';

import '../../../../widget/primary_button.dart';

import '../bloc/loginBloc.dart';
import '../bloc/loginEvent.dart';
import '../bloc/loginState.dart';

class LoginScreen extends StatefulWidget {
  final String phone;
  final bool isRegister;
  const LoginScreen({super.key, required this.phone, required this.isRegister});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SignInBloc>().add(const ResetSendOtpEvent());
  }

  String selectedCountryCode = '+91';
  String selectedCountryFlag = '🇮🇳';

  // final authController = Get.put(AuthController());

  final TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/loginBg.png"),
              fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocListener<SignInBloc, SignInState>(
          listener: (context, state) async {
            if (state.isSuccess) {
              if (state.isRegistered == true) {
                Nav.push(context, Routes.otp, extra: numberController.text);
              } else {
                Nav.push(context, Routes.newRegister,
                    extra: numberController.text);
              }
            }
            if (state.errorMessage != null) {
              if (state.errorMessage!.toLowerCase().contains("blocked")) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    title: const Text(
                      "Account Blocked",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    content: Text(
                      state.errorMessage!,
                      style: const TextStyle(fontSize: 14),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context
                              .read<SignInBloc>()
                              .add(const ResetSendOtpEvent());
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              } else {
                Fluttertoast.showToast(
                  msg: state.errorMessage!,
                  backgroundColor: state.hasError ? Colors.red : Colors.green,
                  textColor: Colors.white,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );

                if (state.hasError) {
                  context.read<SignInBloc>().add(const ResetSendOtpEvent());
                }
              }
            }
          },
          child:
              BlocBuilder<SignInBloc, SignInState>(builder: (context, state) {
            final bloc = context.read<SignInBloc>();
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Image.asset(
                    "assets/images/finalLogooo.png",
                    scale: 5,
                    //  width: screenWidth * 0.5,
                    fit: BoxFit.fitWidth,
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  const Text(
                    'Welcome to CabbyCabs',
                    style: TextStyle(
                      color: Color(0xFF3E4959),
                      fontSize: 22,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    softWrap: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.05,
                        ),
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1.0, color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Country Code Picker
                              GestureDetector(
                                onTap: () {
                                  showCountryPicker(
                                    context: context,
                                    showPhoneCode: true,
                                    onSelect: (Country country) {
                                      setState(() {
                                        selectedCountryCode =
                                            '+${country.phoneCode}';
                                        selectedCountryFlag = country.flagEmoji;
                                      });
                                    },
                                    countryListTheme: CountryListThemeData(
                                      borderRadius: BorderRadius.circular(15),
                                      inputDecoration: InputDecoration(
                                        hintText: 'Search country',
                                        prefixIcon: const Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "$selectedCountryFlag $selectedCountryCode",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const Icon(Icons.arrow_drop_down,
                                          color: Colors.black87),
                                    ],
                                  ),
                                ),
                              ),
                              // Vertical Divider removed for cleaner look
                              // Phone Number Input Field
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: TextField(
                                    keyboardType: TextInputType.phone,
                                    controller: numberController,
                                    maxLength: 10,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      counterText: '',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15),
                                      hintText: 'Enter your Mobile number',
                                      hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade400),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),

                        CommonAppButton(
                          text: "Verify OTP  >",
                          backgroundColor: const Color(0xFFFCB117),
                          borderRadius: 12,
                          height: 54,
                          isLoading: state.isLoading,
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  bloc.add(
                                    SendOtpEvent(
                                      mobileNumber:
                                          numberController.text.trim(),
                                      context: context,
                                    ),
                                  );
                                },
                        ),
                        // GestureDetector(
                        //   onTap: () async {
                        //     bool isConnectedToInternet = await DioClient().isConnected();
                        //     if (isConnectedToInternet) {
                        //       if (numberController.text.isEmpty) {
                        //         ScaffoldMessenger.of(context).showSnackBar(
                        //           SnackBar(content: Text('Please enter your number')),
                        //         );
                        //         // Get.snackbar('Required', 'Please enter your number');
                        //       } else if (numberController.text.length < 10) {
                        //         ScaffoldMessenger.of(context).showSnackBar(
                        //           SnackBar(
                        //               content:
                        //               Text('Please enter your correct number')),
                        //         );
                        //         // Get.snackbar('Required', 'Please enter your number');
                        //       } else {
                        //         authController.sendOtp(mobile: numberController.text);
                        //       }
                        //     } else {
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         SnackBar(content: Text('No internet connection')),
                        //       );
                        //     }
                        //   },
                        //   child: Container(
                        //     width: double.infinity,
                        //     height: 45,
                        //     decoration: ShapeDecoration(
                        //       color: Color(0xffFCB117),
                        //       shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(12)),
                        //     ),
                        //     child: Center(
                        //       child: Text(
                        //         'Get OTP',
                        //         style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 16,
                        //           fontFamily: 'Poppins',
                        //           fontWeight: FontWeight.w500,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Text.rich(
                          TextSpan(
                            style: const TextStyle(
                              fontSize: 13,
                              fontFamily: 'Poppins',
                            ),
                            children: [
                              TextSpan(
                                text: 'By signing up, you agree to our ',
                                style: TextStyle(
                                  color: Colors.black.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'Terms of Use',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () =>
                                      Nav.push(context, Routes.termsCondition),
                                style: const TextStyle(
                                  color: Color(0xFF3E4959),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(
                                text: ' and ',
                                style: TextStyle(
                                  color: Colors.black.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () =>
                                      Nav.push(context, Routes.privacyPolicy),
                                style: const TextStyle(
                                  color: Color(0xFF3E4959),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.16,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
