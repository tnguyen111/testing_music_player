import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/config.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../ui.dart';

AppBar headerBar(WidgetRef ref) {
  return AppBar(
    toolbarHeight: appBarHeight,
    title: (screenReadState(ref) == 0)
        ? headerText(
            ref,
            'Your Settings',
          )
        : (screenReadState(ref) == 1)
            ? headerText(
                ref,
                'Your Playlists',
              )
            : headerText(
                ref,
                'Your Songs',
              ),
    actions: [
      (screenReadState(ref) == 1)
          ? searchPlaylistIcon(ref)
          : (screenReadState(ref) == 2) ? searchSongIcon(ref, playlistArray[0]): Container(),
      (screenReadState(ref) == 1) ? addPlaylistIcon(ref) : (screenReadState(ref) == 2) ? addIcon(ref, playlistArray[0]): Container(),
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
