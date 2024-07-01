import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ui.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

Widget addSongScreen(WidgetRef ref, ConcatenatingAudioSource playlist){
  return Scaffold(
    appBar: playlistAppBar(ref,''),
    body: Column(
      children: [
        headerBlock('Your Songs', ref),
        addSongList(ref, playlist),
      ],
    ),
  );
}