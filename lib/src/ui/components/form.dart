import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_api_twitter/src/models/models.dart';
import 'package:testing_api_twitter/src/ui/themes/source_colors.dart';
import '../../../main.dart';
import '../../services/services.dart';
import '../themes/text_theme.dart';
import '../../models/models.dart';

Widget playlistForm(WidgetRef ref) {
  String playlistName = '';
  Playlist temp = Playlist(playlistName: '');
  Uint8List imageInput;

  return Center(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['jpg', 'jpeg', 'png', 'jfif'],
              );
              if (result != null) {
                String pathInput = result.files.single.path!;
                File file = File(pathInput);
                imageInput = file.readAsBytesSync();
                temp.setImage(
                  Image.memory(
                    imageInput,
                    fit: BoxFit.fill,
                  ), imageInput,
                );
              } else {
                // User canceled the picker
              }
            },
            child: SizedBox(
              width: 300,
              height: 300,
              child: temp.playlistImage,
            ),
          ),
          const SizedBox(height: 50),
          Form(
            child: Column(
              children: [
                TextField(
                  obscureText: false,
                  maxLength: 24,
                  decoration: const InputDecoration(
                    hintText: 'Playlist Name',
                    constraints: BoxConstraints(maxWidth: 350),
                    label: Text('Playlist Name'),
                  ),
                  onChanged: (String value) async {
                    playlistName = value;
                  },
                  onSubmitted: (String value) async {
                    if (playlistName != '') {
                      playlistName = value;
                      temp.setName(playlistName);
                      playlistArray.add(temp);
                      playlistSwitchState(ref);
                      Navigator.pop(globalNavigatorKey.currentContext!);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ButtonStyle(
      
              overlayColor: WidgetStatePropertyAll(
                modeReadState(ref) ? darkThemeSub() : lightThemeSub(),
              ),
              backgroundColor: WidgetStatePropertyAll(
                modeReadState(ref) ? lightThemeSub() : darkThemeSub(),
              ),
            ),
            onPressed: () {
              if (playlistName != '') {
                temp.setName(playlistName);
                playlistArray.add(temp);
                playlistSwitchState(ref);
                Navigator.pop(globalNavigatorKey.currentContext!);
              }
            },
            child: Text(
              'Create Playlist',
              style:
                  modeReadState(ref) ? lightThemeSongText() : darkThemeSongText(),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget editPlaylistForm(WidgetRef ref, Playlist playlist) {
  String playlistName = playlist.playlistName;
  TextEditingController controller = TextEditingController.fromValue(TextEditingValue(text: playlistName));
  Uint8List imageInput = playlist.playlistImageByte;

  return Center(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['jpg', 'jpeg', 'png', 'jfif'],
              );
              if (result != null) {
                String pathInput = result.files.single.path!;
                File file = File(pathInput);
                imageInput = file.readAsBytesSync();
                playlist.setImage(
                  Image.memory(
                    imageInput,
                    fit: BoxFit.fill,
                  ), imageInput
                );
              } else {
                // User canceled the picker
              }
            },
            child: SizedBox(
              width: 300,
              height: 300,
              child: playlist.playlistImage,
            ),
          ),
          const SizedBox(height: 50),
          Form(
            child: Column(
              children: [
                TextField(
                  obscureText: false,
                  controller: controller,
                  maxLength: 24,
                  decoration: const InputDecoration(
                    hintText: 'Playlist Name',
                    constraints: BoxConstraints(maxWidth: 350),
                    label: Text('Playlist Name'),
                  ),
                  onChanged: (String value) async {
                    playlistName = value;
                  },
                  onSubmitted: (String value) async {
                    if (playlistName != '') {
                      playlistName = value;
                      playlist.setName(playlistName);
                      playlistSwitchState(ref);
                      Navigator.pop(globalNavigatorKey.currentContext!);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ButtonStyle(

              overlayColor: WidgetStatePropertyAll(
                modeReadState(ref) ? darkThemeSub() : lightThemeSub(),
              ),
              backgroundColor: WidgetStatePropertyAll(
                modeReadState(ref) ? lightThemeSub() : darkThemeSub(),
              ),
            ),
            onPressed: () {
              if (playlistName != '') {
                playlist.setName(playlistName);
                playlistSwitchState(ref);
                Navigator.pop(globalNavigatorKey.currentContext!);
              }
            },
            child: Text(
              'Edit Playlist',
              style:
              modeReadState(ref) ? lightThemeSongText() : darkThemeSongText(),
            ),
          ),
        ],
      ),
    ),
  );
}
