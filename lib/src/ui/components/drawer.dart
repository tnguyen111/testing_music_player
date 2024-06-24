import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_api_twitter/src/services/services.dart';

Drawer sideBar(WidgetRef ref) {
  return Drawer(
    child: Column(
      // Important: Remove any padding from the ListView.
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: Container(),
        ),
        ListTile(
          title: const Text('Your Playlists'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          title: const Text('Your Songs'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
              alignment: Alignment.center,
              onPressed: () {
                modeSwitchState(ref);
              },
              icon: const Icon(Icons.settings_brightness),
            ),
          ),
        ),
      ],
    ),
  );
}
