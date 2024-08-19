import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:testing_music_player/src/services/services.dart';
import '../../../main.dart';
import '../../config/config.dart';
import '../ui.dart';
import 'package:testing_music_player/src/models/models.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Widget playlistList(WidgetRef ref) {
  final ScrollController scrollController = ScrollController();
  return Expanded(
    child: SizedBox(
      width: MediaQuery.sizeOf(ContextKey.navKey.currentContext!).width,
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
          try {
            return playlistBlock(ref, playlistArray[index + 1]);
          } catch (e) {
            print(e);
            playlistSwitchState(ref);
          }
          return Container();
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
    ),
  );
}

Widget songList(WidgetRef ref, Playlist playlist) {
  final ScrollController scrollController = ScrollController();

  return (importingFile.value)
      ? importingBloc(ref)
      : Expanded(
          child: SizedBox(
            width: MediaQuery.sizeOf(ContextKey.navKey.currentContext!).width,
            child: SlidableAutoCloseBehavior(
              child: ReorderableListView.builder(
                scrollController: scrollController,
                itemCount: playlist.songNameList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: false,
                itemBuilder: (context, index) {
                  if (playlist.songNameList.isNotEmpty) {
                    try {
                      return Slidable(
                        key: Key(playlist.songNameList[index]),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              autoClose: false,
                              onPressed: (context) {
                                // Editing Songs
                                editingSongsDialog(context, ref,
                                    playlist.songList[index] as UriAudioSource);
                              },
                              backgroundColor: const Color(0xff007c77),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                            ),
                            SlidableAction(
                              autoClose: false,
                              onPressed: (context) {
                                if (playlist.songList.children.isNotEmpty) {
                                  Navigator.push(
                                    ContextKey.navKey.currentContext!,
                                    MaterialPageRoute(
                                      builder: (context) => addToPlaylistScreen(
                                          ref,
                                          playlist,
                                          playlist.songList[index]),
                                    ),
                                  );
                                }
                              },
                              backgroundColor: const Color(0xFF70B13B),
                              foregroundColor: Colors.white,
                              icon: Icons.playlist_add,
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            dismissible: DismissiblePane(
                              closeOnCancel: true,
                              confirmDismiss: () async {
                                // Deleting Songs
                                if (playlist == playlistArray[0] &&
                                    songDeleteConfirmation) {
                                  final bool confirmed = await showDialog<bool>(
                                        context: context,
                                        builder: (context) {
                                          return deletingSongsDialog(
                                              context, ref);
                                        },
                                      ) ??
                                      false;
                                  print('Deletion confirmed: $confirmed');
                                  return confirmed;
                                }
                                return true;
                              },
                              onDismissed: () async {
                                /*Remove things*/
                                AudioSource song = playlist.songList[index];
                                String songName =
                                    (song as UriAudioSource).tag.title;
                                if (playlistArray[0] == playlist) {
                                  await deleteSongFromPlaylist(
                                      ref, playlistArray[0], song);
                                  await IsarHelper().deleteSongFor(songName);
                                  print('remove in list');
                                  for (int i = 1;
                                      i < playlistArray.length;
                                      i++) {
                                    if (playlistArray[i]
                                        .songNameList
                                        .contains(songName)) {
                                      await deleteSongFromPlaylist(
                                          ref, playlistArray[i], song);
                                    }
                                  }
                                } else {
                                  await deleteSongFromPlaylist(
                                      ref, playlist, song);
                                }
                                //playlistSwitchState(ref);
                              },
                            ),
                            children: [
                              SlidableAction(
                                autoClose: false,
                                onPressed: (context) async {
                                  bool confirmed;
                                  if (playlist == playlistArray[0] &&
                                      songDeleteConfirmation) {
                                    confirmed = await showDialog<bool>(
                                          context: context,
                                          builder: (context) {
                                            return deletingSongsDialog(
                                                context, ref);
                                          },
                                        ) ??
                                        false;
                                    print('Deletion confirmed: $confirmed');
                                  } else {
                                    confirmed = true;
                                  }

                                  if (confirmed) {
                                    AudioSource song = playlist.songList[index];
                                    String songName =
                                        (song as UriAudioSource).tag.title;
                                    if (playlistArray[0] == playlist) {
                                      await deleteSongFromPlaylist(
                                          ref, playlistArray[0], song);
                                      await IsarHelper()
                                          .deleteSongFor(songName);
                                      print('remove in list');
                                      for (int i = 1;
                                          i < playlistArray.length;
                                          i++) {
                                        if (playlistArray[i]
                                            .songNameList
                                            .contains(songName)) {
                                          deleteSongFromPlaylist(
                                              ref, playlistArray[i], song);
                                        }
                                      }
                                      final controller = Slidable.of(ContextKey.navKey.currentContext!);
                                      controller?.dismiss(
                                        ResizeRequest(
                                            const Duration(milliseconds: 300),
                                                () async =>
                                                deleteSongFromPlaylist(ref,
                                                    playlistArray[0], song)),
                                        duration:
                                        const Duration(milliseconds: 300),
                                      );
                                    } else {
                                      final controller = Slidable.of(context);
                                      controller?.dismiss(
                                        ResizeRequest(
                                            const Duration(milliseconds: 300),
                                            () async => deleteSongFromPlaylist(
                                                ref, playlist, song)),
                                        duration:
                                            const Duration(milliseconds: 300),
                                      );
                                    }
                                  } else {
                                    return;
                                  }
                                  //playlistSwitchState(ref);
                                },
                                backgroundColor: const Color(0xff810303),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                              ),
                            ]),
                        child: songBlock(ref, playlist, index),
                      );
                    } catch (e) {
                      print(e);
                      return Container();
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
            ),
          ),
        );
}

Widget nextSongList(WidgetRef ref) {
  int next = player.nextIndex ?? -1;

  return (next >= 0)
      ? Container(
          margin: const EdgeInsets.only(top: kXXXXLPadding),
          padding: const EdgeInsets.only(
            top: kMediumPadding,
          ),
          color: currentThemeSurfaceContainerLow(ref),
          height: 200,
          width: MediaQuery.sizeOf(ContextKey.navKey.currentContext!).width,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    bottom: kXSPadding,
                    left: kDefaultSmallPadding,
                    right: kDefaultSmallPadding),
                child: headerText(ref, 'Up Next'),
              ),
              upNextSongBlock(ref, next),
              (next + 1 < player.sequence!.length)
                  ? upNextSongBlock(ref, next + 1)
                  : Container(),
              (next + 2 < player.sequence!.length)
                  ? upNextSongBlock(ref, next + 2)
                  : Container(),
              (next + 3 < player.sequence!.length)
                  ? upNextSongBlock(ref, next + 3)
                  : Container(),
              (next + 4 < player.sequence!.length)
                  ? upNextSongBlock(ref, next + 4)
                  : Container(),
            ],
          ),
        )
      : Container();
}

Widget addSongList(WidgetRef ref, Playlist playlist) {
  final ScrollController scrollController = ScrollController();
  return Expanded(
    child: SizedBox(
      width: MediaQuery.sizeOf(ContextKey.navKey.currentContext!).width,
      child: ListView.builder(
          itemCount: playlistArray[0].songList.children.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: false,
          controller: scrollController,
          itemBuilder: (context, index) {
            return addSongBlock(ref, playlist, index);
          }),
    ),
  );
}

Widget addToPlaylistList(
    WidgetRef ref, Playlist originalPlaylist, AudioSource song) {
  final ScrollController scrollController = ScrollController();
  return Expanded(
    child: SizedBox(
      width: MediaQuery.sizeOf(ContextKey.navKey.currentContext!).width,
      child: ListView.builder(
          itemCount: playlistArray.length - 1,
          scrollDirection: Axis.vertical,
          shrinkWrap: false,
          controller: scrollController,
          itemBuilder: (context, index) {
            return addToPlaylistBlock(
                ref, originalPlaylist, playlistArray[index + 1], song);
          }),
    ),
  );
}

Widget settingList(WidgetRef ref) {
  return Expanded(
    child: SizedBox(
      width: MediaQuery.sizeOf(ContextKey.navKey.currentContext!).width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            settingBlock(ref, 'Clear Your Playlists'),
            const Divider(height: 1),
            settingBlock(ref, 'Clear Your Songs'),
            const Divider(height: 1),
            settingBlock(ref, 'Import All Audio Files'),
            const Divider(
              height: 1,
            ),
            settingBlock(ref, 'Song Deletion Confirmation'),
            const Divider(
              height: 1,
            ),
            settingBlock(ref, 'Playlist Deletion Confirmation'),
            const Divider(
              height: 1,
            ),
            settingBlock(ref, 'Dark Mode'),
          ],
        ),
      ),
    ),
  );
}

Widget suggestionSongListWidget(WidgetRef ref, List<String> playlistString) {
  final ScrollController scrollController = ScrollController();

  return SizedBox(
    width: MediaQuery.sizeOf(ContextKey.navKey.currentContext!).width,
    child: ListView.builder(
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
    ),
  );
}

Widget suggestionPlaylistWidget(WidgetRef ref, List<dynamic> searchList,
    bool queryIsEmpty, int playlistCount, int songCount) {
  final ScrollController scrollController = ScrollController();
  int itemCount = 0;
  print(searchList.length);

  if (playlistCount <= 5) {
    itemCount = playlistCount;
    noSeeMorePlaylist = true;
  } else {
    if (seeMorePlaylist) {
      itemCount = playlistCount;
    } else {
      itemCount = 5;
    }
    noSeeMorePlaylist = false;
  }

  if (songCount <= 5) {
    itemCount += songCount;
    noSeeMoreSong = true;
  } else {
    if (seeMoreSong) {
      itemCount = songCount;
    } else {
      itemCount += 5;
    }
    noSeeMoreSong = false;
  }

  print('playlistCount: $playlistCount');
  print('songCount: $songCount');
  print('itemCount: $itemCount');
  print(seeMorePlaylist);
  return SizedBox(
    width: MediaQuery.sizeOf(ContextKey.navKey.currentContext!).width,
    child: ListView.builder(
      itemCount: itemCount,
      scrollDirection: Axis.vertical,
      shrinkWrap: false,
      controller: scrollController,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (playlistCount > 0 && index == 0)
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: kDefaultSmallPadding, top: kXSPadding),
                    child: headerText(ref, 'Playlists'),
                  )
                : Container(),
            (songCount > 0 &&
                    index ==
                        ((playlistCount < 5 || seeMorePlaylist)
                            ? playlistCount
                            : 5))
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: kDefaultSmallPadding, top: kXSPadding),
                    child: headerText(ref, 'Songs'),
                  )
                : Container(),
            ListTile(
              onTap: () => (playlistCount > 5)
                  ? (seeMorePlaylist)
                      ? (searchList[index] is Playlist)
                          ? Navigator.push(
                              ContextKey.navKey.currentContext!,
                              MaterialPageRoute(
                                builder: (context) => playlistScreen(
                                  ref,
                                  searchList[index],
                                ),
                              ),
                            )
                          : loadSong(
                              ref,
                              playlistArray[0],
                              playlistArray[0].songNameList.indexOf(
                                    searchList[index],
                                  ),
                            )
                      : (index < 5)
                          ? Navigator.push(
                              ContextKey.navKey.currentContext!,
                              MaterialPageRoute(
                                builder: (context) => playlistScreen(
                                  ref,
                                  searchList[index],
                                ),
                              ),
                            )
                          : loadSong(
                              ref,
                              playlistArray[0],
                              playlistArray[0].songNameList.indexOf(
                                    searchList[searchList.indexWhere(
                                            (element) => element is String) +
                                        (index - 5)],
                                  ),
                            )
                  : (searchList[index] is Playlist)
                      ? Navigator.push(
                          ContextKey.navKey.currentContext!,
                          MaterialPageRoute(
                            builder: (context) => playlistScreen(
                              ref,
                              searchList[index],
                            ),
                          ),
                        )
                      : loadSong(
                          ref,
                          playlistArray[0],
                          playlistArray[0].songNameList.indexOf(
                                searchList[index],
                              ),
                        ),
              title: Text(
                (playlistCount > 5)
                    ? (seeMorePlaylist)
                        ? (searchList[index] is Playlist)
                            ? searchList[index].playlistName
                            : searchList[index]
                        : (index < 5)
                            ? searchList[index].playlistName
                            : searchList[searchList.indexWhere(
                                    (element) => element is String) +
                                (index - 5)]
                    : (searchList[index] is Playlist)
                        ? searchList[index].playlistName
                        : searchList[index],
                style: searchFieldTextStyle(ref),
              ),
            ),
            (index == 4 &&
                    playlistCount > 5 &&
                    !noSeeMorePlaylist &&
                    !seeMorePlaylist)
                ? InkWell(
                    onTap: () {
                      seeMorePlaylist = true;
                      playlistSwitchState(ref);
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: kDefaultSmallPadding),
                      height: listFieldHeight,
                      width:
                          MediaQuery.sizeOf(ContextKey.navKey.currentContext!)
                              .width,
                      child: Text(
                        'See more...',
                        style: searchFieldTextStyle(ref),
                      ),
                    ),
                  )
                : Container(),
            (index ==
                        ((playlistCount > 5)
                            ? (seeMorePlaylist)
                                ? playlistCount + 4
                                : 9
                            : playlistCount + 4) &&
                    songCount > 5 &&
                    !noSeeMoreSong &&
                    !seeMoreSong)
                ? InkWell(
                    onTap: () {
                      seeMoreSong = true;
                      playlistSwitchState(ref);
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: kDefaultSmallPadding),
                      height: listFieldHeight,
                      width:
                          MediaQuery.sizeOf(ContextKey.navKey.currentContext!)
                              .width,
                      child: Text(
                        'See more...',
                        style: searchFieldTextStyle(ref),
                      ),
                    ),
                  )
                : Container(),
          ],
        );
      },
    ),
  );
}
