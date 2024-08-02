import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_music_player/src/models/global_list.dart';

import '../../config/config.dart';
import '../../services/services.dart';
import '../ui.dart';

Widget settingSwitch(WidgetRef ref, String function) {
  return Padding(
    padding: const EdgeInsets.all(kXSPadding),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        settingText(
          ref,
          function,
        ),
        Switch(
          thumbIcon: (function == 'Dark Mode')
              ? (!modeReadState(ref))
                  ? const WidgetStatePropertyAll(Icon(Icons.nightlight))
                  : const WidgetStatePropertyAll(Icon(Icons.sunny))
              : null,
          value: (function == 'Dark Mode') ? !modeReadState(ref): (function == 'Song Deletion Confirmation') ? songDeleteConfirmation: playlistDeleteConfirmation,
          onChanged: (bool value) async {
            if(function == 'Dark Mode') {
              modeSwitchState(ref);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('lightMode', !value);
              return;
            } else if(function == 'Song Deletion Confirmation'){
              songDeleteConfirmation = !songDeleteConfirmation;
              changeSongConfirmation();
              playlistSwitchState(ref);
              return;
            } else if(function == 'Playlist Deletion Confirmation'){
              playlistDeleteConfirmation = !playlistDeleteConfirmation;
              changePlaylistConfirmation();
              playlistSwitchState(ref);
              return;
            }
          },
        ),
      ],
    ),
  );
}
