import 'package:just_audio/just_audio.dart';
import '../../models/models.dart';
import '../../services/database/database.dart';

Future<Playlist> sortingPlaylist(Playlist playlist, String sortType) async {
  String currentName = '';
  Duration currentPos = Duration.zero;
  bool isPlaying = false;

  if (player.audioSource == playlist.songList) {
    currentName = await player.sequenceState?.currentSource?.tag.title ?? "";
    currentPos = player.position;
    if (player.playing) {
      isPlaying = true;
    }
  }

  if (sortType == 'Sort By Artist') {
    final Map<UriAudioSource, String> mappings = {
      for (int i = 0; i < playlist.songNameList.length; i++)
        (playlist.songList[i] as UriAudioSource): playlist.songNameList[i]
    };

    playlist.songList.children.sort((a, b) =>
        ((a as UriAudioSource).tag.artist).compareTo(
            ((b as UriAudioSource).tag.artist)));

    playlist.songNameList_ =
    [
      for(AudioSource song in playlist.songList
          .children) mappings[song as UriAudioSource]!
    ];
  } else if (sortType == 'Sort By Duration') {
    final Map<UriAudioSource, String> mappings = {
      for (int i = 0; i < playlist.songNameList.length; i++)
        (playlist.songList[i] as UriAudioSource): playlist.songNameList[i]
    };

    playlist.songList.children.sort((a, b) =>
        ((a as UriAudioSource).tag.duration).compareTo(
            ((b as UriAudioSource).tag.duration)));

    playlist.songNameList_ =
    [
      for(AudioSource song in playlist.songList
          .children) mappings[song as UriAudioSource]!
    ];
  } else {
    playlist.songList.children.sort((a, b) =>
        ((a as UriAudioSource).tag.title)
            .compareTo((b as UriAudioSource).tag.title));
    playlist.songNameList.sort((a, b) => a.compareTo(b));
  }

  if (currentName != '') {
    try {
      await player.setAudioSource(playlist.songList,
          initialIndex: playlist.songNameList.indexOf(currentName), initialPosition: currentPos);
    } on PlayerInterruptedException {
      // do nothing
      print('expected throw');
    }

    if (isPlaying) {
      player.play();
      player.startVisualizer();
    }
  }

  IsarHelper().savePlaylist(playlist);
  return playlist;
}


