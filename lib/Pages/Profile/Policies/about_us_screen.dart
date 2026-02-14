import 'package:flutter/material.dart';

import '../../Custom_Widgets/custom_app_bar.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBAR(
        title: "About Us",
        showLeading: true,
        showAction: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Welcome to Mayank Tour and Travel",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 12),

              Text(
                "We are dedicated to providing the best travel experience "
                    "for our customers. Our mission is to deliver safe, reliable, "
                    "and comfortable travel services across the country.\n\n"
                    "With years of experience in the tourism industry, we ensure "
                    "customer satisfaction through our trusted agents and quality service.\n\n"
                    "Thank you for choosing us!",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
