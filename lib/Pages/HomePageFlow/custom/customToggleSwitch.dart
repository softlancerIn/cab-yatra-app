import 'package:cab_taxi_app/app/router/navigation/routes.dart';
import 'package:flutter/material.dart';

import '../../../app/router/navigation/nav.dart';

class CustomToggleSwitch extends StatefulWidget {
  const CustomToggleSwitch({super.key});

  @override
  State<CustomToggleSwitch> createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isOn = !isOn;
        });
        Nav.push(context, Routes.alertFilter);
        //  Get.to(const AlertFilterScreen());
        //    Get.to()AlertFilterScreen
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 35,
        height: 18,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: isOn ? const Color(0xFFFFC107) : const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
