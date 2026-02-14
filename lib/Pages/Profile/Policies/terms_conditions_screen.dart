import 'package:flutter/material.dart';
import '../../Custom_Widgets/custom_app_bar.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBAR(
        title: "Terms & Conditions",
        showLeading: true,
        showAction: false,
      ),
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
                  "Terms & Conditions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 15),

                Text(
                  "Please read these Terms and Conditions carefully before "
                      "using our services.\n\n"

                      "1. Booking Policy\n"
                      "All bookings are subject to availability and confirmation. "
                      "Customers must provide accurate information at the time of booking.\n\n"

                      "2. Payment Terms\n"
                      "Full or partial payment may be required to confirm your booking. "
                      "Payments once made are subject to cancellation policies.\n\n"

                      "3. Cancellation & Refund\n"
                      "Cancellations must be made within the allowed time frame. "
                      "Refund eligibility depends on our company’s refund policy.\n\n"

                      "4. Customer Responsibility\n"
                      "Customers are responsible for maintaining proper documents, "
                      "arriving on time, and respecting local regulations.\n\n"

                      "5. Limitation of Liability\n"
                      "We are not liable for delays, damages, or losses caused by "
                      "circumstances beyond our control such as weather conditions "
                      "or government restrictions.\n\n"

                      "6. Changes to Terms\n"
                      "We reserve the right to update these Terms & Conditions "
                      "at any time without prior notice.\n\n"

                      "By using our service, you agree to abide by these terms.",
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
