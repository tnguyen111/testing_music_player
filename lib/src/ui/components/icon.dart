import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:testing_music_player/src/models/models.dart';
import 'package:testing_music_player/src/services/services.dart';
import '../../../main.dart';
import '../ui.dart';

IconButton searchIcon(WidgetRef ref, Playlist playlist) => IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        // Search things
        showSearch(
          context: globalNavigatorKey.currentContext!,
          delegate: PlaylistSongSearch(ref, playlist),
        );
      },
    );

IconButton menuIcon(BuildContext context) => IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        /*Open drawer*/
        Scaffold.of(context).openDrawer();
      },
    );

IconButton sortPlaylistIcon(WidgetRef ref) => IconButton(
      icon: const Icon(Icons.sort),
      onPressed: () async {
        //Sort playlists
        await IsarHelper().sortPlaylist(ref);

        playlistSwitchState(ref);
      },
    );

PopupMenuButton<String> sortSongListIcon(WidgetRef ref) =>
    PopupMenuButton<String>(
      icon: const Icon(Icons.sort),
      onSelected: (value) async {
        await IsarHelper().sortSongList(ref, value);
        playlistSwitchState(ref);
      },
      itemBuilder: (BuildContext context) {
        return {'Sort By Name', 'Sort By Artist', 'Sort By Duration'}
            .map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );

IconButton sortSongIcon(WidgetRef ref, Playlist playlist) => IconButton(
      icon: const Icon(Icons.sort),
      onPressed: () async {
        // Sort things
        playlist.songList.children.sort((a, b) =>
            ((a as UriAudioSource).tag.title)
                .compareTo((b as UriAudioSource).tag.title));
        playlist.songNameList.sort((a, b) => a.compareTo(b));
        IsarHelper().savePlaylist(playlist);
        playlistSwitchState(ref);
      },
    );

IconButton addIcon(WidgetRef ref, Playlist playlist) => IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        /*Add things*/
        showDataAlert(globalNavigatorKey.currentContext!, ref, playlist);
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
      showDataAlert(globalNavigatorKey.currentContext!, ref, playlist);
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

IconButton removeIcon(
        WidgetRef ref, Playlist playlist, AudioSource song, int index) =>
    IconButton(
      icon: const Icon(Icons.close),
      onPressed: () async {
        /*Remove things*/
        String songName = (song as UriAudioSource).tag.title;
        if (playlistArray[0] == playlist) {
          print('delete in Array');
          for (int i = 1; i < playlistArray.length; i++) {
            print(i);
            if (playlistArray[i].songNameList.contains(songName)) {
              print('deleted');
              await deleteSongFromPlaylist(ref, playlistArray[i], song);
              IsarHelper().savePlaylist(playlistArray[i]);
            }
          }

          await deleteSongFromPlaylist(ref, playlistArray[0], song);
          IsarHelper().deleteSongFor(songName);
        } else {
          await deleteSongFromPlaylist(ref, playlist, song);
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
          playlistName_: '',
          imagePath_: "lib/assets/default_image.jpg",
          songNameList_: List.empty(growable: true));
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

IconButton playIcon(WidgetRef ref, Playlist playlist) => IconButton(
      icon: (!player.playing)
          ? const Icon(Icons.play_arrow)
          : const Icon(Icons.pause),
      onPressed: () {
        /*Play or Pause songs*/
        if (player.playing) {
          pauseSong(ref);
        } else {
          if (player.audioSource == null) {
            loadSong(ref, playlist, 0);
            currentGlobalPlaylist = playlist;
          }
          startSong(ref);
        }
        playlistSwitchState(ref);
      },
    );

IconButton skipSongIcon(WidgetRef ref, bool skipNext, Playlist playlist,
        int index, bool isNotMiniplayer) =>
    IconButton(
      icon: (skipNext)
          ? const Icon(Icons.skip_next)
          : const Icon(Icons.skip_previous),
      onPressed: () {
        /*Skip songs*/
        bool changed = false;
        if (skipNext) {
          if (index < playlist.songList.length - 1) {
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
            index = playlist.songList.length - 1;
            player.seek(Duration.zero, index: playlist.songList.length - 1);
          }
          changed = true;
        }

        if (changed) {
          skipSong(ref, playlist, index, isNotMiniplayer);
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
