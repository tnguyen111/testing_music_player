import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:testing_music_player/src/services/services.dart';
import '../../../main.dart';
import '../../config/config.dart';
import '../ui.dart';
import 'package:testing_music_player/src/models/models.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

Widget playlistList(WidgetRef ref) {
  final ScrollController scrollController = ScrollController();
  return Expanded(
    child: ReorderableGridView.builder(
      padding: EdgeInsets.only(
        top: kDefaultSmallPadding,
        bottom: kDefaultSmallPadding,
        right: kDefaultSmallPadding +
            (((ContextKey.appWidth -
                        32 -
                        ((((ContextKey.appWidth - 32) / 185).floor() - 1) *
                            12)) /
                    185) /
                2),
        left: kDefaultSmallPadding +
            (((ContextKey.appWidth -
                        32 -
                        ((((ContextKey.appWidth - 32) / 185).floor() - 1) *
                            12)) /
                    185) /
                2),
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 185,
          mainAxisExtent: 220,
          mainAxisSpacing: kMediumPadding,
          crossAxisSpacing: kMediumPadding),
      itemCount: (playlistArray.length > 1) ? playlistArray.length - 1 : 0,
      shrinkWrap: false,
      controller: scrollController,
      itemBuilder: (context, index) {
        return playlistBlock(ref, playlistArray[index + 1]);
      },
      onReorder: (int oldIndex, int newIndex) async {
        if (oldIndex != newIndex) {
          print(oldIndex);
          print(newIndex);
          oldIndex += 1;
          newIndex += 1;
          //await swapSongsInPlaylist(playlist, oldIndex, newIndex);
          movePlaylist(oldIndex, newIndex);
          playlistSwitchState(ref);
        }
      },
    ),
  );
}

Widget songList(WidgetRef ref, Playlist playlist) {
  final ScrollController scrollController = ScrollController();

  return (importingFile.value)
      ? importingBloc(ref)
      :  Expanded(
    child: ReorderableListView.builder(
      scrollController: scrollController,
      itemCount: playlist.songNameList.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: false,
      itemBuilder: (context, index) {
        if (playlist.songNameList.isNotEmpty) {
          try {
            return Dismissible(
              key: Key(playlist.songNameList[index]),
              background: Container(
                color: const Color(0xff810303),
                alignment: Alignment.centerLeft,
                child: const Padding(
                  padding: EdgeInsets.all(kDefaultSmallPadding),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
              secondaryBackground: Container(
                color: const Color(0xff810303),
                alignment: Alignment.centerRight,
                child: const Padding(
                  padding: EdgeInsets.all(kDefaultSmallPadding),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
              confirmDismiss: (direction) async {
                if (playlist == playlistArray[0] && songDeleteConfirmation) {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return deletingSongsDialog(context, ref);
                    },
                  );
                  print('Deletion confirmed: $confirmed');
                  return confirmed;
                }
                return true;
              },
              onDismissed: (direction) async {
                /*Remove things*/
                AudioSource song = playlist.songList[index];
                String songName = (song as UriAudioSource).tag.title;
                if (playlistArray[0] == playlist) {
                  await deleteSongFromPlaylist(ref, playlistArray[0], song);
                  await IsarHelper().deleteSongFor(songName);
                  print('remove in list');
                  for (int i = 1; i < playlistArray.length; i++) {
                    if (playlistArray[i].songNameList.contains(songName)) {
                      await deleteSongFromPlaylist(ref, playlistArray[i], song);
                    }
                  }
                } else {
                  await deleteSongFromPlaylist(ref, playlist, song);
                }
                playlistSwitchState(ref);
              },
              child: songBlock(ref, playlist, index),
            );
          } catch (e) {
            print(e);
          }
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

Widget settingList(WidgetRef ref) {

  return Expanded(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          settingBlock(ref, 'Clear Your Playlists'),
          const Divider(height: 1),
          settingBlock(ref, 'Clear Your Songs'),
          const Divider(height: 1),
          settingBlock(ref, 'Import All Audio Files'),
          const Divider(height: 1, ),
          settingBlock(ref, 'Song Deletion Confirmation'),
          const Divider(height: 1, ),
          settingBlock(ref, 'Playlist Deletion Confirmation'),
          const Divider(height: 1, ),
          settingBlock(ref, 'Dark Mode'),
        ],
      ),
    ),
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
          Playlist playlist = playlistArray.firstWhere(
              (p) => p.playlistName == playlistString[index],
              orElse: () => playlistArray[0]);
          loadSong(ref, playlist,
              playlist.songNameList.indexOf(playlistString[index]));
        },
        title: Text(
          playlistString[index],
          //style: currentThemeSmallText(ref),
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
          Navigator.push(
            ContextKey.navKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => playlistScreen(ref, playlistList[index])),
          );
        },
        title: Text(
          playlistList[index].playlistName,
          //style: currentThemeSmallText(ref),
        ),
      );
    },
  );
}
