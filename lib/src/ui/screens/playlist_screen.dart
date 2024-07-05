import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../models/models.dart';
import '../components/components.dart';

Scaffold playlistScreen(WidgetRef ref, Playlist playlist) {
  return Scaffold(
    appBar: playlistAppBar(ref, playlist.playlistName),
    body:
      SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.sizeOf(globalNavigatorKey.currentContext!).height - 100,
          width: MediaQuery.sizeOf(globalNavigatorKey.currentContext!).width,
          child: Column(
            children: <Widget>[
              playlistMenuBlock(ref,playlist),
              songList(ref,playlist.songList),
              miniplayer(ref, true),
            ],
          ),
        ),
      ),
  );
}