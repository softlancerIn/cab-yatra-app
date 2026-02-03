import 'package:cab_taxi_app/app/router/navigation/nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AppBAR extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  AppBAR({super.key, required this.title});

  @override
  State<AppBAR> createState() => _AppBARState();

  @override
  Size get preferredSize => Size.fromHeight(60.0);
}

class _AppBARState extends State<AppBAR> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.03,
        ),
        Container(
          width: double.infinity,
          height: screenHeight * 0.08,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Nav.pop(context);
                 //   Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                  ),
                ),
                SizedBox(
                  width: 18,
                ),
                Spacer(),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Image.asset(
                  "assets/images/appbar_car.png",
                  width: 50,
                  fit: BoxFit.fitWidth,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
