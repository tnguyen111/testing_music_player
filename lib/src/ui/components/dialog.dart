import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:testing_api_twitter/src/models/models.dart';
import 'package:testing_api_twitter/src/services/services.dart';

showDataAlert(BuildContext context, WidgetRef ref, List<Song> songList) {
  String songName = '';
  String authorName = '';
  String fileName = '';
  File songFile = File('');

  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        content: SizedBox(
          height: 400,
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
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
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
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Author Name',
                        labelText: 'New Author Name'),
                    onChanged: (value) {
                      authorName = value;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 60,
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['mp3', 'wav'],
                      );
                      if (result != null) {
                        String pathInput = result.files.single.path!;
                        songFile = File(pathInput);
                        fileName = basename(songFile.path);
                        playlistSwitchState(ref);
                        print(fileName);
                      }
                    },
                    child: const Text(
                      textScaler: TextScaler.linear(1.2),
                      "Upload Your Song",
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    textScaler: const TextScaler.linear(0.5),
                    (fileName == '') ? '' : '"$fileName" uploaded',
                  ),
                ),
                const SizedBox(),
                Container(
                  width: double.infinity,
                  height: 60,
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (songFile.path.isNotEmpty && songName != '') {
                        if (songList != songArray) {
                          songList.add(
                            Song(
                              songFile: songFile,
                              songName: songName,
                              authorName: authorName,
                              duration: const Duration(seconds: 79),
                            ),
                          );
                        }
                        songArray.add(
                          Song(
                            songFile: songFile,
                            songName: songName,
                            authorName: authorName,
                            duration: const Duration(seconds: 79),
                          ),
                        );
                        playlistSwitchState(ref);
                        Navigator.of(context).pop();
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
