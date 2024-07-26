import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../config/config.dart';
import '../../models/audio.dart';
import '../ui.dart';

Widget miniplayer(WidgetRef ref) {
  return (player.sequenceState?.currentSource != null &&
          currentGlobalPlaylist.songList.children.isNotEmpty)
      ? Miniplayer(
          minHeight: 76,
          maxHeight: 76,
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
                  width: MediaQuery.sizeOf(ContextKey.navKey.currentContext!)
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
                      Padding(
                        padding:
                            const EdgeInsets.only(right: kDefaultSmallPadding),
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
                                      (player.sequenceState!.currentSource
                                              as UriAudioSource)
                                          .tag
                                          .title,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: miniArtistText(
                                      ref,
                                      (player.sequenceState!.currentSource
                                              as UriAudioSource)
                                          .tag
                                          .artist,
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(
                                width: 150,
                                child: miniSongText(
                                  ref,
                                  (player.sequenceState!.currentSource
                                          as UriAudioSource)
                                      .tag
                                      .title,
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
