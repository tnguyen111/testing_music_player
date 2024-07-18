import 'package:flutter/material.dart';
import 'source_colors.dart';
import 'text_theme.dart';


ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: lightThemeHeader(),
      toolbarHeight: 60,
    ),
    colorScheme: const ColorScheme.light(),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        iconSize: WidgetStatePropertyAll(40),
        backgroundColor: WidgetStateColor.transparent,
      ),
    ),
    iconTheme: IconThemeData(color: lightThemeTextColor(), size: 40),
    scaffoldBackgroundColor: lightThemeMain(),
    buttonTheme: ButtonThemeData(buttonColor: lightThemeTextColor(), height: 40),
    textTheme: TextTheme(
        headlineMedium: lightThemeHeaderText(),
        bodyMedium: lightThemeSongText(),
    ),
  );
}
