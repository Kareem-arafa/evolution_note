import 'package:flutter/material.dart';

class AppTheme {
  static Color primary = const Color(0xFFfbe30c);
  static Color backgroundColor = const Color(0xFFDFECDB);
  static Color white = const Color(0xFFFFFFFF);
  static Color grey = const Color(0xFFa5aba7);
  static Color green = const Color(0xFF61E757);
  static Color red = const Color(0xFFEC4B4B);
  static Color black = const Color(0xFF000000);
  static ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: white,
   
    textTheme: TextTheme(
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: primary,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: black,
      ),
    ),
    
  );
}
