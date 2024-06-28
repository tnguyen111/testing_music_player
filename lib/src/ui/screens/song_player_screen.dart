import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/models.dart';
import '../components/components.dart';

Scaffold songPlayerScreen(WidgetRef ref, ConcatenatingAudioSource playlist, int index) {
  return Scaffold(
    appBar: songAppBar(ref),
    body: Column(
      children: [
        songNameBlock(ref, playlist[index] as UriAudioSource),
        songIconBlock(ref, playlist, index),
      ],
    ),
    drawer: sideBar(ref),
  );
}
