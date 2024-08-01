import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

import '../../models/models.dart';
import '../../services/services.dart';
import '../ui.dart';

Future<List<File>> importAllSongs(String directory) async {
  List<File> importedResult = [];
  final dir = Directory(directory);
  var files = dir.listSync(recursive: false);

  print('running');
  for (final f in files) {
    if (f is Directory &&
        !f.path.contains('/storage/emulated/0/Android') &&
        !f.path.contains('/storage/emulated/0/Pictures')) {
      var newFiles = Directory(f.path).listSync(recursive: true);
      for (final i in newFiles) {
        if (i is File && isAudio(i.path)) {
          if (i.path.endsWith('mp3') ||
              i.path.endsWith("aac") ||
              i.path.endsWith("flac") ||
              i.path.endsWith("wav") ||
              i.path.endsWith("oog") ||
              i.path.endsWith("opus") ||
              i.path.endsWith("amr") ||
              i.path.endsWith("m4a") ||
              i.path.endsWith("mp4")) {
            print(i.path);
            importedResult.add(i);
          }
        }
      }
    } else if (f is File && isAudio(f.path)) {
      if ((f.path.endsWith('mp3') ||
          f.path.endsWith("aac") ||
          f.path.endsWith("flac") ||
          f.path.endsWith("wav") ||
          f.path.endsWith("oog") ||
          f.path.endsWith("opus") ||
          f.path.endsWith("amr") ||
          f.path.endsWith("m4a") ||
          f.path.endsWith("mp4"))) {
        print(f.path);
        importedResult.add(f);
      }
    }
  }

  return importedResult;
}

Future<void> setupImportedSongs(List<File> songList) async {
  for (File songFile in songList) {
    final metadata = await MetadataRetriever.fromFile(songFile);
    String trackName = metadata.trackName ?? basename(songFile.path);
    String trackArtistNames = metadata.trackArtistNames?.first ?? '';

    String songName = trackName.substring(
        0, (trackName.length <= 50) ? trackName.length : 51);

    if (!(await IsarHelper().songExisted(songName))) {
      String authorName = trackArtistNames.substring(
          0, (trackArtistNames.length <= 50) ? trackArtistNames.length : 51);

      Duration? newDuration = await getDuration(songFile);
      SongDetails newSong = SongDetails(
        songName: songName,
        songAuthor: authorName,
        songDurationData: newDuration.toString(),
        songPath: songFile.path,
      );

      await IsarHelper().saveSong(newSong);
      MediaItem newMediaItem = newSong.toMediaItem();
      AudioSource temp = AudioSource.uri(
        Uri.parse(newSong.songPath),
        tag: newMediaItem,
      );

      await playlistArray[0].addSong(temp as UriAudioSource);
      playlistArray[0].songNameList.add(temp.tag.title);
    }
  }
  await IsarHelper().savePlaylist(playlistArray[0]);
  importingFile.value = false;
  return;
}

bool isAudio(String path) {
  final mimeType = lookupMimeType(path);

  return (mimeType?.startsWith('audio/') ?? false || mimeType == null);
}
