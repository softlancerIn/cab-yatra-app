import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;
  final Color? borderColor;
  final double? width;
  final double? height;
  final double borderRadius;

  const CustomTextButton({
    Key? key,
    required this.title,
    required this.color,
    required this.textColor,
    required this.onPressed,
    this.borderColor,
    this.width,
    this.height,
    this.borderRadius = 6.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: width ?? size.width * 0.25,
          height: height ?? size.height * 0.06,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius),
            border: borderColor != null
                ? Border.all(
              color: borderColor!,
              width: 1.0,
            )
                : null,
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
