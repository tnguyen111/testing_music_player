import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_music_player/src/config/config.dart';
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
          Padding(
            padding: const EdgeInsets.all(kLargePadding),
            child: GestureDetector(
              onTap: () async {
                await changePlaylistImage(playlist);
                if (!addingPlaylist) {
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
          ),
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
                  maxLength: 30,
                  decoration: const InputDecoration(
                    hintText: 'Playlist Name',
                    constraints: BoxConstraints(maxWidth: 350),
                    label: Text('Playlist Name'),
                  ),
                  onTap: () {
                    if (controller.value.text ==
                        "Name's Taken. Choose a different name!") {
                      controller.value = TextEditingValue(text: playlistName);
                      playlistSwitchState(ref);
                    }
                  },
                  onChanged: (String value) {
                    if (controller.value.text ==
                        "Name's Taken. Choose a differe") {
                      controller.value = TextEditingValue(text: playlistName);
                    }
                    playlistName = value;
                  },
                  onSubmitted: (String value) async {
                    if (playlistName.isNotEmpty) {
                      playlistName = value;
                      playlist.setName(playlistName);
                      if (addingPlaylist) {
                        if (!await IsarHelper().playlistExisted(playlistName)) {
                          playlistArray.add(playlist);
                        } else {
                          controller.value = const TextEditingValue(
                              text: "Name's Taken. Choose a different name!");
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
          const SizedBox(height: kLargePadding),
          TextButton(
            onPressed: () async {
              if (playlistName.isNotEmpty) {
                playlist.setName(playlistName);
                if (addingPlaylist) {
                  if (!await IsarHelper().playlistExisted(playlistName)) {
                    playlistArray.add(playlist);
                  } else {
                    controller.value = const TextEditingValue(
                        text: "Name's Taken. Choose a different name!");
                    return;
                  }
                }
                IsarHelper().savePlaylist(playlist);
                playlistSwitchState(ref);
                Navigator.pop(ContextKey.navKey.currentContext!);
              }
            },
            child: (addingPlaylist)
                ? alertActionText(
                    ref,
                    'Create Playlist',
                    //style: currentThemeSmallText(ref),
                  )
                : alertActionText(
                    ref,
                    'Edit Playlist',
                    //style: currentThemeSmallText(ref),
                  ),
          ),
        ],
      ),
    ),
  );
}
