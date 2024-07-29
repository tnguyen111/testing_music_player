import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/services.dart';
import 'themes.dart';

ThemeData currentTheme(WidgetRef ref) {
  if (modeReadState(ref)) {
    return ThemeData(colorScheme: lightHighContrastScheme());
  }
  return ThemeData(colorScheme: darkHighContrastScheme());
}

Color currentThemeSurface(WidgetRef ref) {
  return currentTheme(ref).colorScheme.surface;
}

Color currentThemeSurfaceContainerHighest(WidgetRef ref) {
  return currentTheme(ref).colorScheme.surfaceContainerHighest;
}

Color currentThemeSurfaceContainerHigh(WidgetRef ref) {
  return currentTheme(ref).colorScheme.surfaceContainerHigh;
}

Color currentThemeSurfaceContainer(WidgetRef ref) {
  return currentTheme(ref).colorScheme.surfaceContainer;
}

Color currentThemeSurfaceContainerLow(WidgetRef ref) {
  return currentTheme(ref).colorScheme.surfaceContainerLow;
}

Color currentThemeSurfaceContainerLowest(WidgetRef ref) {
  return currentTheme(ref).colorScheme.surfaceContainerLowest;
}

Color currentThemePrimary(WidgetRef ref) {
  return currentTheme(ref).colorScheme.primary;
}

Color currentThemeInversePrimary(WidgetRef ref) {
  return currentTheme(ref).colorScheme.inversePrimary;
}

Color currentThemeSurfaceTint(WidgetRef ref) {
  return currentTheme(ref).colorScheme.surfaceTint;
}

Color currentThemePrimaryContainer(WidgetRef ref) {
  return currentTheme(ref).colorScheme.primaryContainer;
}

Color currentThemeSecondary(WidgetRef ref) {
  return currentTheme(ref).colorScheme.secondary;
}

Color currentThemeSecondaryContainer(WidgetRef ref) {
  return currentTheme(ref).colorScheme.secondaryContainer;
}

Color currentThemeOnSurface(WidgetRef ref) {
  return currentTheme(ref).colorScheme.onSurface;
}

Color currentThemeOnSurfaceVar(WidgetRef ref) {
  return currentTheme(ref).colorScheme.onSurfaceVariant;
}

Color currentThemeOnPrimary(WidgetRef ref){
  return currentTheme(ref).colorScheme.onPrimary;
}

Color currentThemeOnPrimaryContainer(WidgetRef ref){
  return currentTheme(ref).colorScheme.onPrimaryContainer;
}

Color currentThemeOnSecondary(WidgetRef ref){
  return currentTheme(ref).colorScheme.onSecondary;
}

Color currentThemeOnSecondaryContainer(WidgetRef ref){
  return currentTheme(ref).colorScheme.onSecondaryContainer;
}

Color currentThemeErrorContainer(WidgetRef ref){
  return currentTheme(ref).colorScheme.errorContainer;
}


// TextStyle currentThemeHeaderText(WidgetRef ref){
//   if(modeReadState(ref)) return lightThemeHeaderText();
//   return darkThemeHeaderText();
// }
//
// TextStyle currentThemeSmallText(WidgetRef ref){
//   if(modeReadState(ref)) return lightThemeSongText();
//   return darkThemeSongText();
// }
