import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import '../providers/providers.dart';

bool playlistWatchState(WidgetRef ref){
  return ref.watch(playlistProvider);
}

bool playlistReadState(WidgetRef ref){
  return ref.watch(playlistProvider);
}

void playlistSwitchState(WidgetRef ref){
  if(ContextKey.navKey.currentContext!.mounted) {
    ref.read(playlistProvider.notifier).switchState();
  }
  return;
}

