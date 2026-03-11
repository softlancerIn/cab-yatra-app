// import 'package:flutter/material.dart';
//
// class AppTheme {
//   // LIGHT THEME
//   static final ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     useMaterial3: true,
//     colorSchemeSeed:Color(0xFFFB721D),
//   );
//
//   // DARK THEME
//   static final ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     useMaterial3: true,
//     colorSchemeSeed: Color(0xFFFB721D),
//   );
// }
import 'package:flutter/material.dart';

import 'color_resource.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: const ColorScheme.light(
          primary:
              ColorResource.primaryColor, // SELECTED DATE BACKGROUND (circle)
          onPrimary: Colors.white, // SELECTED DATE TEXT COLOR (white)
          onSurface: ColorResource.darkText // normal text
          ),
      scaffoldBackgroundColor: ColorResource.background,
      primaryColor: ColorResource.primaryColor,
      fontFamily: 'Poppins',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: ColorResource.darkText),
        headlineMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ColorResource.darkText),
        bodyLarge: TextStyle(fontSize: 16, color: ColorResource.darkText),
        bodyMedium: TextStyle(fontSize: 14, color: ColorResource.lightText),
        labelLarge: TextStyle(fontSize: 12, color: ColorResource.lightText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorResource.primaryColor,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorResource.greyBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorResource.greyBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: ColorResource.primaryColor, width: 1.5),
        ),
        hintStyle: const TextStyle(color: ColorResource.lightText),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorResource.toggleOn;
          }
          return ColorResource.toggleOff;
        }),
        thumbColor: WidgetStateProperty.all<Color>(Colors.white),
      ),
      cardTheme: CardThemeData(
        color: ColorResource.white,
        elevation: 3,
        shadowColor: ColorResource.shadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: ColorResource.white,
        headerBackgroundColor: ColorResource.primaryColor,
        headerForegroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        dayStyle: const TextStyle(
          color: ColorResource.darkText,
          fontWeight: FontWeight.w500,
        ),
        todayBorder: const BorderSide(color: ColorResource.primaryColor),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.disabled)) {
              return ColorResource.lightText;
            }
            return ColorResource.primaryColor;
          }),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          overlayColor: WidgetStateProperty.all(
            ColorResource.primaryColor, // ripple effect
          ),
        ),
      ),
    );
  }
}
