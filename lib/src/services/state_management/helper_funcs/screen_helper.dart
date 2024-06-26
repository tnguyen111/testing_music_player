import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';

int screenWatchState(WidgetRef ref){
  return ref.watch(screenProvider);
}

void screenSetState(WidgetRef ref, int state){
  if(state == 0){
    ref.read(screenProvider.notifier).mainMenuScreen();
    return;
  }

  if(state == 1){
    ref.read(screenProvider.notifier).songMenuScreen();
  }

  return;
}