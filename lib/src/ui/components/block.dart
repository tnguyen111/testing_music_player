import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:testing_music_player/src/config/config.dart';
import 'package:testing_music_player/src/ui/ui.dart';
import 'package:testing_music_player/src/services/services.dart';
import '../../../main.dart';
import '../../models/models.dart';

Container headerBlock(String header, WidgetRef ref) => Container(
      margin:
          const EdgeInsets.only(left: kDefaultPadding, right: kMediumPadding),
      child: Row(
        children: [
          Expanded(
            child: headerText(
              ref,
              header,
            ),
          ),
          (header.contains('Playlist'))
              ? sortPlaylistIcon(ref)
              : sortSongIcon(ref, playlistArray[0]),
        ],
      ),
    );

Widget playlistBlock(WidgetRef ref, Playlist playlist) => Row(
      key: Key('${playlistArray.indexOf(playlist)}'),
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Card(
            clipBehavior: Clip.hardEdge,
            child: Container(
              color: currentThemeSurfaceContainer(ref),
              width: 160,
              child: GestureDetector(
                onTap: () {
                  // Change!
                  Navigator.push(
                    ContextKey.navKey.currentContext!,
                    MaterialPageRoute(
                        builder: (context) => playlistScreen(ref, playlist)),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 140,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(kDefaultBorderRadius),
                        child: playlist.getImage(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 14, top: 8.0, bottom: 8.0, right: 14),
                      child: playlistText(
                        ref,
                        playlist.playlistName_,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );

Container songBlock(WidgetRef ref, Playlist playlist, int index) => Container(
      key: Key(playlist.songNameList[index]),
      child: GestureDetector(
        onTap: () {
          loadSong(ref, playlist, index);
        },
        child: Container(
          color: currentThemeSurface(ref),
          child: Padding(
            padding: const EdgeInsets.only(
                top: kMediumPadding,
                bottom: kMediumPadding,
                left: kDefaultSmallPadding,
                right: kDefaultSmallPadding),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      songText(
                        ref,
                        (playlist.songList[index] as UriAudioSource).tag.title,
                      ),
                      artistText(
                        ref,
                        (playlist.songList[index] as UriAudioSource).tag.artist,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: kDefaultSmallPadding),
                timeText(
                  ref,
                  (playlist.songList[index] as UriAudioSource)
                      .tag
                      .displayDescription,
                ),
              ],
            ),
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
                  ref, playlist);
            },
            child: headerText(
              ref,
              playlist.playlistName,
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
  double scaling = 4;
  if (!isNotMiniplayer) {
    scaling = 1;
  }
  songWatchState(ref);
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    (isNotMiniplayer) ? shuffleIcon(ref) : Container(),
    skipSongIcon(ref, false, playlist, isNotMiniplayer),
    SizedBox(width: 4 * scaling),
    Transform.scale(scale: (isNotMiniplayer) ? 2: 1, child: playIcon(ref, playlist)),
    SizedBox(width: 4 * scaling),
    skipSongIcon(ref, true, playlist, isNotMiniplayer),
    (isNotMiniplayer) ? loopIcon(ref) : Container(),
  ]);
}

Widget songNameBlock(WidgetRef ref) {
  String songName = player.sequenceState?.currentSource?.tag.title ?? "ERROR";
  String authorName = player.sequenceState?.currentSource?.tag.artist ?? "";
  return Column(
    children: [
      const SizedBox(height: kDefaultSmallPadding),
      Padding(
        padding:
            const EdgeInsets.only(left: kXXXXLPadding, right: kXXXXLPadding),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            songName,
            style: Theme.of(ContextKey.navKey.currentContext!)
                .textTheme
                .displaySmall
                ?.apply(
                  color: currentThemeOnSurface(ref),
                ),
            maxLines: 1,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
            left: kXXXXLPadding + 12, right: kXXXXLPadding + 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            authorName,
            style: Theme.of(ContextKey.navKey.currentContext!)
                .textTheme
                .headlineSmall
                ?.apply(
                  color: currentThemeOnSurfaceVar(ref),
                ),
          ),
        ),
      ),
    ],
  );
}

Widget addSongBlock(ref, playlist, index) => Container(
      child: GestureDetector(
        onTap: () {
          loadSong(ref, playlistArray[0], index);
        },
        child: Container(
          color: currentThemeSurface(ref),
          child: Padding(
            padding: const EdgeInsets.only(
                top: kMediumPadding,
                bottom: kMediumPadding,
                left: kDefaultSmallPadding,
                right: kDefaultSmallPadding),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      songText(
                        ref,
                        (playlistArray[0].songList[index] as UriAudioSource).tag.title,
                      ),
                      artistText(
                        ref,
                        (playlistArray[0].songList[index] as UriAudioSource).tag.artist,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: kDefaultSmallPadding),
                timeText(
                    ref,
                    (playlistArray[0].songList[index] as UriAudioSource)
                        .tag
                        .displayDescription),
                const SizedBox(width: kXSPadding),
                listCheckbox(playlist, playlistArray[0].songList[index], ref),
              ],
            ),
          ),
        ),
      ),
    );
