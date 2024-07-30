import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../models/models.dart';
import '../../services/services.dart';

Future<void> deleteSongFromPlaylist(WidgetRef ref, Playlist playlist, AudioSource song) async {
  String songName = (song as UriAudioSource).tag.title;

  if (playlist == playlistArray[0]) {
    playlistArray[0]
        .removeSong(playlistArray[0].songNameList.indexOf(songName));
    playlistArray[0].songNameList.remove(songName);
    IsarHelper().savePlaylist(playlistArray[0]);
    playlistSwitchState(ref);
    return;
  }

  playlist.removeSong(playlist.songNameList.indexOf(songName));
  playlist.songNameList.remove(songName);
  IsarHelper().savePlaylist(playlist);
  playlistSwitchState(ref);
  return;
}

void clearSongFromPlaylist(WidgetRef ref) {
  player.stop();
  for (int i = 0; i < playlistArray.length; i++) {
    playlistArray[i].songList.clear();
    playlistArray[i].songNameList.clear();
    IsarHelper().savePlaylist(playlistArray[i]);
  }

  IsarHelper().clearSongList();
  playlistSwitchState(ref);
  return;
}
