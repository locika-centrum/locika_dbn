import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get gameTheme {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Bitter',
      textTheme: TextTheme(
        // Game title
        titleLarge: const TextStyle(
          fontSize: 36.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        // Main score in the middle of the screen
        displayLarge: TextStyle(
          color: Colors.grey.shade800,
          fontSize: 52.0,
        ),
        // Side score
        displayMedium: TextStyle(
          fontSize: 24.0,
          color: Colors.grey.shade800,
        ),
        // Label of the score widgets
        displaySmall: TextStyle(
          fontSize: 17.0,
          color: Colors.grey.shade900,
        ),
      ),
    );
  }

  static ThemeData get chatTheme {
    return ThemeData(
      brightness: Brightness.light,
      appBarTheme: ThemeData.light().appBarTheme.copyWith(
            backgroundColor: ThemeData.light().canvasColor,
          ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Colors.black,
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: Colors.black,
        ),
        displaySmall: TextStyle(
          color: Colors.black,
          fontSize: 17.0,
        ),
      ),
    );
  }

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
