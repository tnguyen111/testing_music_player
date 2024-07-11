import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:testing_music_player/src/services/services.dart';
import '../ui.dart';
import 'package:testing_music_player/src/models/models.dart';

Widget playlistList(WidgetRef ref) {
  final ScrollController scrollController = ScrollController();
  return Expanded(
    child: ListView.builder(
        itemCount: playlistArray.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        controller: scrollController,
        itemBuilder: (context, index) {
          return (index < playlistArray.length-1)
              ? playlistBlock(ref, playlistArray[index+1])
              : playlistAddBlock(ref);
        }),
  );
}

Widget songList(WidgetRef ref, ConcatenatingAudioSource songList) {
  final ScrollController scrollController = ScrollController();

  return Expanded(
    child: ReorderableListView.builder(
      scrollController: scrollController,
      itemCount: songList.children.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: false,
      itemBuilder: (context, index) {
        if (songList.children.isNotEmpty) {
          return songBlock(ref, songList, index);
        }
        return Container();
      },

      onReorder: (int oldIndex, int newIndex) async {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        await swapSongsInPlaylist(songList, oldIndex, newIndex);
        playlistSwitchState(ref);
      },
    ),
  );
}

Widget addSongList(WidgetRef ref, Playlist playlist) {
  final ScrollController scrollController = ScrollController();

  return Expanded(
    child: ListView.builder(
        itemCount: songArray.children.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        controller: scrollController,
        itemBuilder: (context, index) {
          return addSongBlock(ref, playlist, index);
        }),
  );
}
