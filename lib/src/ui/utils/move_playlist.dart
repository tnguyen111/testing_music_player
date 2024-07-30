import 'package:testing_music_player/src/config/config.dart';
import '../../models/models.dart';
import '../../services/database/database.dart';

Future<void> movePlaylist(int oldIndex, int newIndex) async {
  playlistArray.move(oldIndex, newIndex);

  for(int i = 0; i < playlistArray.length; i++){
    playlistArray[i].id = i;
  }

  await IsarHelper().savePlaylistList(playlistArray);
  return;
}