import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../models/models.dart';
import '../ui.dart';
import 'package:flutter/material.dart';

Widget addToPlaylistScreen(WidgetRef ref, Playlist originalPlaylist, AudioSource song){
  return Scaffold(
    appBar: addToPlaylistAppBar(ref,song),
    body: Column(
      children: [
        headerBlock('Other Playlists', ref),
        addToPlaylistList(ref, originalPlaylist, song),
      ],
    ),
  );
}