import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:flutter/material.dart';
import 'package:testing_music_player/src/services/services.dart';
import '../../../main.dart';
import '../../config/config.dart';
import '../../models/models.dart';
import '../ui.dart';

Widget miniplayer(WidgetRef ref, bool isNotInPlaylist) {
  return (player.sequenceState?.currentSource != null &&
      currentGlobalPlaylist.songList.children.isNotEmpty)
      ? Miniplayer(
    minHeight: 78,
    maxHeight: 78,
    builder: (height, percentage) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: currentThemeSurfaceContainer(
                ref,
              ),
            ),
          ),
          color: currentThemeSurfaceContainerLow(ref),
        ),
        child: Column(children: [
          SizedBox(
            width: MediaQuery
                .sizeOf(ContextKey.navKey.currentContext!)
                .width,
            child: songProgressBar(ref, currentGlobalPlaylist, false),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: kXSPadding,
                bottom: kXSPadding,
                left: kDefaultSmallPadding,
                right: kDefaultSmallPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onHorizontalDragEnd: (details) async {
                    if((player.sequence?.length ?? 0) > 1) {
                      if (details.primaryVelocity! < 0 && player.hasPrevious) {
                        // User swiped Left
                        print('skip to previous');
                        await player.seekToPrevious();
                        songSetState(ref, 2);
                      } else if (details.primaryVelocity! > 0 && player.hasNext) {
                        // User swiped Right
                        print('skip to next');
                        await player.seekToNext();
                        songSetState(ref, 2);
                      }
                    }
                  },
                  onTap: () {
                    for (Playlist playlist in playlistArray) {
                      if (playlist.songList == player.audioSource) {
                        if (playlist != playlistArray[0] && isNotInPlaylist) {
                          Navigator.push(
                            ContextKey.navKey.currentContext!,
                            MaterialPageRoute(
                              builder: (context) =>
                                  playlistScreen(
                                    ref,
                                    playlist,
                                  ),
                            ),
                          );
                        }
                        loadNewSong(
                            ref,
                            playlist,
                            playlist.songList.children.indexOf(player.sequenceState
                                ?.currentSource as IndexedAudioSource));
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: kDefaultSmallPadding),
                    child: (((player.sequenceState!.currentSource
                    as UriAudioSource)
                        .tag
                        .artist) !=
                        '')
                        ? Column(
                      children: [
                        SizedBox(
                          width: 150,
                          child: miniSongText(
                            ref,
                            (player.sequenceState?.currentSource
                            as UriAudioSource)
                                .tag
                                .title ??
                                '',
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: miniArtistText(
                            ref,
                            (player.sequenceState?.currentSource
                            as UriAudioSource)
                                .tag
                                .artist ??
                                '',
                          ),
                        ),
                      ],
                    )
                        : SizedBox(
                      width: 150,
                      child: miniSongText(
                        ref,
                        (player.sequenceState?.currentSource
                        as UriAudioSource)
                            .tag
                            .title ??
                            '',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SizedBox(
                      height: 20,
                      width: 20,
                      child: songWaveForm(ref, false)),
                ),
                SizedBox(
                    child: songIconBlock(ref, currentGlobalPlaylist,
                        player.currentIndex!, false)),
              ],
            ),
          ),
        ]),
      );
    },
  )
      : Container();
}
