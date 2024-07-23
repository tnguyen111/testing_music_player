import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import '../providers/providers.dart';

bool modeWatchState(WidgetRef ref){
  return ref.watch(modeProvider);
}

bool modeReadState(WidgetRef ref){
  return ref.read(modeProvider);
}

void modeSwitchState(WidgetRef ref){
  if(ContextKey.navKey.currentContext!.mounted) {
    ref.read(modeProvider.notifier).switchState();
  }
  return;
}

