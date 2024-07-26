import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/config.dart';
import '../../models/models.dart';
import '../ui.dart';

AppBar headerBar(WidgetRef ref, bool isSongList) {
  return AppBar(
    toolbarHeight: appBarHeight,
    title: (isSongList)
        ? headerText(
            ref,
            'Your Songs',
          )
        : headerText(
            ref,
            'Your Playlists',
          ),
    actions: [
      (isSongList)
          ? searchSongIcon(ref, playlistArray[0])
          : searchPlaylistIcon(ref),
      (isSongList) ? addIcon(ref, playlistArray[0]) : addPlaylistIcon(ref),
    ],
  );
}

AppBar playlistAppBar(WidgetRef ref, Playlist playlist) {
  return AppBar(
    leading: Builder(
      builder: (context) {
        return backIcon(context);
      },
    ),
    actions: [
      searchSongIcon(ref, playlist),
      settingSongIcon(ref, playlist),
    ],
    title: headerText(
      ref,
      playlist.playlistName,
      //style: currentThemeHeaderText(ref),
    ),
  );
}

AppBar addSongAppBar(WidgetRef ref, Playlist playlist) {
  return AppBar(
    leading: Builder(
      builder: (context) {
        return backIcon(context);
      },
    ),
    actions: [searchSongIcon(ref, playlistArray[0])],
    title: headerText(
      ref,
      playlist.playlistName, //style: currentThemeHeaderText(ref),
    ),
  );
}

AppBar songAppBar(WidgetRef ref) {
  return AppBar(
    leading: Builder(
      builder: (context) {
        return backIcon(context);
      },
    ),
    title: headerText(
      ref,
      'Now Playing', //style: currentThemeHeaderText(ref),
    ),
  );
}
