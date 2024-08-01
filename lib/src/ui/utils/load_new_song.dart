import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../../../main.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../screens/screens.dart';
import '../ui.dart';

void loadNewSong(
  WidgetRef ref,
  Playlist playlist,
  int i,
) async {
  Navigator.push(
      ContextKey.navKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => songPlayerScreen(ref, playlist, i),
      ));
  if (player.sequenceState?.currentSource != playlist.songList[i]) {
    await player.seek(Duration.zero, index: i);
    startSong(ref);
  }

  playlistSwitchState(ref);
  print('new song loaded');
}

void loadNewPlaylist(Playlist playlist, int index) async {
  print('new playlist: ${playlist.songList.length}');
  print((playlist.songList.children[index] as UriAudioSource).tag.id);
  await player.setAudioSource(playlist.songList, initialIndex: index);
  await player.startVisualizer();
}

Future<Duration?> getDuration(File songFile) async {
  bool changed = false;
  bool playing = player.playing;
  AudioSource? tempConcar;
  int? tempIndex;
  Duration tempDura = Duration.zero;

  if (player.audioSource != null) {
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

  try {
    newDuration = await player.setAudioSource(tempAudio);
  } on PlayerInterruptedException {
    // do nothing
    print('expected throw');
  }

  if (changed) {
    await player.setAudioSource(tempConcar!,
        initialIndex: tempIndex, initialPosition: tempDura);
    if (playing) player.play();
  }

  return newDuration;
}

void skipSong(
    WidgetRef ref, Playlist playlist, int i, bool isNotMiniplayer) async {
  await player.seek(index: i, Duration.zero);
  playlistSwitchState(ref);
}
