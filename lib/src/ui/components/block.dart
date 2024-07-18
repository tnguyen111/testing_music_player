import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:testing_music_player/src/config/config.dart';
import 'package:testing_music_player/src/ui/ui.dart';
import 'package:testing_music_player/src/services/services.dart';
import '../../../main.dart';
import '../../models/models.dart';

Container headerBlock(String header, WidgetRef ref) => Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding, top: kSmallPadding, bottom: kSmallPadding),
      child: Row(
        children: [
          Expanded(
            child: Text(
              header,
            ),
          ),
          const SizedBox(width: 125),
          (header == 'Your Playlist')
              ? sortPlaylistIcon(ref)
              : sortSongIcon(ref, playlistArray[0]),
          (header == 'Your Playlist')
              ? settingListIcon(ref)
              : addIcon(ref, playlistArray[0]),
        ],
      ),
    );

Container playlistBlock(WidgetRef ref, Playlist playlist) => Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding, right: kDefaultPadding, bottom: kSmallPadding),
      child: GestureDetector(
        onTap: () {
          // Change!
          Navigator.push(
            globalNavigatorKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => playlistScreen(ref, playlist)),
          );
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                color: currentThemeHeader(ref),
              ),
              height: 90,
            ),
            Row(
              children: [
                SizedBox(
                  width: 90,
                  height: 90,
                  child: Container(
                    child: playlist.getImage(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    playlist.playlistName_,
                  ),
                ),
                (playlistRemoving)
                    ? removePlaylistIcon(ref, playlist)
                    : settingSongIcon(ref, playlist),
              ],
            ),
          ],
        ),
      ),
    );

Container playlistAddBlock(WidgetRef ref) => Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding, right: kDefaultPadding, bottom: kSmallPadding),
      child: GestureDetector(
        onTap: () async {
          playlistSwitchState(ref);
          Playlist playlist = Playlist(
              playlistName_: '',
              imagePath_: 'lib/assets/default_image.png',
              songNameList_: []);
          Navigator.push(
            globalNavigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => addPlaylistScreen(ref, playlist),
            ),
          );
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                color: currentThemeHeader(ref),
              ),
              height: 90,
            ),
            Row(children: [
              SizedBox(
                width: 90,
                height: 90,
                child: Container(
                  color: currentThemeSub(ref),
                  child: const Icon(Icons.add),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Add New Playlist',
                ),
              ),
            ]),
          ],
        ),
      ),
    );

Container songBlock(WidgetRef ref, Playlist playlist, int index) => Container(
      key: Key('$index'),
      margin: const EdgeInsets.only(
          left: kDefaultPadding, right: kDefaultPadding, bottom: kSmallPadding),
      child: GestureDetector(
        onTap: () {
          loadSong(ref, playlist, index);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            color: currentThemeHeader(ref),
          ),
          padding: const EdgeInsets.only(top: 9, bottom: 9),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        (playlist.songList[index] as UriAudioSource).tag.title,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        (playlist.songList[index] as UriAudioSource).tag.artist,
                        overflow: TextOverflow.ellipsis,
                        textScaler: const TextScaler.linear(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Text((playlist.songList[index] as UriAudioSource)
                  .tag
                  .displayDescription),
              removeIcon(ref, playlist,
                  (playlist.songList[index] as UriAudioSource), index),
            ],
          ),
        ),
      ),
    );

Container playlistMenuBlock(WidgetRef ref, Playlist playlist) => Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding, right: kDefaultPadding, bottom: kSmallPadding),
      child: Column(
        children: [
          const SizedBox(height: kDefaultPadding),
          GestureDetector(
            child: SizedBox(
              width: 300,
              height: 300,
              child: playlist.getImage(),
            ),
            onTap: () async {
              await changePlaylistImage(playlist);
              IsarHelper().savePlaylist(playlist);
              playlistSwitchState(ref);
            },
          ),
          TextButton(
            onPressed: () {
              editPlaylistNameDialog(
                  globalNavigatorKey.currentContext!, ref, playlist);
            },
            child: Text(
              playlist.playlistName,
              style: currentThemeHeaderText(ref),
            ),
          ),
          Row(
            children: [
              playIcon(ref, playlist),
              shuffleIcon(ref),
              const Expanded(
                child: SizedBox(),
              ),
              sortSongIcon(
                ref,
                playlist,
              ),
              addSongMenuIcon(
                ref,
                playlist,
              ),
            ],
          ),
        ],
      ),
    );

Widget songIconBlock(
    WidgetRef ref, Playlist playlist, int index, bool isNotMiniplayer) {
  double scaling = 2;
  if (!isNotMiniplayer) {
    scaling = 1;
  }
  songWatchState(ref);
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    (isNotMiniplayer) ? shuffleIcon(ref) : Container(),
    skipSongIcon(ref, false, playlist, isNotMiniplayer),
    SizedBox(width: 9 * scaling),
    Transform.scale(scale: scaling, child: playIcon(ref, playlist)),
    SizedBox(width: 9 * scaling),
    skipSongIcon(ref, true, playlist, isNotMiniplayer),
    (isNotMiniplayer) ? loopIcon(ref) : Container(),
  ]);
}

Widget songNameBlock(WidgetRef ref) {
  String songName = player.sequenceState?.currentSource?.tag.title ?? "ERROR";
  String authorName = player.sequenceState?.currentSource?.tag.artist ?? "";
  return Column(
    children: [
      const SizedBox(height: 18),
      Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            songName,
            style: currentThemeHeaderText(ref),
            maxLines: 1,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 50, right: 50),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(authorName),
        ),
      ),
    ],
  );
}

Widget addSongBlock(ref, playlist, index) => Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding, right: kDefaultPadding, bottom: kSmallPadding),
      child: GestureDetector(
        onTap: () {
          loadSong(ref, playlistArray[0], index);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            color: currentThemeHeader(ref),
          ),
          padding: const EdgeInsets.only(top: 9, bottom: 9),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                            (playlistArray[0].songList[index] as UriAudioSource)
                                .tag
                                .title),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          (playlistArray[0].songList[index] as UriAudioSource)
                              .tag
                              .artist,
                          textScaler: const TextScaler.linear(0.6),
                        ),
                      ),
                    ]),
              ),
              const SizedBox(width: 18),
              Text((playlistArray[0].songList[index] as UriAudioSource)
                  .tag
                  .displayDescription),
              listCheckbox(playlist, playlistArray[0].songList[index], ref),
            ],
          ),
        ),
      ),
    );
