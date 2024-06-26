import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../components/components.dart';

Scaffold playlistScreen(WidgetRef ref, Playlist playlist) {
  return Scaffold(
    appBar: playlistAppBar(ref, playlist.playlistName),
    body: Column(
      children: [
        playlistMenuBlock(ref,playlist),
        songList(ref,playlist.songList),
      ],
    ),
    drawer: sideBar(ref),
  );
}