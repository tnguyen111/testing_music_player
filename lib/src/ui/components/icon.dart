import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:testing_api_twitter/src/models/models.dart';
import 'package:testing_api_twitter/src/services/services.dart';
import 'package:testing_api_twitter/src/services/state_management/helper_funcs/helper_funcs.dart';
import '../../../main.dart';
import '../ui.dart';

IconButton searchIcon(WidgetRef ref) => IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        /*Search things*/
        modeSwitchState(ref);
      },
    );

IconButton menuIcon(BuildContext context) => IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        /*Open drawer*/
        Scaffold.of(context).openDrawer();
      },
    );

IconButton sortIcon(WidgetRef ref, String typeSort) => IconButton(
      icon: const Icon(Icons.sort),
      onPressed: () {
        /*Sort things*/
        if (typeSort == 'Your Playlist') {
          playlistArray
              .sort((a, b) => a.playlistName.compareTo(b.playlistName));
        } else {
          songArray.sort((a, b) => a.songName.compareTo(b.songName));
        }
        playlistSwitchState(ref);
      },
    );

IconButton addIcon(WidgetRef ref, List<Song> songList) => IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        /*Add things*/
        print('bruh');
        showDataAlert(globalNavigatorKey.currentContext!, ref, songList);
        print(songList);
        playlistSwitchState(ref);
      },
    );

IconButton removeIcon(WidgetRef ref, Song song) => IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        /*Remove things*/
        songArray.remove(song);
        playlistSwitchState(ref);
      },
    );

PopupMenuButton<String> settingListIcon(WidgetRef ref) =>
    PopupMenuButton<String>(
      onSelected: (value) {
        handleSettingListClick(value, ref);
      },
      itemBuilder: (BuildContext context) {
        return {'Add New Playlist', 'Delete Playlist'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );

void handleSettingListClick(String value, WidgetRef ref) {
  switch (value) {
    case 'Add New Playlist':
      Navigator.push(
        globalNavigatorKey.currentContext!,
        MaterialPageRoute(
            builder: (context) => addPlaylistScreen(
                 ref
                )),
      );
      break;
    case 'Delete Playlist':
      break;
  }
}

PopupMenuButton<String> settingSongIcon(WidgetRef ref, Playlist playlist) =>
    PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz),
      iconSize: 30,
      onSelected: (value) {
        handleSettingSongClick(value, ref, playlist);
        playlistSwitchState(ref);
      },
      itemBuilder: (BuildContext context) {
        return {'Edit Playlist Info', 'Delete Playlist'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );

void handleSettingSongClick(String value, WidgetRef ref, Playlist playlist) {
  switch (value) {
    case 'Edit Playlist Info':
      Navigator.push(
        globalNavigatorKey.currentContext!,
        MaterialPageRoute(
            builder: (context) => EditPlaylistScreen(
                  ref: ref,
                  playlist: playlist,
                )),
      );
      break;
    case 'Delete Playlist':
      print(playlistArray);
      playlistArray.remove(playlist);
      print(playlistArray);
      break;
  }
}

IconButton playIcon(WidgetRef ref) => IconButton(
      icon: (player.playing)
          ? const Icon(Icons.play_arrow)
          : const Icon(Icons.pause),
      onPressed: () {
        /*Play or Pause songs*/
        if (player.playing) {
          player.pause();
          songSetState(ref, 1);
        } else {
          player.play();
          songSetState(ref, 0);
        }
      },
    );

IconButton skipSongIcon(WidgetRef ref, bool skipNext) => IconButton(
      icon: (skipNext)
          ? const Icon(Icons.skip_next)
          : const Icon(Icons.skip_previous),
      onPressed: () {
        /*Skip songs*/
        if (skipNext) {
          player.seekToNext();
        } else {
          player.seekToPrevious();
        }
        songSetState(ref, 2);
      },
    );

IconButton shuffleIcon(WidgetRef ref) => IconButton(
      icon: (player.shuffleModeEnabled)
          ? const Icon(Icons.shuffle_on_outlined)
          : const Icon(Icons.shuffle),
      onPressed: () {
        /*Shuffle songs*/
        player.setShuffleModeEnabled(!player.shuffleModeEnabled);
        playlistSwitchState(ref);
      },
    );

IconButton loopIcon(WidgetRef ref) => IconButton(
      icon: (player.loopMode == LoopMode.off)
          ? const Icon(Icons.repeat)
          : (player.loopMode == LoopMode.one)
              ? const Icon(Icons.repeat_one_on_outlined)
              : const Icon(Icons.repeat_on_outlined),
      onPressed: () {
        /*Set loop modes*/
        if (player.loopMode == LoopMode.off) {
          player.setLoopMode(LoopMode.one);
        } else if (player.loopMode == LoopMode.one) {
          player.setLoopMode(LoopMode.all);
        } else {
          player.setLoopMode(LoopMode.off);
        }

        playlistSwitchState(ref);
      },
    );

IconButton backIcon(BuildContext context) => IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        /*Shuffle songs*/
        Navigator.pop(
          context,
        );
      },
    );
