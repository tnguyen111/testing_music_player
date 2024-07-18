import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:testing_music_player/src/services/services.dart';
import '../../models/models.dart';

Future<Playlist> sortingPlaylist(WidgetRef ref, Playlist playlist, String sortType) async {
  bool changed = false;
  String currentName = '';
  Duration currentPos = Duration.zero;

  if (player.audioSource == playlist.songList) {
    print('same source');
    changed = true;
    currentName = player.sequenceState?.currentSource?.tag.title ?? "";
    currentPos = player.position;
  }

  final Map<UriAudioSource, String> mappings = {
    for (int i = 0; i < playlist.songNameList.length; i++)
      (playlist.songList[i] as UriAudioSource): playlist.songNameList[i]
  };

  switch (sortType) {
    case ('Sort By Artist'):
      playlist.songList.children.sort((a, b) =>
          ((a as UriAudioSource).tag.artist)
              .compareTo(((b as UriAudioSource).tag.artist)));
      break;
    case ('Sort By Duration'):
      playlist.songList.children.sort((a, b) =>
          ((a as UriAudioSource).tag.duration)
              .compareTo(((b as UriAudioSource).tag.duration)));
      break;
    case ('Sort By Name'):
      playlist.songList.children.sort((a, b) =>
          ((a as UriAudioSource).tag.title)
              .compareTo(((b as UriAudioSource).tag.title)));
      break;
    default:
      throw UnsupportedError('No Sort Available');
  }

  playlist.songNameList_ = [
    for (AudioSource song in playlist.songList.children)
      mappings[song as UriAudioSource]!
  ];

  await playlist.clearSong();
  await IsarHelper().savePlaylist(playlist);
  playlist = await IsarHelper().setPlaylist(playlist);

  if (changed) {
    await player.setAudioSource(playlist.songList,
        initialIndex: playlist.songNameList.indexOf(currentName),
        initialPosition: currentPos);
  }
  playlistSwitchState(ref);

  return playlist;
}
