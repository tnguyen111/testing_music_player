

import 'package:just_audio/just_audio.dart';

import '../../models/models.dart';
import '../../services/database/database.dart';

void deleteSongFromPlaylist(ConcatenatingAudioSource playlist, int index, String songName){
  for (int i = 0; i < playlistArray.length; i++) {
    if (playlistArray[i].songList == playlist) {
      playlist.removeAt(index);
      playlistArray[i]
          .songNameList
          .remove(songName);
      IsarHelper().savePlaylist(playlistArray[i]);
      break;
    }
  }
}