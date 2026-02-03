import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  Razorpay? _razorpay;
  BuildContext? _context;

  PaymentService() {
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void dispose() {
    _razorpay!.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: 'Successfully');
    // showCongratulationsDialog(_context!);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "ERROR: ${response.code} - ${response.message!}",
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: 'Purchased');
  }

  Future<void> openCheckout({
    required String price,
    required String orderId,
    String? bookingId,
    required BuildContext context,
  }) async {
    _context = context;
    // final ByteData bytes =
    //     await rootBundle.load('assets/images/splashImage.png');
    // final List<int> imageBytes = bytes.buffer.asUint8List();
    // final String base64Image = base64Encode(imageBytes);
    var options = {
      // 'key': 'rzp_test_J0b6bXmWMkyfkF',
      'key': 'rzp_test_2APbUBB8GPokeh',
      // 'key': 'rzp_live_SERm9YPtr7scxP',
      'order_id': orderId,
      'amount': (double.parse(price) * 100).toInt(),
      'name': 'Cab',
      'description': 'Easy your way of learning',
      // 'image': "data:image/png;base64,$base64Image",
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '9898989898', 'email': 'abx@gmail.com'},
      'external': {
        'wallets': ['paytm']
      },
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
