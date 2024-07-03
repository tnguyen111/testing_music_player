


import 'package:just_audio/just_audio.dart';

import '../../models/models.dart';
import '../../services/database/database.dart';

void addSongToPlaylist(ConcatenatingAudioSource songList, AudioSource song){
  for (int i = 0; i < playlistArray.length; i++) {
    if (playlistArray[i].songList == songList) {
      songList.add(song);
      playlistArray[i].songNameList.add((song as UriAudioSource).tag.songName);
      print(playlistArray[i].songNameList.last);
      IsarHelper().savePlaylist(playlistArray[i]);
      break;
    }
  }
}