import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../main.dart';
import '../themes/current_theme.dart';

Text headerText(WidgetRef ref, String string) {
  return Text(
    string,
    style: Theme.of(ContextKey.navKey.currentContext!)
        .textTheme
        .titleLarge
        ?.apply(color: currentThemeOnSurface(ref)),
  );
}

Text playlistText(WidgetRef ref, String string) {
  return Text(
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    string,
    style: Theme.of(ContextKey.navKey.currentContext!)
        .textTheme
        .titleLarge
        ?.apply(color: currentThemeOnSurface(ref)),
  );
}

Text songText(WidgetRef ref, String string) {
  return Text(
    string,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style:
        Theme.of(ContextKey.navKey.currentContext!).textTheme.bodyLarge?.apply(
              color: currentThemeOnSurface(ref),
            ),
  );
}

Text artistText(WidgetRef ref, String string) {
  return Text(
    string,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style:
        Theme.of(ContextKey.navKey.currentContext!).textTheme.bodyMedium?.apply(
              color: currentThemeOnSurfaceVar(ref),
            ),
  );
}

Text contentText(WidgetRef ref, String string) {
  return Text(
    string,
    style:
    Theme.of(ContextKey.navKey.currentContext!).textTheme.bodyMedium?.apply(
      color: currentThemeOnSurfaceVar(ref),
    ),
  );
}

Text timeText(WidgetRef ref, String string) {
  return Text(
    string,
    style: Theme.of(ContextKey.navKey.currentContext!)
        .textTheme
        .headlineSmall
        ?.apply(
          color: currentThemeOnSurface(ref),
        ),
  );
}

Text bottomNavTitleText(WidgetRef ref, String string) {
  return Text(
    string,
    style: Theme.of(ContextKey.navKey.currentContext!)
        .textTheme
        .titleSmall
        ?.apply(color: currentThemeOnSurfaceVar(ref)),
  );
}

TextScroll miniSongText(WidgetRef ref, String string) {
  return TextScroll(
    string,
    mode: TextScrollMode.endless,
    style: Theme.of(ContextKey.navKey.currentContext!)
        .textTheme
        .titleLarge
        ?.apply(color: currentThemeOnSurface(ref)),
    textAlign: TextAlign.start,
  );
}

TextScroll miniArtistText(WidgetRef ref, String string) {
  return TextScroll(
    string,
    mode: TextScrollMode.endless,
    style: Theme.of(ContextKey.navKey.currentContext!)
        .textTheme
        .titleSmall
        ?.apply(color: currentThemeOnSurfaceVar(ref)),
    textAlign: TextAlign.start,
  );
}

Text alertActionText(WidgetRef ref, String string, bool isDisabled) {
  return Text(
    textAlign: TextAlign.start,
    string,
    style: (isDisabled)
        ? Theme.of(ContextKey.navKey.currentContext!)
            .textTheme
            .labelLarge
            ?.apply(color: currentThemeSurfaceTint(ref))
        : Theme.of(ContextKey.navKey.currentContext!)
            .textTheme
            .labelLarge
            ?.apply(color: currentThemePrimary(ref)),
  );
}

TextStyle? searchFieldTextStyle(WidgetRef ref) {
  return Theme.of(ContextKey.navKey.currentContext!)
        .textTheme
        .bodyLarge
        ?.apply(color: currentThemeOnSurface(ref));
}

Text filledButtonText(WidgetRef ref, String string) {
  return Text(
    textAlign: TextAlign.start,
    string,
    style: Theme.of(ContextKey.navKey.currentContext!)
        .textTheme
        .labelLarge
        ?.apply(color: currentThemeOnPrimaryContainer(ref)),
  );
}

Text settingText(WidgetRef ref, String string) {
  return Text(textAlign: TextAlign.start,
    string,
    style:
    Theme.of(ContextKey.navKey.currentContext!).textTheme.bodyLarge?.apply(
      color: currentThemeOnSurface(ref),
    ),
  );
}
