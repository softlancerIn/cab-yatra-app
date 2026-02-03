import 'dart:async';

import 'package:cab_taxi_app/Pages/Add%20Profile/add_profile.dart';
import 'package:cab_taxi_app/Pages/Booking/my_booking.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/ui/homepage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../../Controllers/auth_controller.dart';
import '../../../../app/router/navigation/nav.dart';
import '../../../../app/router/navigation/routes.dart';
import '../../../../core/network_service.dart';
import '../../../../widget/primary_button.dart';
import '../bloc/otpBloc.dart';
import '../bloc/otpEvent.dart';
import '../bloc/otpState.dart';

class VerifyOtpPage extends StatefulWidget {
  final String mobile;
  const VerifyOtpPage({super.key, required this.mobile});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  NetworkService service = NetworkService();



  int resentTime = 60;
  late Timer countdownTimer;

  startTimer() {
    if (resentTime > 0) {
      countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          resentTime = resentTime - 1;
        });
        if (resentTime < 1) {
          countdownTimer.cancel();
        }
      });
    }
  }

  stopTimer() {
    if (countdownTimer.isActive) {
      countdownTimer.cancel();
    }
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    super.dispose();
  }



  final TextEditingController otpController = TextEditingController();

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 22,
      // color: Color(0xff1EBCD4),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.shade300),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage( "assets/images/loginBg.png"),fit: BoxFit.fill)
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: BlocListener<OTPBloc, OTPState>(
          listener: (context, state) {
            /// ✅ Success → Home Page
            // if (state.isSuccess) {
            //   Nav.go(context, Routes.home);
            // }
            /// ❌ Error → Dialog Box
            if (state.hasError && state.errorMessage != null) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  title: const Text(
                    "Verification Failed",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  content: Text(
                    state.errorMessage!,
                    style: const TextStyle(fontSize: 14),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Nav.go(context,Routes.login);
                        // Navigator.pop(context);

                        /// state reset (optional but recommended)
                        context.read<OTPBloc>().add(const ResetVerifyOtpEvent());
                      },
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );}

              // if (state.isSuccess) {
            //   Nav.go(
            //     context,
            //     Routes.home,
            //
            //   );
            // }
          },
          child: BlocBuilder<OTPBloc, OTPState>(
              builder: (context, state) {
                final bloc = context.read<OTPBloc>();
                return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height*0.2,),
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
                      'Verify your number',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      softWrap: true,
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Text(
                      'We have sent a verification code to \n+91 ${widget.mobile}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.9),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                      softWrap: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          Pinput(
                            controller: otpController,
                            // focusNode: focusNode,
                            length: 4,
                            defaultPinTheme: defaultPinTheme,
                            separatorBuilder: (index) => const SizedBox(width: 10),
              
                            // validator: (pin) {
                            //   if (pin == '1234') return null;
                            //
                            //   /// Text will be displayed under the Pinput
                            //   return 'Pin is incorrect';
                            // },
                            // validator: (value) {
                            //    return value == _otpController.pinController.value.text ? null : 'Pin is incorrect';
                            // },
                            // onClipboardFound: (value) {
                            //   debugPrint('onClipboardFound: $value');
                            //   pinController.setText(value);
                            // },
                            hapticFeedbackType: HapticFeedbackType.lightImpact,
                            onCompleted: (pin) {
                              debugPrint('onCompleted: $pin');
                            },
                            onChanged: (value) {
                              debugPrint('onChanged: $value');
                            },
                            cursor: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 9),
                                  width: 22,
                                  height: 1,
                                  // color: Color(0xff1EBCD4),
                                ),
                              ],
                            ),
                            focusedPinTheme: defaultPinTheme.copyWith(
                              decoration: defaultPinTheme.decoration!.copyWith(
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(color: Colors.grey),
                              ),
                            ),
                            submittedPinTheme: defaultPinTheme.copyWith(
                              decoration: defaultPinTheme.decoration!.copyWith(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(color: Colors.black),
                              ),
                            ),
                            errorPinTheme: defaultPinTheme.copyBorderWith(
                              border: Border.all(color: Colors.redAccent),
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     buildOtpField(0, focusNode1, focusNode2),
                          //     buildOtpField(1, focusNode2, focusNode3),
                          //     buildOtpField(2, focusNode3, focusNode4),
                          //     buildOtpField(3, focusNode4, null),
                          //   ],
                          // ),
                          SizedBox(
                            height: screenHeight * 0.06,
                          ),
                          CommonAppButton(
                            text: "Verify OTP",
                            isLoading: state.isLoading,
                            onPressed:
                            state.isLoading
                                ? null
                                : () {

                              context.read<OTPBloc>().add(
                                VerifyOtpEvent(
                                  mobileNumber: widget.mobile,
                                  otp: otpController.text, // ✅ CORRECT
                                  context: context,
                                ),
                              );

                            },
                          ),

                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Text(
                            'Didn’t receive the OTP SMS?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.8999999761581421),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          resentTime == 0
                              ? InkWell(
                                  onTap: () {
                                    resentTime = 30;
                                    startTimer();
                               //     sendOtp(mobile: widget.mobile);
                                  },
                                  child: const Center(
                                    child: Text(
                                      "Resend",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              : Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Send OTP again in ',
                                        style: TextStyle(
                                          color: Colors.black
                                              .withOpacity(0.8999999761581421),
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "0:$resentTime",
                                        style: const TextStyle(
                                          color: Color(0xFF00A642),
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' sec',
                                        style: TextStyle(
                                          color: Colors.black
                                              .withOpacity(0.8999999761581421),
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
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
                      height: screenHeight * 0.1,
                    ),
                    // Image.asset(
                    //   "assets/images/otp_bottom_bg.png",
                    //   width: double.infinity,
                    //   fit: BoxFit.fitWidth,
                    // ),
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }


}
