import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_music_player/src/services/services.dart';
import '../../../main.dart';
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
          return (index < playlistArray.length - 1)
              ? playlistBlock(ref, playlistArray[index + 1])
              : playlistAddBlock(ref);
        }),
  );
}

Widget songList(WidgetRef ref, Playlist playlist) {
  final ScrollController scrollController = ScrollController();

  return Expanded(
    child: ReorderableListView.builder(
      scrollController: scrollController,
      itemCount: playlist.songList.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: false,
      itemBuilder: (context, index) {
        if (playlist.songList.children.isNotEmpty) {
          return songBlock(ref, playlist, index);
        }
        return Container();
      },
      onReorder: (int oldIndex, int newIndex) async {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        await swapSongsInPlaylist(playlist, oldIndex, newIndex);
        playlistSwitchState(ref);
      },
    ),
  );
}

Widget addSongList(WidgetRef ref, Playlist playlist) {
  final ScrollController scrollController = ScrollController();
  return Expanded(
    child: ListView.builder(
        itemCount: playlistArray[0].songList.children.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        controller: scrollController,
        itemBuilder: (context, index) {
          return addSongBlock(ref, playlist, index);
        }),
  );
}

Widget suggestionSongListWidget(WidgetRef ref, List<String> playlistString) {
  final ScrollController scrollController = ScrollController();

  return ListView.builder(
    itemCount: playlistString.length,
    scrollDirection: Axis.vertical,
    shrinkWrap: false,
    controller: scrollController,
    itemBuilder: (context, index) {
      return ListTile(
        onTap: () {
          print(playlistString[index]);
          Playlist playlist = playlistArray.firstWhere(
              (p) => p.playlistName == playlistString[index],
              orElse: () => playlistArray[0]);
          loadSong(ref, playlist,
              playlist.songNameList.indexOf(playlistString[index]));
        },
        title: Text(
          playlistString[index],
          style: currentThemeSmallText(ref),
        ),
      );
    },
  );
}

Widget suggestionPlaylistWidget(WidgetRef ref, List<Playlist> playlistList) {
  final ScrollController scrollController = ScrollController();

  return ListView.builder(
    itemCount: playlistList.length,
    scrollDirection: Axis.vertical,
    shrinkWrap: false,
    controller: scrollController,
    itemBuilder: (context, index) {
      return ListTile(
        onTap: () {
          print(playlistList[index].playlistName);
          Navigator.push(
            globalNavigatorKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => playlistScreen(ref, playlistList[index])),
          );
        },
        title: Text(
          playlistList[index].playlistName,
          style: currentThemeSmallText(ref),
        ),
      );
    },
  );
}
