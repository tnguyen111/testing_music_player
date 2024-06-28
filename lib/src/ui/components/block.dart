import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:testing_api_twitter/src/config/config.dart';
import 'package:testing_api_twitter/src/ui/ui.dart';
import 'package:testing_api_twitter/src/services/services.dart';
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
          sortIcon(ref,header),
          (header == 'Your Playlist')
              ? settingListIcon(ref)
              : addIcon(ref, songArray),
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
          loadNewPlaylist(playlist.songList);
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
                    child: playlist.playlistImage_,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    playlist.playlistName_,
                  ),
                ),
                settingSongIcon(ref, playlist),
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
          Navigator.push(
            globalNavigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => addPlaylistScreen(ref),
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

Container songBlock(WidgetRef ref, ConcatenatingAudioSource playlist, int index) => Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding, right: kDefaultPadding, bottom: kSmallPadding),
      child: GestureDetector(
        onTap: () {

          loadNewSong(ref, playlist, index);
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                color: currentThemeHeader(ref),
              ),
              height: 65,
            ),
            Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            (playlist[index] as UriAudioSource).tag.songName
                        ),
                        Text(
                          (playlist[index] as UriAudioSource).tag.songAuthor,
                          textScaler: const TextScaler.linear(0.6),
                        ),
                      ]),
                ),
                Text((playlist[index] as UriAudioSource).tag.songDurationString),
                removeIcon(ref, playlist,(playlist[index] as UriAudioSource)),
              ],
            ),
          ],
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
              child: playlist.playlistImage,
            ),
            onTap: () async {
              await changePlaylistImage(playlist);
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
              playIcon(ref),
              shuffleIcon(ref),
              const Expanded(child: SizedBox()),
              sortSongIcon(ref,playlist.songList),
              addIcon(ref, playlist.songList),
            ],
          ),
        ],
      ),
    );

Widget songIconBlock(WidgetRef ref, ConcatenatingAudioSource playlist, int index) {
  songWatchState(ref);
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    shuffleIcon(ref),
    skipSongIcon(ref, false, playlist, index),
    const SizedBox(width: 18),
    Transform.scale(scale: 2, child: playIcon(ref)),
    const SizedBox(width: 18),
    skipSongIcon(ref, true, playlist, index),
    loopIcon(ref),
  ]);
}

Widget songNameBlock(WidgetRef ref, UriAudioSource song) {
  return Column(
    children: [
      Text(
        song.tag.songName,
        style: currentThemeHeaderText(ref),
      ),
      Text(song.tag.songAuthor),
    ],
  );
}



