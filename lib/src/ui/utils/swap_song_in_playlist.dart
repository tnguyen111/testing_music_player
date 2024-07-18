import 'package:just_audio/just_audio.dart';
import '../../models/models.dart';
import '../../services/database/database.dart';

Future<void> swapSongsInPlaylist(Playlist playlist, int oldIndex, int newIndex) async {
  if(playlist == playlistArray[0]){
    List<SongDetails> tempSongList = [];

    await swapSong(0, oldIndex, newIndex);
    IsarHelper().savePlaylist(playlistArray[0]);

    for(int i = 0; i < playlist.songList.length; i++){
      tempSongList.add(toSongDetails((playlist.songList[i] as UriAudioSource).tag));
    }
    await IsarHelper().saveSongList(tempSongList);
    return;
  }

  for (int i = 1; i <= playlistArray.length; i++) {
    if (playlistArray[i] == playlist) {
      await swapSong(i, oldIndex, newIndex);
      IsarHelper().savePlaylist(playlistArray[i]);
      break;
    }
  }
}

Future<void> swapSong(int playlistIndex, int oldIndex, int newIndex) async {
  final String temp = playlistArray[playlistIndex].songNameList.removeAt(oldIndex);
  playlistArray[playlistIndex].songNameList.insert(newIndex, temp);
  try {
    await playlistArray[playlistIndex].songList.move(oldIndex, newIndex);
  } catch(e){
    print(e);
  }
  return;
}