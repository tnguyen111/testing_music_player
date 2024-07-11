import 'package:just_audio/just_audio.dart';

import '../../models/models.dart';
import '../../services/database/database.dart';

void deleteSongFromPlaylist(
    ConcatenatingAudioSource songList, AudioSource song) {
  String songName = (song as UriAudioSource).tag.title;

  if(songList == songArray){
    playlistArray[0].songList.removeAt(
      playlistArray[0].songList.children.indexOf(
        playlistArray[0].songList.children.firstWhere(
              (element) {
            return (element as UriAudioSource).tag.title == songName;
          },
        ),
      ),
    );
    playlistArray[0].songNameList.remove(songName);
    IsarHelper().savePlaylist(playlistArray[0]);
    songArray = playlistArray[0].songList;
    return;
  }

  for (int i = 1; i < playlistArray.length; i++) {
    if (playlistArray[i].songList == songList) {
      print("huh");
      songList.removeAt(
        playlistArray[i].songList.children.indexOf(
              playlistArray[i].songList.children.firstWhere(
                (element) {
                  return (element as UriAudioSource).tag.title == songName;
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
