import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../Controllers/my_booking_controller.dart';
import '../../core/network_service.dart';
import 'dart:ui';
import 'package:get/get.dart';
import '../../Controllers/home_controller.dart';
import '../Booking/my_booking.dart';

class OtpDialog extends StatefulWidget {
  final String bookingId;

  OtpDialog({required this.bookingId});

  @override
  _OtpDialogState createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  final TextEditingController _otpController = TextEditingController();
  MyBookingController? myBookingController;
  HomeController? homeController;
  String? _errorMessage;

  Future<void> _submitOtp() async {
    String otp = _otpController.text;

    if (otp.length == 4) {
      try {
        setState(() {
          _errorMessage = null;
        });
        final result = await NetworkService().verifyStartRideOtp(
          bookingId: widget.bookingId,
          otp: otp,
        );

        if (result != null && result['status'] == true) {
         // await myBookingController?.getMyBookingData();
         await homeController?.getHomeData();
          Get.back();
          print("OTP Verified and Ride Started Successfully!");
          // Get.off(() => BookingPage());

        } else {
          setState(() {
            _errorMessage =
                result != null ? result['message'] : 'Failed to start the ride';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred. Please try again.';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Please enter a valid 4-digit OTP';
      });
    }
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 22,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.shade300),
    ),
  );

  Future<void> _resendOtp() async {
    final controller = Get.put(HomeController());
    await controller.pickUpBookingOrder(
      bookingId: widget.bookingId,
    );
    print('sent again');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(
        child: Text(
          'Enter Pick Up OTP',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 18,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Pinput(
                  controller: _otpController,
                  length: 4,
                  defaultPinTheme: defaultPinTheme,
                  separatorBuilder: (index) => const SizedBox(width: 10),
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  // onCompleted: (pin) {
                  //   debugPrint('onCompleted: $pin');
                  //   _submitOtp();
                  // },
                  // onChanged: (value) {
                  //   debugPrint('onChanged: $value');
                  // },
                  cursor: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 9),
                        width: 22,
                        height: 1,
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
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Column(
          children: [
            TextButton(
              onPressed: _resendOtp,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Resend OTP',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFFFFB900),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: _submitOtp,
              child: Center(
                child: Text(
                  'Start Ride',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
