import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import '../providers/providers.dart';

int screenWatchState(WidgetRef ref){
  return ref.watch(screenProvider);
}

int screenReadState(WidgetRef ref){
  return ref.read(screenProvider);
}

void screenSetState(WidgetRef ref, int state){
  if(ContextKey.navKey.currentContext!.mounted) {
    if (state == 0) {
      ref.read(screenProvider.notifier).settingMenuScreen();
      return;
    }

    if (state == 1) {
      ref.read(screenProvider.notifier).mainMenuScreen();
    }

    if (state == 2) {
      ref.read(screenProvider.notifier).songMenuScreen();
    }
  }

  return;
}