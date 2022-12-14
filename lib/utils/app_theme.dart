import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Bitter',
    appBarTheme: ThemeData.dark().appBarTheme.copyWith(
          backgroundColor: ThemeData.light().canvasColor,
          foregroundColor: ThemeData.light().textTheme.bodyMedium?.color,
        ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Bitter',
    appBarTheme: ThemeData.dark().appBarTheme.copyWith(
          backgroundColor: ThemeData.dark().canvasColor,
          foregroundColor: ThemeData.dark().textTheme.bodyMedium?.color,
        ),
  );
}
