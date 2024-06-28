import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/services.dart';
import '../themes/themes.dart';

ThemeData currentTheme(WidgetRef ref){
  if(modeReadState(ref)) return lightTheme();
  return darkTheme();
}

Color currentThemeHeader(WidgetRef ref){
  if(modeReadState(ref)) return lightThemeHeader();
  return darkThemeHeader();
}

Color currentThemeSub(WidgetRef ref){
  if(modeReadState(ref)) return lightThemeSub();
  return darkThemeSub();
}

TextStyle currentThemeHeaderText(WidgetRef ref){
  if(modeReadState(ref)) return lightThemeHeaderText();
  return darkThemeHeaderText();
}

TextStyle currentThemeSmallText(WidgetRef ref){
  if(modeReadState(ref)) return lightThemeSongText();
  return darkThemeSongText();
}