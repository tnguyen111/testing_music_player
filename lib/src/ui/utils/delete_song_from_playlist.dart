import 'package:just_audio/just_audio.dart';

import '../../models/models.dart';
import '../../services/database/database.dart';

void deleteSongFromPlaylist(
    ConcatenatingAudioSource playlist, AudioSource song) {
  String songName = (song as UriAudioSource).tag.songName;
  for (int i = 0; i < playlistArray.length; i++) {
    if (playlistArray[i].songList == playlist) {
      print("huh");
      playlist.removeAt(
        playlistArray[i].songList.children.indexOf(
              playlistArray[i].songList.children.firstWhere(
                (element) {
                  return (element as UriAudioSource).tag.songName == songName;
                },
              ),
            ),
      );
      playlistArray[i].songNameList.remove(songName);
      IsarHelper().savePlaylist(playlistArray[i]);
      break;
    }
  }
}
