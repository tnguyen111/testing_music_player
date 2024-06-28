import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:testing_api_twitter/src/services/services.dart';
import '../utils/utils.dart';
import 'package:testing_api_twitter/src/models/models.dart';

Widget songProgressBar(WidgetRef ref, ConcatenatingAudioSource currentPlaylist) {
  return SizedBox(
    width: 330,
    child: StreamBuilder<Duration?>(
      stream: player.positionStream,
      builder: (context, snapshot) {
        final durationState = snapshot.data;

        if(durationState == player.duration) {
          skipSong(ref, currentPlaylist, player.nextIndex!);
        }
        return ProgressBar(

          progress: durationState??const Duration(),
          total: player.duration??const Duration(),
          onSeek: (duration) {
            print('User selected a new time: $duration');
            player.seek(duration);
          },


          barHeight: 5,
          progressBarColor: currentThemeHeaderText(ref).color,
          bufferedBarColor: currentThemeSub(ref),
          thumbColor: currentThemeHeaderText(ref).color,
          baseBarColor: currentThemeHeader(ref),
          timeLabelLocation: TimeLabelLocation.above,
          timeLabelTextStyle: currentThemeSmallText(ref),
        );
      }
    ),
  );
}
