import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../utils/utils.dart';
import 'package:testing_music_player/src/models/models.dart';

class BarWavePainter extends CustomPainter {
  final Uint8List  amplitudes;
  final WidgetRef ref;
  BarWavePainter(this.amplitudes, this.ref);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = currentThemeHeaderText(ref).color!
      ..isAntiAlias = false
      ..shader
      ..style = PaintingStyle.fill;
    final spacing= Paint()
      ..color = currentThemeHeader(ref)
      ..isAntiAlias = false
      ..shader
      ..style = PaintingStyle.fill;

    const barWidth = 300 / 45;
    for (int i = 0; i < 45; i++) {
      final barHeight = amplitudes[i] + 10.0; // Normalize amplitude to fit
      final left = i * barWidth;
      final rectCool = Rect.fromLTWH(left, 300, 5,barHeight-120);
      final rectSpacing =  Rect.fromLTWH(left, 300-barHeight, 5,barHeight);
      final rect = Rect.fromLTWH(left, 300 - barHeight, barWidth, barHeight);
      canvas.drawRect(rect, paint);
      canvas.drawRect(rectSpacing, spacing);
      canvas.drawRect(rectCool, spacing);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint on every frame for animation
  }
}

Widget songWaveForm(WidgetRef ref) {
  return SizedBox(
      width: 300,
      height: 300,
      child: StreamBuilder<VisualizerWaveformCapture>(
        stream: player.visualizerWaveformStream,
        builder: (BuildContext context, snapshot) {
          Uint8List? waveState = snapshot.data?.data ?? Uint8List(300);
          return CustomPaint(painter: BarWavePainter(waveState, ref));
        },
      ));
}

Widget songProgressBar(
    WidgetRef ref, ConcatenatingAudioSource currentPlaylist) {
  return SizedBox(
    width: 330,
    child: StreamBuilder<Duration?>(
        stream: player.positionStream,
        builder: (context, snapshot) {
          final durationState = snapshot.data;

          if (durationState == player.duration && player.nextIndex != null) {
              skipSong(ref, currentPlaylist, player.nextIndex!);
          }

          return ProgressBar(
            progress: durationState ?? const Duration(),
            total: player.duration ?? const Duration(),
            onSeek: (duration) {
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
        }),
  );
}
