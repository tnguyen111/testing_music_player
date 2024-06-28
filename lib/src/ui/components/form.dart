import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_api_twitter/src/models/models.dart';
import '../../../main.dart';
import '../../services/services.dart';
import '../ui.dart';



Widget playlistForm(WidgetRef ref, Image imageInput) {
  String playlistName = '';
  return Center(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: SizedBox(
              width: 300,
              height: 300,
              child:  imageInput,
            ),
            onTap: () async {
              imageInput = await changeImage(imageInput);
            },
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
                      playlistArray.add(Playlist(playlistName_: playlistName,playlistImage_: imageInput));
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
                currentThemeSub(ref),
              ),
              backgroundColor: WidgetStatePropertyAll(
                  currentThemeSub(ref),
              ),
            ),
            onPressed: () {
              if (playlistName != '') {
                playlistArray.add(Playlist(playlistName_: playlistName,playlistImage_: imageInput));
                playlistSwitchState(ref);
                Navigator.pop(globalNavigatorKey.currentContext!);
              }
            },
            child: Text(
              'Create Playlist',
              style:
              currentThemeSmallText(ref),
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

  return Center(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              await changePlaylistImage(playlist);
              playlistSwitchState(ref);
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
                currentThemeSub(ref),
              ),
              backgroundColor: WidgetStatePropertyAll(
                  currentThemeSub(ref),
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
              style: currentThemeSmallText(ref),
            ),
          ),
        ],
      ),
    ),
  );
}
