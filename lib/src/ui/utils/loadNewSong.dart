import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../main.dart';
import '../../models/models.dart';
import '../screens/screens.dart';

void loadNewSong(WidgetRef ref, ConcatenatingAudioSource playlist, int i) async {
  Navigator.push(
      globalNavigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => songPlayerScreen(ref, playlist, i),
      ));
    await player.seek(index: i, Duration.zero);
    print('new song');
}



void loadNewPlaylist(ConcatenatingAudioSource playlist) async{
    print('new playlist: ${playlist.length}');
    await player.setAudioSource(playlist);
}

Future<Duration?> getDuration(File songFile) async{
    final tempPlayer = AudioPlayer();
    Duration? newDuration = Duration.zero;
    newDuration = await tempPlayer.setUrl(songFile.path);
    print('New Duration: $newDuration');
    return newDuration;
}

void skipSong(
    WidgetRef ref, ConcatenatingAudioSource playlist, int i) async {
  await player.seek(index: i, Duration.zero);
  Navigator.pop(globalNavigatorKey.currentContext!);
  Navigator.push(
      globalNavigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => songPlayerScreen(ref, playlist, i),
      ));
  print('new song');
}