import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_music_player/src/models/models.dart';
import '../components/components.dart';

Scaffold songScreen(WidgetRef ref) {
  return Scaffold(
    appBar: headerBar(ref),
    body: Column(
      children: [
        headerBlock('Your Songs', ref),
        songList(ref, playlistArray[0]),
        miniplayer(ref, false),
      ],
    ),
    drawer: sideBar(ref),
  );
}
