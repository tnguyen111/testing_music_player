
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/audio.dart';
import '../../services/services.dart';

void pauseSong(WidgetRef ref){
  player.pause();
  player.stopVisualizer();
  songSetState(ref, 1);
}

void startSong(WidgetRef ref){
  player.play();
  player.startVisualizer(enableWaveform: true, captureSize: 1, captureRate: 10000);
  songSetState(ref, 0);
}