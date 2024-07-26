import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:testing_music_player/src/models/models.dart';
import 'package:testing_music_player/src/services/services.dart';
import '../../../main.dart';
import '../ui.dart';

IconButton searchSongIcon(WidgetRef ref, Playlist playlist) => IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        // Search things
        showSearch(
          context: ContextKey.navKey.currentContext!,
          delegate: PlaylistSongSearch(ref, playlist),
        );
      },
    );

IconButton searchPlaylistIcon(WidgetRef ref) => IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        // Search things
        showSearch(
          context: ContextKey.navKey.currentContext!,
          delegate: PlaylistSearch(ref),
        );
      },
    );

IconButton sortPlaylistIcon(WidgetRef ref) => IconButton(
      icon: const Icon(Icons.sort),
      onPressed: () async {
        //Sort playlists
        await IsarHelper().sortPlaylistList(ref);
        playlistSwitchState(ref);
      },
    );

PopupMenuButton<String> sortSongIcon(WidgetRef ref, Playlist playlist) =>
    PopupMenuButton<String>(
      icon: const Icon(Icons.sort),
      onSelected: (value) async {
        if (playlist == playlistArray[0]) {
          await IsarHelper().sortSongList(ref, value);
        } else {
          await sortingPlaylist(ref, playlist, value);
        }
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

IconButton addIcon(WidgetRef ref, Playlist playlist) => IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        /*Add things*/
        addingSongsDialog(ContextKey.navKey.currentContext!, ref, playlist);
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
      addingSongsDialog(ContextKey.navKey.currentContext!, ref, playlist);
      playlistSwitchState(ref);
      break;
    case 'Add Songs From Songs List':
      Navigator.push(
        ContextKey.navKey.currentContext!,
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
      iconSize: 50,
      icon: const Icon(Icons.close,),
      onPressed: () async {
        /*Remove things*/
        String songName = (song as UriAudioSource).tag.title;
        if (playlistArray[0] == playlist) {
          for (int i = 1; i < playlistArray.length; i++) {
            if (playlistArray[i].songNameList.contains(songName)) {
              deleteSongFromPlaylist(ref, playlistArray[i], song);
              IsarHelper().savePlaylist(playlistArray[i]);
            }
          }

          await deleteSongFromPlaylist(ref, playlistArray[0], song);
          IsarHelper().deleteSongFor(songName);
        } else {
          deleteSongFromPlaylist(ref, playlist, song);
        }
        playlistSwitchState(ref);
      },
    );

IconButton addPlaylistIcon(WidgetRef ref) => IconButton(
  icon: const Icon(Icons.add),
  onPressed: () {
    /*Add things*/
    Playlist playlist = Playlist(
        playlistName_: '',
        imagePath_: "lib/assets/default_image.png",
        songNameList_: List.empty(growable: true));
    Navigator.push(
      ContextKey.navKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => addPlaylistScreen(ref, playlist)),
    );
    playlistSwitchState(ref);
  },
);

PopupMenuButton<String> settingSongIcon(WidgetRef ref, Playlist playlist) =>
    PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
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

Future<void> handleSettingSongClick(String value, WidgetRef ref, Playlist playlist) async {
  switch (value) {
    case 'Edit Playlist Info':
      Navigator.push(
        ContextKey.navKey.currentContext!,
        MaterialPageRoute(
            builder: (context) => EditPlaylistScreen(
                  ref: ref,
                  playlist: playlist,
                )),
      );
      break;
    case 'Delete Playlist':
      await deletePlaylistDialog(ref,playlist);
      playlistSwitchState(ref);
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
        bool isNotMiniplayer) =>
    IconButton(
      icon: (skipNext)
          ? const Icon(Icons.skip_next)
          : const Icon(Icons.skip_previous),
      onPressed: () async {
        /*Skip songs*/
        int index = playlist.songNameList
            .indexOf(player.sequenceState?.currentSource?.tag.title);
        if (skipNext) {
          (player.currentIndex! < playlist.songList.length - 1)
              ? await player.seekToNext()
              : await player.seek(Duration.zero, index: 0);
        } else if (!skipNext) {
          (index > 0)
              ? await player.seekToPrevious()
              : await player.seek(Duration.zero,
                  index: playlist.songList.length - 1);
        }
        songSetState(ref, 2);
        playlistSwitchState(ref);
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
