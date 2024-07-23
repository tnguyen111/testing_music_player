import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:flutter/material.dart';
import '../../models/audio.dart';
import '../ui.dart';
import 'package:text_scroll/text_scroll.dart';

Widget miniplayer(WidgetRef ref) {
  return (player.sequenceState?.currentSource != null &&
          currentGlobalPlaylist.songList.children.isNotEmpty)
      ? Container(
          //color: currentThemeSub(ref),
          child: Miniplayer(
            minHeight: 74,
            maxHeight: 74,
            builder: (height, percentage) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4,bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0, right: 18),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: TextScroll(
                                    (player.sequenceState!.currentSource
                                            as UriAudioSource)
                                        .tag
                                        .title,
                                    mode: TextScrollMode.endless,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: TextScroll(
                                    (player.sequenceState!.currentSource
                                    as UriAudioSource)
                                        .tag
                                        .artist,
                                    mode: TextScrollMode.endless,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: 20,
                              width: 20,
                              child: songWaveForm(ref, false)),
                          SizedBox(
                              child: songIconBlock(ref, currentGlobalPlaylist,
                                  player.currentIndex!, false)),
                        ],
                      ),
                    ),
                    SizedBox(
                        width: 350,
                        child:
                            songProgressBar(ref, currentGlobalPlaylist, false)),
                  ]);
            },
          ),
        )
      : Container();
}
