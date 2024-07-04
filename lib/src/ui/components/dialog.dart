import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:testing_music_player/src/models/models.dart';
import 'package:testing_music_player/src/services/services.dart';
import 'package:mime/mime.dart';
import '../ui.dart';

showDataAlert(
    BuildContext context, WidgetRef ref, ConcatenatingAudioSource songList) {
  String songName = '';
  String authorName = '';
  String fileName = '';
  String error = '';
  File songFile = File('');

  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        content: SizedBox(
          height: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    "Add New Song",
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLength: 18,
                    onTap: () { error = '';
                    playlistSwitchState(ref);
                    },
                    decoration: InputDecoration(
                        errorText: (error != '') ? error: null,
                        border: const OutlineInputBorder(),
                        hintText: 'Enter Song Name',
                        labelText: 'New Song Name'),
                    onChanged: (value) {
                      songName = value;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLength: 24,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Author Name',
                        labelText: 'New Author Name'),
                    onChanged: (value) {
                      authorName = value;
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: [
                          'mp3',
                          'wav',
                          'pcm',
                          'aiff',
                          'aac',
                          'wma',
                          'alac',
                          'flac',
                          'ogc'
                        ],
                      );
                      if (result != null) {
                        String pathInput = result.files.single.path!;
                        if (!lookupMimeType(pathInput)!.startsWith("audio")) {
                          fileName = "Invalid File";
                        } else {
                          songFile = File(pathInput);
                          fileName = basename(songFile.path);
                          playlistSwitchState(ref);
                        }
                      }
                    },
                    child: const Text(
                      textScaler: TextScaler.linear(1.2),
                      "Upload Your File",
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    textScaler: const TextScaler.linear(0.5),
                    (fileName == '') ? '' : '"$fileName" Uploaded',
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if(await IsarHelper().songExisted(songName)){
                        error = "Name's Already Taken!";
                        playlistSwitchState(ref);
                        return;
                      }
                      if (songFile.path.isNotEmpty &&
                          songName != '' &&
                          fileName != "Invalid File") {
                        Duration? newDuration = await getDuration(songFile);
                        SongDetails newSong = SongDetails(
                          songName: songName,
                          songAuthor: authorName,
                          songDurationData: newDuration.toString(),
                          songPath: songFile.path,
                        );
                        IsarHelper().saveSong(newSong);
                        AudioSource temp = AudioSource.uri(
                          Uri.parse(newSong.songPath),
                          tag: newSong,
                        );
                        if (songList != songArray) {
                          addSongToPlaylist(songList,temp);
                        }
                        songArray.add(
                          temp,
                        );
                        Navigator.of(context).pop();
                        playlistSwitchState(ref);
                      }
                    },
                    child: const Text(
                      textScaler: TextScaler.linear(1.2),
                      "Submit",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

editPlaylistNameDialog(BuildContext context, WidgetRef ref, Playlist playlist) {
  String playlistName = playlist.playlistName;
  TextEditingController controller = TextEditingController(text: playlistName);

  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        content: SizedBox(
          height: 300,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    "Change Playlist Name",
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Playlist Name',
                        labelText: 'New Playlist Name'),
                    onChanged: (value) {
                      playlistName = value;
                    },
                    onSubmitted: (value) {
                      playlistName = value;
                      IsarHelper().savePlaylist(playlist);
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 60,
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      playlist.setName(playlistName);
                      IsarHelper().savePlaylist(playlist);
                      playlistSwitchState(ref);
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      textScaler: TextScaler.linear(1.2),
                      "Submit",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
