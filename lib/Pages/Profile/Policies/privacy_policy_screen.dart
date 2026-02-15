import 'package:cab_taxi_app/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../../Custom_Widgets/custom_app_bar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Privacy Policy",
      ),
      backgroundColor: const Color(0xFFF4F4F4),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 10),

                Text(
                  "Privacy Policy",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 15),

                Text(
                  "We value your privacy and are committed to protecting your "
                      "personal information. This Privacy Policy explains how we "
                      "collect, use, and safeguard your data.\n\n"

                      "1. Information We Collect\n"
                      "We may collect personal details such as your name, phone number, "
                      "email address, and booking information.\n\n"

                      "2. How We Use Information\n"
                      "Your data is used to provide and improve our services, "
                      "process bookings, and communicate important updates.\n\n"

                      "3. Data Protection\n"
                      "We implement security measures to protect your information "
                      "from unauthorized access or disclosure.\n\n"

                      "4. Third-Party Sharing\n"
                      "We do not sell or share your personal information with third "
                      "parties except as required to deliver our services.\n\n"

                      "5. Updates to Policy\n"
                      "We may update this Privacy Policy from time to time. "
                      "Please review it periodically for changes.\n\n"

                      "If you have any questions regarding this policy, "
                      "please contact us.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
