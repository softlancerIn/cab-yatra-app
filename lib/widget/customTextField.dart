






import 'package:flutter/material.dart';
import 'package:flutter/services.dart';





class CommonTextFormField extends StatelessWidget {
  // Sabhi properties same as CommonTextFormField
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? counterText;

  // Icons
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final Widget? customSuffix;

  // Validation & Regex
  final String? Function(String?)? validator;
  final String? regexPattern;
  final String? regexErrorMessage;

  // Callbacks
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;
  final Function(String?)? onSaved;

  // Input settings
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;

  // Styling (extra for your original look)
  final double height;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;

  const CommonTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.helperText,
    this.counterText,
    this.prefixIcon,
    this.suffixIcon,
    this.customSuffix,
    this.validator,
    this.regexPattern,
    this.regexErrorMessage = 'Invalid format',
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.onSaved,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.height = 50.0,
    this.backgroundColor = Colors.white,
    this.borderColor ,
    this.borderRadius = 10.0,
  });

  // Regex validator same as before
  String? _regexValidator(String? value) {
    if (value == null || value.isEmpty) return null;
    if (regexPattern != null) {
      final regExp = RegExp(regexPattern!);
      if (!regExp.hasMatch(value.trim())) return regexErrorMessage;
    }
    return null;
  }

  // Combined validator
  String? _getValidator(String? value) {
    if (validator != null) {
      final result = validator!(value);
      if (result != null) return result;
    }
    return _regexValidator(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor??Color(0xffDBDBDB)),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        obscureText: obscureText,
        enabled: enabled,
        readOnly: readOnly,
        autofocus: autofocus,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        onTap: onTap,
        onSaved: onSaved,
        validator: _getValidator,
        style: TextStyle(
          fontSize: 14,
          color: enabled ? Colors.black : Colors.grey,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          helperText: helperText,
          counterText: counterText ?? "", // Hide counter by default
          prefixIcon: prefixIcon != null
              ? Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(prefixIcon, size: 20, color: Colors.black54),
          )
              : null,
          suffixIcon: customSuffix ?? suffixIcon,
          border: InputBorder.none, // No border, just container handles it
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          hintStyle: TextStyle(
            color: Colors.black54,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
