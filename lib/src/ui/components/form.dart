import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_music_player/src/models/models.dart';
import '../../../main.dart';
import '../../services/services.dart';
import '../ui.dart';

Widget changePlaylistForm(
    WidgetRef ref, Playlist playlist, bool addingPlaylist) {
  String playlistName = playlist.playlistName;
  String warning = '';
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
              if(!addingPlaylist) {
                IsarHelper().savePlaylist(playlist);
              }
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
                Text(warning),
                TextField(
                  style: Theme.of(ContextKey.navKey.currentContext!)
                      .textTheme
                      .bodyLarge
                      ?.apply(
                    color: currentThemeOnSurface(ref),
                  ),
                  obscureText: false,
                  controller: controller,
                  maxLength: 24,
                  decoration: const InputDecoration(
                    hintText: 'Playlist Name',
                    constraints: BoxConstraints(maxWidth: 350),
                    label: Text('Playlist Name'),
                  ),
                  onTap: () {
                    if(controller.value.text == "Name's Taken. Choose a different name!") {
                      controller.value =
                          TextEditingValue(text: playlistName);
                      playlistSwitchState(ref);
                    }
                  },
                  onChanged: (String value) {
                    playlistName = value;
                  },
                  onSubmitted: (String value) async {
                    if (playlistName != '') {
                      playlistName = value;
                      playlist.setName(playlistName);
                      if (addingPlaylist) {
                        if (!await IsarHelper().playlistExisted(playlistName)) {
                          playlistArray.add(playlist);
                        } else {
                          controller.value =
                              const TextEditingValue(text: "Name's Taken. Choose a different name!");
                          return;
                        }
                      }
                      IsarHelper().savePlaylist(playlist);
                      playlistSwitchState(ref);
                      Navigator.pop(ContextKey.navKey.currentContext!);
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
                currentThemeOnSurface(ref),
              ),
              backgroundColor: WidgetStatePropertyAll(
                currentThemeSurfaceContainerHighest(ref),
              ),
            ),
            onPressed: () async {
              if (playlistName != '') {
                playlist.setName(playlistName);
                if (addingPlaylist) {
                  if (!await IsarHelper().playlistExisted(playlistName)) {
                    playlistArray.add(playlist);
                  } else {
                    controller.value =
                        const TextEditingValue(text: "Name's Taken. Choose a different name!");
                    return;
                  }
                }
                IsarHelper().savePlaylist(playlist);
                playlistSwitchState(ref);
                Navigator.pop(ContextKey.navKey.currentContext!);
              }
            },
            child: (addingPlaylist)
                ? const Text(
                    'Create Playlist',
                    //style: currentThemeSmallText(ref),
                  )
                : const Text(
                    'Edit Playlist',
                    //style: currentThemeSmallText(ref),
                  ),
          ),
        ],
      ),
    ),
  );
}
