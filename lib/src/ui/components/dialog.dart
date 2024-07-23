import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:testing_music_player/src/models/models.dart';
import 'package:testing_music_player/src/services/services.dart';
import '../../../main.dart';
import '../../config/config.dart';
import '../ui.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

showDataAlert(BuildContext context, WidgetRef ref, Playlist playlist) {
  bool loading = false;
  String songName = '';
  String? authorName = '';
  String fileName = '';
  String error = '';
  File songFile = File('');
  TextEditingController songNameController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
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
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Center(
                    child: headerText(
                      ref,
                      "Add New Song",
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: Theme.of(ContextKey.navKey.currentContext!)
                        .textTheme
                        .bodyLarge
                        ?.apply(
                          color: currentThemeOnSurface(ref),
                        ),
                    maxLength: 50,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp(noEmoji),
                      ),
                    ],
                    controller: songNameController,
                    onTap: () {
                      error = '';
                      playlistSwitchState(ref);
                    },
                    decoration: InputDecoration(
                        errorText: (error != '') ? error : null,
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
                    style: Theme.of(ContextKey.navKey.currentContext!)
                        .textTheme
                        .bodyLarge
                        ?.apply(
                          color: currentThemeOnSurface(ref),
                        ),
                    maxLength: 50,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp(noEmoji),
                      ),
                    ],
                    controller: authorNameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Artist Name',
                        labelText: 'New Artist Name'),
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
                      try {
                        loading = true;
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.audio,
                        );
                        print(result?.paths);
                        if (result != null) {
                          String pathInput = result.files.single.path!;
                          String directPath = result.files.single.identifier!;
                          print(
                              'direct path: ${result.files.single.identifier}');
                          print('path: $pathInput');
                          if (!pathInput.endsWith('mp3') &&
                              !pathInput.endsWith("aac") &&
                              !pathInput.endsWith("flac") &&
                              !pathInput.endsWith("wav") &&
                              !pathInput.endsWith("oog") &&
                              !pathInput.endsWith("opus") &&
                              !pathInput.endsWith("amr") &&
                              !pathInput.endsWith("m4a") &&
                              !pathInput.endsWith("mp4")) {
                            fileName = "Invalid File";
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    content: SizedBox(
                                      height: 200,
                                      child: Text(
                                          style: Theme.of(ContextKey
                                                  .navKey.currentContext!)
                                              .textTheme
                                              .titleLarge
                                              ?.apply(
                                                color:
                                                    currentThemeOnSurface(ref),
                                              ),
                                          textAlign: TextAlign.center,
                                          '''Wrong File Format
                                          Only These File Formats Can Be Used:
                                          aac, amr, flac, mp3, mp4, m4a, wav, oog, opus'''),
                                    ),
                                  );
                                });
                            loading = false;
                            playlistSwitchState(ref);
                            return;
                          }
                          songFile = File(directPath);
                          fileName = basename(File(pathInput).path);
                          final metadata =
                              await MetadataRetriever.fromFile(File(pathInput));
                          String? trackName = metadata.trackName;
                          String? trackArtistNames =
                              metadata.trackArtistNames?.first;
                          songName = trackName?.substring(
                                  0,
                                  (trackName.length <= 50)
                                      ? trackName.length
                                      : 51) ??
                              songName;
                          authorName = trackArtistNames?.substring(
                                  0,
                                  (trackArtistNames.length <= 50)
                                      ? trackArtistNames.length
                                      : 51) ??
                              authorName;
                          songNameController.text = songName;
                          authorNameController.text = authorName!;
                          loading = false;
                          playlistSwitchState(ref);
                        }
                      } catch (e) {
                        print(e);
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
                    style: Theme.of(ContextKey.navKey.currentContext!)
                        .textTheme
                        .bodySmall
                        ?.apply(
                          color: currentThemeOnSurface(ref),
                        ),
                    (fileName == '') ? '' : '"$fileName" Uploaded',
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  padding: const EdgeInsets.all(kXSPadding),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (await IsarHelper().songExisted(songName)) {
                        error = "Name's Already Taken!";
                        playlistSwitchState(ref);
                        return;
                      }
                      if (songFile.path.isNotEmpty &&
                          songName != '' &&
                          fileName != "Invalid File" &&
                          !loading) {
                        loading = true;
                        Duration? newDuration = await getDuration(songFile);
                        if (loading) {
                          SongDetails newSong = SongDetails(
                            songName: songName,
                            songAuthor: authorName!,
                            songDurationData: newDuration.toString(),
                            songPath: songFile.path,
                          );
                          await IsarHelper().saveSong(newSong);
                          MediaItem newMediaItem = newSong.toMediaItem();
                          AudioSource temp = AudioSource.uri(
                            Uri.parse(newSong.songPath),
                            tag: newMediaItem,
                          );
                          if (playlist != playlistArray[0]) {
                            print('added to playlist');
                            await addSongToPlaylist(ref, playlist, temp);
                          }
                          await addSongToPlaylist(ref, playlistArray[0], temp);
                          if (loading) {
                            Navigator.of(context).pop();
                            playlistSwitchState(ref);
                          }
                        }
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
          height: 240,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Text(
                    style: Theme.of(ContextKey.navKey.currentContext!)
                        .textTheme
                        .titleLarge
                        ?.apply(
                          color: currentThemeOnSurface(ref),
                        ),
                    "Change Playlist Name",
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(kXSPadding),
                  child: TextField(
                    style: Theme.of(ContextKey.navKey.currentContext!)
                        .textTheme
                        .bodyLarge
                        ?.apply(
                          color: currentThemeOnSurface(ref),
                        ),
                    maxLength: 50,
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
                const SizedBox(height: kMediumPadding),
                Container(
                  width: double.infinity,
                  height: 60,
                  padding: const EdgeInsets.all(kXSPadding),
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
