import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import '../providers/providers.dart';

int songWatchState(WidgetRef ref){
  return ref.watch(songProvider);
}

void songSetState(WidgetRef ref, int state){
  if(ContextKey.navKey.currentContext!.mounted) {
    if (state == 0) {
      ref.read(songProvider.notifier).playSong();
      return;
    }

    if (state == 1) {
      ref.read(songProvider.notifier).pauseSong();
      return;
    }

    if (state == 2) {
      ref.read(songProvider.notifier).changeSong();
      songSetState(ref, 0);
      return;
    }
  }

  return;
}