import 'package:flutter/material.dart';

import '../app/theme/color_resource.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? const Color(0xFFFB721D), // default orange
        foregroundColor: foregroundColor ?? Colors.white, // default white text
        // padding: const EdgeInsets.symmetric(vertical: 16),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(12),
        // ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}







class CommonAppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // null hoga to button disabled ho jayega
  final bool isLoading; // Loader show karne ke liye
  final Color? backgroundColor;
  final Color? disabledColor;
  final Color? textColor;
  final double? width;
  final double height;
  final double borderRadius;
  final FontWeight fontWeight;
  final double fontSize;

  const CommonAppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.disabledColor,
    this.textColor,
    this.width,
    this.height = 48.0,
    this.borderRadius = 12.0,
    this.fontWeight = FontWeight.bold,
    this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = backgroundColor ?? ColorResource.primaryColor;
    // Agar aapke pass ColorResource.primaryColor hai toh usko use karo
    // final Color primaryColor = backgroundColor ?? ColorResource.primaryColor;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: GestureDetector(
        onTap: isLoading ? null : onPressed, // Loading mein disabled

        child:Container(
          width: MediaQuery.of(context).size.width,
          height: 45,
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: backgroundColor??ColorResource.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: isLoading
              ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: textColor ?? Colors.white,
              strokeWidth: 2.5,
            ),
          )
              : Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}