import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_music_player/src/models/models.dart';
import '../../../main.dart';
import '../../services/services.dart';
import '../ui.dart';

Widget changePlaylistForm(WidgetRef ref, Playlist playlist, bool addingPlaylist) {
  String playlistName = playlist.playlistName;
  TextEditingController controller =
      TextEditingController.fromValue(TextEditingValue(text: playlistName));

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
              child: playlist.getImage(),
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
                      if(addingPlaylist){
                        playlistArray.add(playlist);
                      }
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
                if(addingPlaylist){
                  playlistArray.add(playlist);
                }
                playlistSwitchState(ref);
                Navigator.pop(globalNavigatorKey.currentContext!);
              }
            },
            child: (addingPlaylist)
                ? Text(
                    'Create Playlist',
                    style: currentThemeSmallText(ref),
                  )
                : Text(
                    'Edit Playlist',
                    style: currentThemeSmallText(ref),
                  ),
          ),
        ],
      ),
    ),
  );
}
