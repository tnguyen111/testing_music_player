import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../main.dart';
import '../utils/utils.dart';
import 'package:testing_music_player/src/models/models.dart';

Playlist currentGlobalPlaylist =
    Playlist(playlistName_: 'global', imagePath_: '', songNameList_: []);

class BarWavePainter extends CustomPainter {
  final Uint8List amplitudes;
  final WidgetRef ref;
  final bool isNotMiniplayer;

  BarWavePainter(this.amplitudes, this.ref, this.isNotMiniplayer);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = currentThemeOnSurface(ref)
      ..isAntiAlias = false
      ..shader
      ..style = PaintingStyle.fill;
    final spacing = Paint()
      ..color = currentThemeSurface(ref)
      ..isAntiAlias = false
      ..shader
      ..style = PaintingStyle.fill;

    if (isNotMiniplayer) {
      const barWidth = 300 / 45;
      for (int i = 0; i < 45; i++) {
        final barHeight = amplitudes[i] + 10.0; // Normalize amplitude to fit
        final left = i * barWidth;
        final rectSpacing = Rect.fromLTWH(left, 300 - barHeight, 5, barHeight);
        final rect = Rect.fromLTWH(left, 300 - barHeight, barWidth, barHeight);
        canvas.drawRect(rect, paint);
        canvas.drawRect(rectSpacing, spacing);
      }
    } else {
      const barWidth = 300 / 50;
      for (int i = 0; i < 6; i++) {
        final barHeight = amplitudes[i] / 4.5; // Normalize amplitude to fit
        final left = i * barWidth;
        final rectSpacing = Rect.fromCenter(
            center: Offset(left, 10), width: 3, height: barHeight + 0.0);
        final rect = Rect.fromCenter(
            center: Offset(left, 10), width: barWidth, height: barHeight + 0.0);
        canvas.drawRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(0)), spacing);
        canvas.drawRRect(
            RRect.fromRectAndRadius(rectSpacing, const Radius.circular(15)),
            paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint on every frame for animation
  }
}

Widget songWaveForm(WidgetRef ref, bool isNotMiniplayer) {
  return SizedBox(
      width: (isNotMiniplayer) ? 300 : 30,
      height: 300,
      child: StreamBuilder<VisualizerWaveformCapture>(
        stream: player.visualizerWaveformStream,
        builder: (BuildContext context, snapshot) {
          Uint8List? waveState = snapshot.data?.data ?? Uint8List(300);
          return CustomPaint(
              painter: BarWavePainter(waveState, ref, isNotMiniplayer));
        },
      ));
}

Widget songProgressBar(
    WidgetRef ref, Playlist currentPlaylist, bool isNotMiniplayer) {
  return SizedBox(
    width: 330,
    child: StreamBuilder<Duration?>(
        stream: player.positionStream,
        builder: (context, snapshot) {
          final durationState = snapshot.data;
          currentGlobalPlaylist = currentPlaylist;
          if (durationState == player.duration &&
              player.duration != Duration.zero &&
              player.position != Duration.zero &&
              player.nextIndex != null &&
              player.playing) {
            print('song end');
            skipSong(ref, currentPlaylist, player.nextIndex!, isNotMiniplayer);
          }

          return ProgressBar(
            progress: durationState ?? const Duration(),
            total: player.duration ?? const Duration(),
            onSeek: (duration) {
              player.seek(duration);
            },
            barHeight: (isNotMiniplayer) ? 5 : 4,
            progressBarColor: currentThemeOnSurfaceVar(ref),
            bufferedBarColor: currentThemeSurfaceContainer(ref),
            thumbRadius: (isNotMiniplayer) ? 10 : 4,
            thumbColor: currentThemeOnSurface(ref),
            baseBarColor: currentThemeSurfaceContainerHighest(ref),
            timeLabelLocation: (isNotMiniplayer)
                ? TimeLabelLocation.above
                : TimeLabelLocation.none,
            timeLabelTextStyle: Theme.of(ContextKey.navKey.currentContext!)
                .textTheme
                .bodyLarge
                ?.apply(
                  color: currentThemeOnSurfaceVar(ref),
                ),
          );
        }),
  );
}
