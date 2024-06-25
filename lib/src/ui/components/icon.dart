import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_api_twitter/src/models/models.dart';
import 'package:testing_api_twitter/src/services/services.dart';
import 'package:testing_api_twitter/src/services/state_management/helper_funcs/helper_funcs.dart';
import 'package:testing_api_twitter/src/ui/screens/edit_playlist_screen.dart';

import '../../../main.dart';
import '../screens/add_playlist_screen.dart';

IconButton searchIcon(WidgetRef ref) => IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        /*Search things*/
        modeSwitchState(ref);
      },
    );

IconButton menuIcon(BuildContext context) => IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        /*Open drawer*/
        Scaffold.of(context).openDrawer();
      },
    );

IconButton sortIcon() => IconButton(
      icon: const Icon(Icons.sort),
      onPressed: () {
        /*Sort things*/
      },
    );

IconButton addIcon() => IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        /*Add things*/
      },
    );

IconButton removeIcon() => IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        /*Remove things*/
      },
    );

PopupMenuButton<String> settingListIcon(WidgetRef ref) =>
    PopupMenuButton<String>(
      onSelected: (value) {
        handleSettingListClick(value, ref);
      },
      itemBuilder: (BuildContext context) {
        return {'Add New Playlist', 'Delete Playlist'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );

void handleSettingListClick(String value, WidgetRef ref) {
  switch (value) {
    case 'Add New Playlist':
      Navigator.push(
        globalNavigatorKey.currentContext!,
        MaterialPageRoute(
            builder: (context) => AddPlaylistScreen(
                  ref: ref,
                )),
      );
      break;
    case 'Delete Playlist':
      break;
  }
}

PopupMenuButton<String> settingSongIcon(WidgetRef ref, Playlist playlist) =>
    PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz),
      iconSize: 30,
      onSelected: (value) {
        handleSettingSongClick(value, ref, playlist);
        playlistSwitchState(ref);
      },
      itemBuilder: (BuildContext context) {
        return {'Edit Playlist Info', 'Delete Playlist'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );

void handleSettingSongClick(String value, WidgetRef ref, Playlist playlist) {
  switch (value) {
    case 'Edit Playlist Info':
      Navigator.push(
        globalNavigatorKey.currentContext!,
        MaterialPageRoute(
            builder: (context) => EditPlaylistScreen(
                  ref: ref,
                  playlist: playlist,
                )),
      );
      break;
    case 'Delete Playlist':
      print(playlistArray);
      playlistArray.remove(playlist);
      print(playlistArray);
      break;
  }
}
