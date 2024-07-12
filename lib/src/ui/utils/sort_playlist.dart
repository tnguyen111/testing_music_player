import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../../models/models.dart';
import '../../services/database/database.dart';

Future<Playlist> sortingPlaylist(Playlist playlist) async {
  final List<SongDetails> newSongList = await IsarHelper().getSongList();
  String currentName = '';
  Duration currentPos = Duration.zero;
  bool isPlaying = false;
  playlist.songNameList.clear();

  if(player.audioSource == songArray) {
    currentName = player.sequenceState?.currentSource?.tag.title;
    currentPos = player.position;
    if(player.playing){
      isPlaying = true;
    }
    await player.stop();
  }

  await songArray.clear();

  for (int i = 0; i < newSongList.length; i++) {
    MediaItem newMediaItem = newSongList[i].toMediaItem();
    AudioSource newSong =
    AudioSource.uri(Uri.parse(newSongList[i].songPath), tag: newMediaItem);
    await songArray.add(newSong);

    if(currentName != '' && currentName == newMediaItem.title){
      await player.setAudioSource(songArray, initialIndex: i, initialPosition: currentPos);
      if(isPlaying){
        player.play();
        player.startVisualizer();
      }
    }

    if(playlist.songNameList.length < newSongList.length){
      playlist.songNameList.add(newMediaItem.title);
      IsarHelper().savePlaylist(playlist);
    }
  }
  playlist.songList_ = songArray;

  return playlist;
}