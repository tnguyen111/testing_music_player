import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'source_colors.dart';

TextStyle darkThemeHeaderText(){
  return GoogleFonts.roboto(
      color: darkThemeTextColor(),
      fontSize: 28,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500);
}

TextStyle darkThemeSongText(){
  return GoogleFonts.roboto(
      color: darkThemeTextColor(),
      fontSize: 24,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500);
}

TextStyle lightThemeHeaderText(){
  return GoogleFonts.roboto(
      color: lightThemeTextColor(),
      fontSize: 28,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500);
}

TextStyle lightThemeSongText(){
  return GoogleFonts.roboto(
      color: lightThemeTextColor(),
      fontSize: 24,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500);
}

