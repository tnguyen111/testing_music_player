


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:testing_music_player/src/services/services.dart';
import '../../models/models.dart';
import '../../services/database/database.dart';

Future<void> editSong(WidgetRef ref, UriAudioSource song, String newTitle, String newArtist) async {
  SongDetails editedSong = SongDetails(
    songName: newTitle,
    songAuthor: newArtist,
    songDurationData: song.tag.duration.toString(),
    songPath: song.tag.id,
  );

  MediaItem newMediaItem = editedSong.toMediaItem();

  AudioSource temp = AudioSource.uri(
    Uri.parse(editedSong.songPath),
    tag: newMediaItem,
  );

  await IsarHelper().editSong(song.tag.title, newTitle, newArtist);

  for(Playlist playlist in playlistArray){
    if(playlist.songNameList.contains(song.tag.title)){
      int index = playlist.songNameList.indexOf(song.tag.title);
      playlist.songNameList[index] = newTitle;
      await playlist.alterSong(index, temp as UriAudioSource);
      await IsarHelper().savePlaylist(playlist);
    }
  }

  playlistSwitchState(ref);
  return;
}