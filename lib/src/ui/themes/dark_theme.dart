import 'package:flutter/material.dart';
import 'package:testing_api_twitter/src/config/config.dart';
import 'source_colors.dart';
import 'text_theme.dart';

ThemeData darkTheme() {
  return ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: darkThemeHeader(),
      toolbarHeight: 60,
    ),
    colorScheme: const ColorScheme.dark(),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        iconSize: WidgetStatePropertyAll(40),
        backgroundColor: WidgetStateColor.transparent,
      ),
    ),
    iconTheme: IconThemeData(color: darkThemeTextColor(), size: 40,),
    scaffoldBackgroundColor: darkThemeMain(),
    textTheme: TextTheme(
      headlineMedium: darkThemeHeaderText(),
      bodyMedium: darkThemeSongText(),
    ),
  );
}
