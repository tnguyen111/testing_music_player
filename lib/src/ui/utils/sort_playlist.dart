import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../../models/models.dart';
import '../../services/database/database.dart';

Future<Playlist> sortingPlaylist(Playlist playlist) async {
  playlist.songNameList.sort((a, b) => a.compareTo(b));
  IsarHelper().savePlaylist(playlist);
  String currentName = '';
  Duration currentPos = Duration.zero;

  if(player.audioSource == playlist.songList) {
    currentName = player.sequenceState?.currentSource?.tag.title;
    currentPos = player.position;
  }

  playlist.songList.clear();
  for(int i = 0; i < playlist.songNameList.length; i++){
    SongDetails? existSong = await IsarHelper().getSongFor(playlist.songNameList[i]);
    MediaItem? newMediaItem = existSong?.toMediaItem();
    AudioSource newSong = AudioSource.uri(Uri.parse(existSong!.songPath), tag: newMediaItem);
    playlist.songList.add(newSong);
    if(currentName != '' && currentName == newMediaItem?.title){
      await player.setAudioSource(songArray, initialIndex: i, initialPosition: currentPos);
    }
  }

  return playlist;
}