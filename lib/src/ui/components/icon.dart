import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:testing_music_player/src/models/models.dart';
import 'package:testing_music_player/src/services/services.dart';
import 'package:testing_music_player/src/services/state_management/helper_funcs/helper_funcs.dart';
import '../../../main.dart';
import '../ui.dart';

/*
IconButton searchIcon(WidgetRef ref) => IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        */
/*Search things*//*

        modeSwitchState(ref);
      },
    );
*/

IconButton menuIcon(BuildContext context) => IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        /*Open drawer*/
        Scaffold.of(context).openDrawer();
      },
    );

/*IconButton sortIcon(WidgetRef ref, String typeSort) => IconButton(
      icon: const Icon(Icons.sort),
      onPressed: () async {
        //Sort things
        if (typeSort == 'Your Playlist') {
          playlistArray = await IsarHelper().sortPlaylist();

        } else {
          songArray.children.sort((a, b) => (a as UriAudioSource)
              .tag
              .songName
              .compareTo((b as UriAudioSource).tag.songName));

          await IsarHelper().sortSongList();
        }

        playlistSwitchState(ref);
      },
    );

IconButton sortSongIcon(WidgetRef ref, Playlist playlist) =>
    IconButton(
      icon: const Icon(Icons.sort),
      onPressed: () {
        // Sort things
        playlist.songList.children.sort((a, b) => (a as UriAudioSource)
            .tag
            .songName
            .compareTo((b as UriAudioSource).tag.songName));
        IsarHelper().savePlaylist(playlist);
        playlistSwitchState(ref);
      },
    );*/

IconButton addIcon(WidgetRef ref, ConcatenatingAudioSource songList) =>
    IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        /*Add things*/
        showDataAlert(globalNavigatorKey.currentContext!, ref, songList);
        playlistSwitchState(ref);
      },
    );

PopupMenuButton<String> addSongMenuIcon(WidgetRef ref, Playlist playlist) =>
    PopupMenuButton<String>(
      icon: const Icon(Icons.add),
      onSelected: (value) {
        handleAddSongMenu(value, ref, playlist);
        playlistSwitchState(ref);
      },
      itemBuilder: (BuildContext context) {
        return {'Add New Song', 'Add Songs From Songs List'}
            .map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );

void handleAddSongMenu(String value, WidgetRef ref, Playlist playlist) {
  switch (value) {
    case 'Add New Song':
      showDataAlert(globalNavigatorKey.currentContext!, ref, playlist.songList);
      playlistSwitchState(ref);
      break;
    case 'Add Songs From Songs List':
      Navigator.push(
        globalNavigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => addSongScreen(
            ref,
            playlist,
          ),
        ),
      );
      break;
  }
}

IconButton removeIcon(WidgetRef ref, ConcatenatingAudioSource playlist,
        AudioSource song, int index) =>
    IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        /*Remove things*/
        String songName = (song as UriAudioSource).tag.songName;
        if (playlist == songArray) {
          for (int i = 0; i < playlistArray.length; i++) {
            if (playlistArray[i].songList.children.contains(song)) {
              playlistArray[i]
                  .songNameList
                  .remove(songName);
              playlistArray[i]
                  .songList
                  .removeAt(playlistArray[i].songList.children.indexOf(song));
              IsarHelper().savePlaylist(playlistArray[i]);
            }
          }
          IsarHelper().deleteSongFor(songName);
          playlist.removeAt(index);
        } else {
          deleteSongFromPlaylist(playlist,song);
        }
        playlistSwitchState(ref);
      },
    );

IconButton removePlaylistIcon(WidgetRef ref, Playlist playlist) => IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        /*Remove things*/
        IsarHelper().deletePlaylistFor(playlist.playlistName);
        playlistArray.remove(playlist);
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
      Playlist playlist = Playlist(
          playlistName_: '', imagePath_: "lib/assets/default_image.jpg", songNameList_: List.empty(growable: true));
      Navigator.push(
        globalNavigatorKey.currentContext!,
        MaterialPageRoute(
            builder: (context) => addPlaylistScreen(ref, playlist)),
      );
      break;
    case 'Delete Playlist':
      playlistRemoving = !playlistRemoving;
      playlistSwitchState(ref);
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
      IsarHelper().deletePlaylistFor(playlist.playlistName);
      playlistArray.remove(playlist);
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
          pauseSong(ref);
        } else {
          startSong(ref);
        }
        playlistSwitchState(ref);
      },
    );

IconButton skipSongIcon(WidgetRef ref, bool skipNext,
        ConcatenatingAudioSource playlist, int index) =>
    IconButton(
      icon: (skipNext)
          ? const Icon(Icons.skip_next)
          : const Icon(Icons.skip_previous),
      onPressed: () {
        /*Skip songs*/
        bool changed = false;
        if (skipNext) {
          if (index < playlist.length - 1) {
            index++;
            player.seekToNext();
          } else {
            index = 0;
            player.seek(Duration.zero, index: 0);
          }
          changed = true;
        } else if (!skipNext) {
          if (index > 0) {
            index--;
            player.seekToPrevious();
          } else {
            index = playlist.length - 1;
            player.seek(Duration.zero, index: playlist.length - 1);
          }
          changed = true;
        }

        if (changed) {
          skipSong(ref, playlist, index);
          songSetState(ref, 2);
        }
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
