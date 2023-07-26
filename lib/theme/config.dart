import 'package:flutter/material.dart';

class ThemeConfig {
  static Color lightBG = const Color(0xFFEAEAEA);
  static Color lightPrimary = const Color(0xFF09285E);
  static Color lightSecondary = const Color(0xFFCC4811);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBG,
    primaryColor: lightPrimary,
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: lightBG,
      foregroundColor: lightSecondary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: lightSecondary),
    ),
    dialogBackgroundColor: lightBG,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(lightSecondary),
        side: MaterialStateProperty.all(
          BorderSide(
            color: lightSecondary,
          ),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: lightBG, backgroundColor: lightSecondary), colorScheme: ColorScheme.light(primary: lightPrimary, secondary: lightSecondary).copyWith(background: lightBG),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
  );
}
