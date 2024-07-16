import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../ui.dart';


AppBar headerBar(WidgetRef ref){
  return AppBar(
    leading: Builder(
      builder: (context) {
        return menuIcon(context);
      },
    ),
    //actions: [searchIcon(ref)],
  );
}

AppBar playlistAppBar(WidgetRef ref, Playlist playlist){
  return AppBar(
    leading: Builder(
      builder: (context) {
        return backIcon(context);
      },
    ),
    actions: [searchIcon(ref, playlist)],
    title: Text(playlist.playlistName, style: currentThemeHeaderText(ref),),
  );
}

AppBar addSongAppBar(WidgetRef ref, Playlist playlist){
  return AppBar(
    leading: Builder(
      builder: (context) {
        return backIcon(context);
      },
    ),
    actions: [searchIcon(ref, playlistArray[0])],
    title: Text(playlist.playlistName, style: currentThemeHeaderText(ref),),
  );
}

AppBar songAppBar(WidgetRef ref){
  return AppBar(
    leading: Builder(
      builder: (context) {
        return backIcon(context);
      },
    ),
    //actions: [searchIcon(ref)],
    title: Text('Now Playing',style: currentThemeHeaderText(ref)),
  );
}



