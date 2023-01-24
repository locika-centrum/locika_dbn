import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Bitter',
      appBarTheme: ThemeData.dark().appBarTheme.copyWith(
            backgroundColor: ThemeData.light().canvasColor,
            foregroundColor: ThemeData.light().textTheme.bodyMedium?.color,
          ),
      textTheme: const TextTheme(
        titleSmall: TextStyle(
          fontSize: 17.0,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 52.0,
        ),
        headlineSmall: TextStyle(),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 36.0,
        ),
        headlineLarge: TextStyle(),
      ));

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Bitter',
    appBarTheme: ThemeData.dark().appBarTheme.copyWith(
          backgroundColor: ThemeData.dark().canvasColor,
          foregroundColor: ThemeData.dark().textTheme.bodyMedium?.color,
        ),
  );
}
