import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:flutter/material.dart';
import '../../models/audio.dart';
import '../ui.dart';

Widget miniplayer(WidgetRef ref, bool inPlaylist) {
  return (player.sequenceState?.currentSource != null &&
          currentGlobalPlaylist.children.isNotEmpty)
      ? Miniplayer(
          minHeight: 100,
          maxHeight: (inPlaylist) ? 100: 370,
          builder: (height, percentage) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text((player.sequenceState!.currentSource as UriAudioSource)
                      .tag
                      .songName,textAlign: TextAlign.center,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          child: songIconBlock(ref, currentGlobalPlaylist,
                              player.currentIndex!, false)),
                      SizedBox(
                          width: 160,
                          child: songProgressBar(
                              ref, currentGlobalPlaylist, false)),
                    ],
                  ),(height > 100) ? SizedBox(height: height - 100, child: songWaveForm(ref, false)): Container(),
                ]);
          },
        )
      : Container();
}
