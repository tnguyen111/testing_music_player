
import 'package:just_audio/just_audio.dart';

import '../../models/models.dart';
import '../../services/database/database.dart';

void addSongToPlaylist(ConcatenatingAudioSource songList, AudioSource song){
  if(songList == songArray){
    playlistArray[0].addSong(song);
    playlistArray[0].songNameList.add((song as UriAudioSource).tag.title);
    IsarHelper().savePlaylist(playlistArray[0]);
    songArray = playlistArray[0].songList;
    return;
  }

  for (int i = 1; i <= playlistArray.length; i++) {
    if (playlistArray[i].songList == songList) {
      songList.add(song);
      playlistArray[i].songNameList.add((song as UriAudioSource).tag.title);
      IsarHelper().savePlaylist(playlistArray[i]);
      break;
    }
  }
}