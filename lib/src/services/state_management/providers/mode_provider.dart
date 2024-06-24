import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/mode_notifier.dart';

final modeProvider = NotifierProvider<ModeNotifier, bool>(() {
  return ModeNotifier();
});