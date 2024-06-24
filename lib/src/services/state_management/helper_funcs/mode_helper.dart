import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';

bool modeWatchState(WidgetRef ref){
  return ref.watch(modeProvider);
}

bool modeReadState(WidgetRef ref){
  return ref.watch(modeProvider);
}

void modeSwitchState(WidgetRef ref){
  ref.read(modeProvider.notifier).switchState();

  return;
}

