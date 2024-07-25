import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:testing_music_player/src/services/services.dart';

import '../../models/models.dart';

Future<void> addSongToPlaylist(
    WidgetRef ref, Playlist playlist, AudioSource song) async {
  if (playlist == playlistArray[0]) {
    await playlistArray[0].addSong(song as UriAudioSource);
    playlistArray[0].songNameList.add(song.tag.title);
    await IsarHelper().savePlaylist(playlistArray[0]);
    playlistSwitchState(ref);
    return;
  }

  await playlist.addSong(song as UriAudioSource);

  playlist.songNameList.add(song.tag.title);

  await IsarHelper().savePlaylist(playlist);
  playlistSwitchState(ref);
  return;
}

String addNewSong(List<String> temp) {
  String pathInput = temp[0];
  String directory = temp[1];
  final dir = Directory(directory);
  print(dir.path);
  var files = dir.listSync(recursive: false);
  // get the subdirectories
  print('running');
  for (final f in files) {
    if (f is Directory && !f.path.contains('/storage/emulated/0/Android') && !f.path.contains('/storage/emulated/0/Pictures')) {
      print(f.path);
      var tempFile = File('${f.path}/${basename(File(pathInput).path)}');
      if ( tempFile.existsSync()) {
        print('this: ${tempFile.path}');
        return tempFile.path;
        //files = f.listSync();
      }
      var newFiles = Directory(f.path).listSync(recursive: true);
      for (final i in newFiles) {
        tempFile = File('${i.path}/${basename(File(pathInput).path)}');
        if (tempFile.existsSync()) {
          print('this: ${tempFile.path}');
          return tempFile.path;
          //files = f.listSync();
        }
      }
    }
  }
  print('done');
  return '';
}
