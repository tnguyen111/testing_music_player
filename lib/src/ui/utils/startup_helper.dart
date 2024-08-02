import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_music_player/src/models/global_list.dart';
import '../../services/services.dart';
import '../ui.dart';

Future<bool> setupMode(WidgetRef ref) async {
  print('setting up');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('lightMode') ?? false) {
    modeSwitchState(ref);
  }
  songDeleteConfirmation = prefs.getBool('songDeleteConfirmation') ?? true;
  playlistDeleteConfirmation =
      prefs.getBool('playlistDeleteConfirmation') ?? true;

  if ((prefs.getBool('notImported') ?? true) && await Permission.audio.isGranted) {
    prefs.setBool('notImported', false);
    importingFile.value = true;
    List<File> allFiles = [];
    for (String directory
        in await ExternalPath.getExternalStorageDirectories()) {
      allFiles = await compute<String, List<File>>(importAllSongs, directory);
    }
    print(allFiles.length);
    setupImportedSongs(allFiles);
  }

  print('started');
  return true;
}

void changeSongConfirmation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('songDeleteConfirmation', songDeleteConfirmation);
  return;
}

void changePlaylistConfirmation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('playlistDeleteConfirmation', playlistDeleteConfirmation);
  return;
}
