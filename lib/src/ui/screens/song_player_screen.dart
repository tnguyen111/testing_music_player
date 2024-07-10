import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../services/services.dart';
import '../components/components.dart';

Scaffold songPlayerScreen(WidgetRef ref, ConcatenatingAudioSource playlist, int index) {
  AppLifecycleListener(onResume: () => playlistSwitchState(ref));
  return Scaffold(
    appBar: songAppBar(ref),
    body: Column(
      children: <Widget>[
        songWaveForm(ref, true),
        songNameBlock(ref),
        songProgressBar(ref, playlist, true),
        const SizedBox(height: 50),
        songIconBlock(ref, playlist, index,true),
      ],
    ),
  );
}
