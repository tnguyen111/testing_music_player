
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../ui.dart';

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

void loadSong (WidgetRef ref, Playlist playlist, int index)  {
  try {
    if (playlist.songList != player.audioSource) {
      print("playlist changed");
      loadNewPlaylist(playlist, index);
    }
    loadNewSong(ref, playlist, index);
  } on PlayerInterruptedException {
    // do nothing
    print('expected throw');
  }
}