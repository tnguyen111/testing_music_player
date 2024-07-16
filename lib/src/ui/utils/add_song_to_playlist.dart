import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:testing_music_player/src/services/services.dart';

import '../../models/models.dart';
import '../../services/database/database.dart';

Future<void> addSongToPlaylist(WidgetRef ref, Playlist playlist, AudioSource song) async {

  if (playlist == playlistArray[0]) {
    print("songArray add");
    await playlistArray[0].addSong(song as UriAudioSource);
    playlistArray[0].songNameList.add(song.tag.title);
    await IsarHelper().savePlaylist(playlistArray[0]);
    playlistSwitchState(ref);
    return;
  }

  await playlist.addSong(song as UriAudioSource);

  playlist.songNameList.add(song.tag.title);

  await IsarHelper().savePlaylist(playlist);
  playlistSwitchState(ref);
  return;
}
