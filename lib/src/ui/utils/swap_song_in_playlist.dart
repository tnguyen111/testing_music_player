import 'package:just_audio/just_audio.dart';
import '../../models/models.dart';
import '../../services/database/database.dart';

Future<void> swapSongsInPlaylist(ConcatenatingAudioSource songList, int oldIndex, int newIndex) async {
  if(songList == songArray){
    List<SongDetails> tempSongList = [];
    await swapSong(0, oldIndex, newIndex);
    songArray = playlistArray[0].songList;
    for(int i = 0; i < songList.length; i++){
      tempSongList.add(toSongDetails((songList[i] as UriAudioSource).tag));
    }
    IsarHelper().savePlaylist(playlistArray[0]);
    IsarHelper().saveSongList(tempSongList);
    return;
  }

  for (int i = 1; i <= playlistArray.length; i++) {
    if (playlistArray[i].songList == songList) {
      await swapSong(i, oldIndex, newIndex);
      IsarHelper().savePlaylist(playlistArray[i]);
      break;
    }
  }
}

Future<void> swapSong(int playlistIndex, int oldIndex, int newIndex) async {
  final String temp = playlistArray[playlistIndex].songNameList.removeAt(oldIndex);
  playlistArray[playlistIndex].songNameList.insert(newIndex, temp);
  await playlistArray[playlistIndex].songList.move(oldIndex, newIndex);
  return;
}