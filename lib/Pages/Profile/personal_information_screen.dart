import 'package:flutter/material.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends State<PersonalInformationScreen> {

  int selectedRole = 0; // 0 = Agent, 1 = Owner, 2 = Driver

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Personal information",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              const SizedBox(height: 20),

              /// Profile Image
              const CircleAvatar(
                radius: 50,
                backgroundImage:
                AssetImage('assets/images/profile_image.png'),
              ),

              const SizedBox(height: 30),

              /// Name Field
              _buildTextField("Nishu Tiwari"),

              const SizedBox(height: 15),

              /// Company Field
              _buildTextField("Mayank Tour and Travel"),

              const SizedBox(height: 20),

              /// Role Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _roleButton("Agent", 0),
                  _roleButton("Owner", 1),
                  _roleButton("Driver", 2),
                ],
              ),

              const SizedBox(height: 20),

              /// License Fields
              _buildTextField("Licence Number (optional)"),

              const SizedBox(height: 15),

              _buildTextField("Licence Number (optional)"),

              const SizedBox(height: 50),

              /// Update Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Update",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Text Field Widget
  Widget _buildTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// Role Button Widget
  Widget _roleButton(String title, int index) {
    final bool isSelected = selectedRole == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedRole = index;
          });
        },
        child: Container(
          height: 45,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFFFB100)
                : const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
