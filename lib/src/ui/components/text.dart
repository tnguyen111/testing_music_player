import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart';
import '../themes/current_theme.dart';

Text headerText(WidgetRef ref, String string) {
  return Text(
    string,
    style: Theme.of(ContextKey.navKey.currentContext!)
        .textTheme
        .titleLarge
        ?.apply(color: currentThemeOnSurfaceVar(ref)),
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
        ?.apply(color: currentThemeOnSurfaceVar(ref)),
  );
}

Text songText(WidgetRef ref, String string) {
  return Text(
    string,
    maxLines: 1,
    overflow: TextOverflow.fade,
    style: Theme.of(ContextKey.navKey.currentContext!)
        .textTheme
        .headlineMedium
        ?.apply(
          color: currentThemeOnSurface(ref),
        ),
  );
}

Text artistText(WidgetRef ref, String string) {
  return Text(
    string,
    maxLines: 1,
    overflow: TextOverflow.fade,
    style: Theme.of(ContextKey.navKey.currentContext!)
        .textTheme
        .bodyLarge
        ?.apply(
      color: currentThemeOnSurface(ref),
    ),
  );
}

Text timeText(WidgetRef ref, String string) {
  return Text(
    string,
    style: Theme.of(ContextKey.navKey.currentContext!)
        .textTheme
        .headlineMedium
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
