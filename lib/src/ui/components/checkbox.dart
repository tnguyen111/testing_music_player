import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:testing_music_player/src/models/models.dart';
import '../../services/services.dart';
import '../utils/utils.dart';

Widget listCheckbox(
    Playlist playlist, AudioSource song, WidgetRef ref) {
  String songName = (song as UriAudioSource).tag.songName;
  bool value = playlist.songNameList.contains(songName);
  return Checkbox(
    value: value,
    overlayColor: WidgetStatePropertyAll(currentThemeSmallText(ref).color),
    activeColor: currentThemeSmallText(ref).color,
    onChanged: (value) {
      if (value!) {
        addSongToPlaylist(playlist.songList, song);
        playlistSwitchState(ref);
      } else {
        deleteSongFromPlaylist(playlist.songList, song);
        playlistSwitchState(ref);
      }
      print(playlist.songList);
      print(songArray.children);
    },
  );
}
