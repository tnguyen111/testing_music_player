import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../models/models.dart';
import '../../services/services.dart';

Future<void> deleteSongFromPlaylist(WidgetRef ref, Playlist playlist, AudioSource song) async {
  String songName = (song as UriAudioSource).tag.title;

  if (playlist == playlistArray[0]) {
    print("songArray remove");
    await playlistArray[0]
        .removeSong(playlistArray[0].songNameList.indexOf(songName));
    playlistArray[0].songNameList.remove(songName);
    IsarHelper().savePlaylist(playlistArray[0]);
    playlistSwitchState(ref);
    return;
  }

  print("huh");
  await playlist.removeSong(playlist.songNameList.indexOf(songName));
  playlist.songNameList.remove(songName);
  IsarHelper().savePlaylist(playlist);
  playlistSwitchState(ref);
  return;
}
