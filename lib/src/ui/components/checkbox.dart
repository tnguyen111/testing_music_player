import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:testing_music_player/src/models/models.dart';
import '../../services/services.dart';
import '../utils/utils.dart';

Widget listCheckbox(
    ConcatenatingAudioSource playlist, AudioSource song, WidgetRef ref) {
  bool value = playlist.children.contains(song);
  return Checkbox(
    value: value,
    overlayColor: WidgetStatePropertyAll(currentThemeSmallText(ref).color),
    activeColor: currentThemeSmallText(ref).color,
    onChanged: (value) {
      if (value!) {
        addSongToPlaylist(playlist, song);
      } else {
        int index = playlist.children.indexOf(song);
        String songName = (song as UriAudioSource).tag.songName;
        deleteSongFromPlaylist(playlist, index, songName);
      }
      print(playlist.children);
      print(songArray.children);
      playlistSwitchState(ref);
    },
  );
}
