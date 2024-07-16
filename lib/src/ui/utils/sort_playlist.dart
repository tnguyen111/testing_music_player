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
  for(int i = 0; i < playlistArray.length; i++) {
    if (playlist == playlistArray[i]) {
      print('bruh: $i');
    }
  }
  if (player.audioSource == playlist.songList) {
    currentName = await player.sequenceState?.currentSource?.tag.title ?? "";
    currentPos = player.position;
    if (player.playing) {
      isPlaying = true;
    }
    await player.stop();
  }

  await playlist.songList.clear();

  for (int i = 0; i < newSongList.length; i++) {
    MediaItem newMediaItem = newSongList[i].toMediaItem();
    AudioSource newSong =
        AudioSource.uri(Uri.parse(newSongList[i].songPath), tag: newMediaItem);

    await playlist.addSong(newSong as UriAudioSource);
    print("name: ${newSong.tag.title}");

    if (currentName != '' && currentName == newMediaItem.title) {
      try {
        await player.setAudioSource(playlist.songList,
            initialIndex: i, initialPosition: currentPos);
      } on PlayerInterruptedException {
        // do nothing
        print('expected throw');
      }

      if (isPlaying) {
        player.play();
        player.startVisualizer();
      }
    }

    if (playlist.songNameList.length < newSongList.length) {
      playlist.songNameList.add(newMediaItem.title);
      IsarHelper().savePlaylist(playlist);
    }
  }


  return playlist;
}
