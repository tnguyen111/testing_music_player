import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_music_player/src/ui/ui.dart';
import '../components/components.dart';

Scaffold mainScreen(WidgetRef ref) {
  return Scaffold(
    appBar: headerBar(ref, false),
    body: Column(
      children: [
        headerBlock('Your Playlist', ref),
        playlistList(ref),
        miniplayer(ref),
      ],
    ),
    drawer: sideBar(ref),
  );
}
