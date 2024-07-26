import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:testing_music_player/src/models/models.dart';
import 'package:testing_music_player/src/services/services.dart';
import '../../../main.dart';
import '../../config/config.dart';
import '../ui.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path_provider/path_provider.dart';
import 'package:external_path/external_path.dart';

addingSongsDialog(BuildContext context, WidgetRef ref, Playlist playlist) {
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
                        playlistSwitchState(ref);
                        if (result != null) {
                          fileName = '';
                          String pathInput = result.files.single.path!;
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
                          for (String directory in await ExternalPath
                              .getExternalStorageDirectories()) {
                            List<String> inputList = [pathInput, directory];
                            String filePath =
                                await compute<List<String>, String>(
                                    addNewSong, inputList);
                            if (filePath != '') {
                              songFile = File(filePath);
                            }
                          }
                          fileName = basename(songFile.path);
                          FilePicker.platform.clearTemporaryFiles();
                          final metadata =
                              await MetadataRetriever.fromFile(songFile);
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
                  child: (fileName != '')
                      ? Text(
                          style: Theme.of(ContextKey.navKey.currentContext!)
                              .textTheme
                              .bodySmall
                              ?.apply(
                                color: currentThemeOnSurface(ref),
                              ),
                          '"$fileName" Uploaded',
                        )
                      : (loading)
                          ? CircularProgressIndicator()
                          : Container(),
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

deletingSongsDialog(BuildContext context, WidgetRef ref) {
  return AlertDialog(
    titlePadding: const EdgeInsets.only(
        top: kLargePadding,
        left: kLargePadding,
        right: kLargePadding,
        bottom: kDefaultSmallPadding),
    contentPadding:
        const EdgeInsets.only(left: kLargePadding, right: kLargePadding),
    actionsPadding: const EdgeInsets.all(kLargePadding),
    titleTextStyle: Theme.of(ContextKey.navKey.currentContext!)
        .textTheme
        .titleLarge
        ?.apply(color: currentThemeOnSurface(ref)),
    contentTextStyle: Theme.of(ContextKey.navKey.currentContext!)
        .textTheme
        .bodyMedium
        ?.apply(color: currentThemeOnSurfaceVar(ref)),
    backgroundColor: currentThemeSurfaceContainerHigh(ref),
    title: const Text('Delete Selected Song?'),
    content: const Text(
        'Song will be permanently removed from your song list and all playlists'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: alertActionText(ref, 'Cancel'),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, true),
        child: alertActionText(ref, 'Delete'),
      )
    ],
  );
}

editPlaylistNameDialog(WidgetRef ref, Playlist playlist) {
  String playlistName = playlist.playlistName;
  TextEditingController controller = TextEditingController(text: playlistName);

  showDialog(
    context: ContextKey.navKey.currentContext!,
    builder: (_) {
      return AlertDialog(
        titlePadding: const EdgeInsets.only(
            top: kLargePadding,
            left: kLargePadding,
            right: kLargePadding,
            bottom: kDefaultSmallPadding),
        contentPadding: const EdgeInsets.only(
            left: kLargePadding, right: kLargePadding, bottom: kLargePadding),
        actionsPadding: const EdgeInsets.only(
            left: kLargePadding, bottom: kLargePadding, right: kLargePadding),
        titleTextStyle: Theme.of(ContextKey.navKey.currentContext!)
            .textTheme
            .titleLarge
            ?.apply(color: currentThemeOnSurface(ref)),
        contentTextStyle: Theme.of(ContextKey.navKey.currentContext!)
            .textTheme
            .bodyMedium
            ?.apply(color: currentThemeOnSurfaceVar(ref)),
        backgroundColor: currentThemeSurfaceContainerHigh(ref),
        title: const Text("Change Playlist Name"),
        content: TextField(
          style: Theme.of(ContextKey.navKey.currentContext!)
              .textTheme
              .bodyLarge
              ?.apply(
                color: currentThemeOnSurface(ref),
              ),
          maxLength: 30,
          controller: controller,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Playlist Name',
              labelText: 'New Playlist Name'),
          onTap: () {
            if (controller.value.text ==
                "Name's Taken. Choose a different name!") {
              controller.value = TextEditingValue(text: playlistName);
            }
          },
          onChanged: (value) {
            if (controller.value.text == "Name's Taken. Choose a differe") {
              controller.value = TextEditingValue(text: playlistName);
            }
            playlistName = value;
          },
          onSubmitted: (value) async {
            if (playlistName.isNotEmpty) {
              if (await IsarHelper().playlistExisted(playlistName)) {
                controller.value = const TextEditingValue(
                    text: "Name's Taken. Choose a different name!");
                return;
              } else if (playlistName.isNotEmpty) {
                playlist.setName(playlistName);
                IsarHelper().savePlaylist(playlist);
                playlistSwitchState(ref);
                Navigator.of(ContextKey.navKey.currentContext!).pop();
              }
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (playlistName.isNotEmpty) {
                if (await IsarHelper().playlistExisted(playlistName)) {
                  controller.value = const TextEditingValue(
                      text: "Name's Taken. Choose a different name!");
                  return;
                } else {
                  playlist.setName(playlistName);
                  IsarHelper().savePlaylist(playlist);
                  playlistSwitchState(ref);
                  Navigator.of(ContextKey.navKey.currentContext!).pop();
                }
              }
            },
            child: alertActionText(
              ref,
              "Submit",
            ),
          ),
        ],
      );
    },
  );
}

deletePlaylistDialog(WidgetRef ref, Playlist playlist) {
  showDialog(
      context: ContextKey.navKey.currentContext!,
      builder: (_) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(
              top: kLargePadding,
              left: kLargePadding,
              right: kLargePadding,
              bottom: kDefaultSmallPadding),
          contentPadding:
              const EdgeInsets.only(left: kLargePadding, right: kLargePadding),
          actionsPadding: const EdgeInsets.all(kLargePadding),
          titleTextStyle: Theme.of(ContextKey.navKey.currentContext!)
              .textTheme
              .titleLarge
              ?.apply(color: currentThemeOnSurface(ref)),
          contentTextStyle: Theme.of(ContextKey.navKey.currentContext!)
              .textTheme
              .bodyMedium
              ?.apply(color: currentThemeOnSurfaceVar(ref)),
          backgroundColor: currentThemeSurfaceContainerHigh(ref),
          title: const Text('Delete Selected Playlist?'),
          content: const Text(
              'Playlist will be permanently removed from your playlists list.'),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(ContextKey.navKey.currentContext!, false),
              child: alertActionText(ref, 'Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(ContextKey.navKey.currentContext!, true);
                IsarHelper().deletePlaylistFor(playlist.playlistName);
                playlistArray.remove(playlist);
                Navigator.pop(ContextKey.navKey.currentContext!, true);
                playlistSwitchState(ref);
              },
              child: alertActionText(ref, 'Delete'),
            )
          ],
        );
      });
}

showRationaleDialog(WidgetRef ref) {
  showDialog(
    context: ContextKey.navKey.currentContext!,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        titlePadding: const EdgeInsets.only(
            top: kLargePadding,
            left: kLargePadding,
            right: kLargePadding,
            bottom: kDefaultSmallPadding),
        contentPadding: const EdgeInsets.only(
            left: kLargePadding, right: kLargePadding, bottom: kLargePadding),
        actionsPadding: const EdgeInsets.only(
            left: kLargePadding, bottom: kLargePadding, right: kLargePadding),
        titleTextStyle: Theme.of(ContextKey.navKey.currentContext!)
            .textTheme
            .titleLarge
            ?.apply(color: currentThemeOnSurface(ref)),
        contentTextStyle: Theme.of(ContextKey.navKey.currentContext!)
            .textTheme
            .bodyMedium
            ?.apply(color: currentThemeOnSurfaceVar(ref)),
        backgroundColor: currentThemeSurfaceContainerHigh(ref),
        title: const Text('Audio Permission Required'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Why is this permission required?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: kLargePadding),
              child: Text(
                  'This app relies on accessing your audio files to function properly, and without audio permission, this app will simply not work.'),
            ),
            Text(
              'Do we collect your private data?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: kLargePadding),
              child: Text(
                  'We do not collect any of your private data under any circumstances. All files are processed and used locally.'),
            ),
            Text(
              'What about other permissions?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
                "Microphone permission is not required, but is recommended for the best performance. It is used to listen to currently playing audio files and create waveforms."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (await Permission.audio.isGranted) {
                Navigator.pop(ContextKey.navKey.currentContext!, false);
              } else {
                exit(1);
              }
            },
            child: alertActionText(ref, 'Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (await Permission.audio.isGranted) {
                Navigator.pop(ContextKey.navKey.currentContext!, false);
              } else {
                await openAppSettings();
              }
            },
            child: alertActionText(ref, 'Ok'),
          )
        ],
      );
    },
  );
}
