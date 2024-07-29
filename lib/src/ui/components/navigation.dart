import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_music_player/src/services/services.dart';
import '../../config/config.dart';

// selectedItemColor: currentThemeOnSurface(ref),
// unselectedItemColor: currentThemeOnSurfaceVar(ref),

Widget navigationBar(WidgetRef ref) {
  return NavigationBar(
    onDestinationSelected: (value) {
      print('hi $value');
      screenSetState(ref, value);
    },

    selectedIndex: screenReadState(ref),
    destinations: const <Widget>[
      Padding(
        padding:
            EdgeInsets.only(top: kMediumPadding, bottom:kDefaultSmallPadding),
        child: NavigationDestination(
          label: 'Settings',
          icon: Padding(
            padding: EdgeInsets.only(
              bottom: 4,
            ),
            child: Icon(Icons.settings),
          ),
        ),
      ),
      Padding(
        padding:
            EdgeInsets.only(top: kMediumPadding, bottom:kDefaultSmallPadding),
        child: NavigationDestination(
          label: 'Your Playlists',
          icon: Padding(
            padding: EdgeInsets.only(
              bottom: 4,
            ),
            child: Icon(Icons.list),
          ),
        ),
      ),
      Padding(
        padding:
            EdgeInsets.only(top: kMediumPadding, bottom:kDefaultSmallPadding),
        child: NavigationDestination(
          label: 'Your Songs',
          icon: Padding(
            padding: EdgeInsets.only(
              bottom: 4,
            ),
            child: Icon(Icons.music_note),
          ),
        ),
      ),
    ],
  );
}
