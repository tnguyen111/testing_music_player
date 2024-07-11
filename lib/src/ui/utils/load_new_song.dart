import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../../../main.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../screens/screens.dart';

void loadNewSong(
  WidgetRef ref,
  ConcatenatingAudioSource playlist,
  int i,
) async {
  Navigator.push(
      globalNavigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => songPlayerScreen(ref, playlist, i),
      ));

  if (player.sequenceState?.currentSource != playlist.children[i]) {
    await player.seek(index: i, Duration.zero);
  }
  playlistSwitchState(ref);
  print('new song loaded');
}

void loadNewPlaylist(ConcatenatingAudioSource playlist, int index) async {
  player.startVisualizer();

  print('new playlist: ${playlist.length}');
  await player.setAudioSource(playlist, initialIndex: index);
}

Future<Duration?> getDuration(File songFile) async {
  bool changed = false;
  bool playing = player.playing;
  AudioSource? tempConcar;
  int? tempIndex;
  Duration tempDura = Duration.zero;

  if(player.audioSource != null){
    tempConcar = player.audioSource;
    tempIndex = player.currentIndex;
    tempDura = player.position;
    changed = true;
  }

  Duration? newDuration = Duration.zero;
  UriAudioSource tempAudio = AudioSource.uri(
    Uri.parse(songFile.path),
    tag: const MediaItem(id: '-1', title: ' '),
  );

  newDuration = await player.setAudioSource(tempAudio);

  if(changed){
    await player.setAudioSource(tempConcar!,initialIndex: tempIndex,initialPosition: tempDura);

    if(playing) player.play();

  } else {
    player.stop();
  }

  print('New Duration: $newDuration');
  return newDuration;
}

void skipSong(WidgetRef ref, ConcatenatingAudioSource playlist, int i,
    bool isNotMiniplayer) async {
  print('skip');
  await player.seek(index: i, Duration.zero);
  if (isNotMiniplayer) {
    print('pushed');
    Navigator.pop(globalNavigatorKey.currentContext!);
    Navigator.push(
        globalNavigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => songPlayerScreen(ref, playlist, i),
        ));
  }
  playlistSwitchState(ref);
  print('new song');
}
