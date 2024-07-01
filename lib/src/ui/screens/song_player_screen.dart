import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../components/components.dart';

Scaffold songPlayerScreen(WidgetRef ref, ConcatenatingAudioSource playlist, int index) {
  return Scaffold(
    appBar: songAppBar(ref),
    body: Column(
      children: <Widget>[
        const SizedBox(height: 300),
        songNameBlock(ref, playlist[index] as UriAudioSource),
        songProgressBar(ref, playlist),
        const SizedBox(height: 50),
        songIconBlock(ref, playlist, index),
      ],
    ),
  );
}
