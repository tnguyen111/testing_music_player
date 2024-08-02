import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:testing_music_player/src/models/models.dart';
import '../../../main.dart';
import '../../services/services.dart';
import '../utils/utils.dart';

Widget playlistCheckbox(Playlist playlist, AudioSource song, WidgetRef ref) {
  String songName = (song as UriAudioSource).tag.title;
  bool value = playlist.songNameList.contains(songName);
  return Checkbox(
    value: value,
    //overlayColor: WidgetStatePropertyAll(currentThemeSmallText(ref).color),
    //activeColor: currentThemeSmallText(ref).color,
    onChanged: (value) async {
      try {
        if (value!) {
          await addSongToPlaylist(ref, playlist, song);
        } else {
          await deleteSongFromPlaylist(ref, playlist, song);
        }
      } catch(e){
       print(e);
      }
      
      playlistSwitchState(ref);
    },
  );
}

Widget songCheckbox(Playlist playlist, AudioSource song, WidgetRef ref) {
  String songName = (song as UriAudioSource).tag.title;
  bool value = playlist.songNameList.contains(songName);
  return Checkbox(
    value: value,
    onChanged: (value) async {
      try {
        if (value!) {
          await addSongToPlaylist(ref, playlist, song);
        } else {
          await deleteSongFromPlaylist(ref, playlist, song);
        }
      } catch(e) {
        print(e);
      }
      playlistSwitchState(ref);
    },
  );
}

